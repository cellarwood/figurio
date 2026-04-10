---
name: api-design
description: >
  REST API conventions for the Figurio D2C figurine platform. Covers endpoint
  naming, request/response shapes, pagination, error responses, JWT
  authentication, Stripe payment integration, and the order lifecycle endpoint
  contract.
allowed-tools:
  - Read
  - Grep
  - Write
metadata:
  paperclip:
    tags:
      - engineering
      - backend
---

# API Design

Conventions for every FastAPI route handler in the Figurio backend. Follow these when building new endpoints or reviewing existing ones.

## URL Structure

All public endpoints are versioned under `/api/v1/`. Admin-only endpoints live under `/api/v1/admin/`.

```
/api/v1/products                      # catalog collection
/api/v1/products/{product_id}         # single product
/api/v1/products/{product_id}/variants
/api/v1/orders                        # customer order collection
/api/v1/orders/{order_id}
/api/v1/orders/{order_id}/transitions # trigger a state change
/api/v1/payments/checkout             # create Stripe checkout session
/api/v1/payments/refund
/api/v1/users/me
/api/v1/users/me/orders
/api/v1/admin/orders                  # admin order management
/api/v1/admin/orders/{order_id}/override
/api/v1/admin/catalog                 # admin catalog management
/webhooks/stripe                      # NOT under /api — Stripe webhooks
```

Rules:
- Resource names are plural nouns, kebab-case (`/size-tiers`, not `/sizeTiers`).
- Actions that are not CRUD go on sub-resources (`/transitions`, `/refund`), not verbs on the root.
- The Stripe webhook endpoint is at `/webhooks/stripe` (top-level, no version prefix).

## Request and Response Shapes

Use Pydantic models for all request bodies and response schemas. Never return raw ORM objects.

**Collection response:**
```python
class PaginatedResponse(BaseModel, Generic[T]):
    items: list[T]
    total: int
    page: int
    page_size: int
    has_next: bool
```

**Single-resource response:** return the resource schema directly (no wrapper).

**Request body:** name schemas `{Resource}Create`, `{Resource}Update`, `{Resource}Response`.

```python
class OrderResponse(BaseModel):
    id: UUID
    status: OrderStatus          # enum, not raw string
    created_at: datetime
    updated_at: datetime
    total_amount_cents: int      # always store/return money as integer cents
    currency: str                # ISO 4217, e.g. "usd"
    line_items: list[LineItemResponse]

    model_config = ConfigDict(from_attributes=True)
```

Money is **always in cents as `int`**. Never use `float` for currency values.

## Pagination

All collection endpoints accept `page` (1-indexed) and `page_size` (default 20, max 100) as query parameters.

```python
@router.get("/products", response_model=PaginatedResponse[ProductResponse])
async def list_products(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: AsyncSession = Depends(get_db),
):
    ...
```

## Error Responses

All errors use a consistent envelope:

```json
{
  "error": {
    "code": "order_not_found",
    "message": "Order abc123 does not exist.",
    "details": {}
  }
}
```

Standard codes and HTTP status mappings:

| Code | HTTP | When |
|------|------|------|
| `not_found` | 404 | Resource missing |
| `validation_error` | 422 | Pydantic / business rule violation |
| `unauthorized` | 401 | Missing or invalid JWT |
| `forbidden` | 403 | Valid JWT but wrong role |
| `invalid_transition` | 409 | Illegal order state change |
| `payment_failed` | 402 | Stripe charge declined |
| `stripe_signature_invalid` | 400 | Webhook HMAC mismatch |
| `internal_error` | 500 | Unhandled exception |

Use `HTTPException` with a detail dict matching the envelope, or a custom exception handler that converts domain exceptions to this shape.

## Authentication

JWT-based. Two roles: `customer` and `admin`.

```python
# Dependency for any authenticated route
async def current_user(token: str = Depends(oauth2_scheme), db=...) -> User:
    ...

# Dependency that additionally enforces admin role
async def require_admin(user: User = Depends(current_user)) -> User:
    if user.role != "admin":
        raise HTTPException(status_code=403, detail={"error": {"code": "forbidden", ...}})
    return user
```

- Tokens: short-lived access token (15 min) + refresh token (7 days).
- Issue tokens at `POST /api/v1/auth/token`.
- Refresh at `POST /api/v1/auth/refresh`.
- Do not put secrets or PII in the JWT payload — only `user_id`, `role`, and standard claims (`iat`, `exp`).

## Stripe Payment Integration

**Checkout session creation (`POST /api/v1/payments/checkout`):**

```python
session = stripe.checkout.Session.create(
    mode="payment",
    payment_method_types=["card"],
    line_items=[...],
    metadata={"order_id": str(order.id)},   # always attach order_id
    idempotency_key=str(order.id),            # prevent duplicate sessions
    success_url=...,
    cancel_url=...,
)
```

**Webhook handler (`POST /webhooks/stripe`):**

```python
@router.post("/webhooks/stripe")
async def stripe_webhook(request: Request):
    payload = await request.body()
    sig = request.headers.get("stripe-signature")
    try:
        event = stripe.Webhook.construct_event(payload, sig, settings.STRIPE_WEBHOOK_SECRET)
    except stripe.error.SignatureVerificationError:
        raise HTTPException(status_code=400, detail={"error": {"code": "stripe_signature_invalid", ...}})

    # Acknowledge immediately, process after
    await handle_stripe_event(event)
    return {"received": True}
```

Signature verification is **mandatory** — never bypass it except in isolated test environments with explicit CTO approval.

Idempotency: use the Stripe event `id` as the idempotency key when recording payment events. Check whether the event has already been processed before executing side effects.

## Order Lifecycle Endpoints

Order status enum: `placed` → `paid` → `preparing` → `printing` → `shipped` → `delivered`.
Failure branches: `payment_failed`, `cancelled`.

```
POST   /api/v1/orders                          # create order (status: placed)
GET    /api/v1/orders/{order_id}               # fetch order + current status
POST   /api/v1/orders/{order_id}/transitions   # trigger state change
GET    /api/v1/admin/orders/{order_id}/audit   # full audit log
POST   /api/v1/admin/orders/{order_id}/override # admin-only manual override
```

Transition request body:
```json
{
  "to_status": "preparing",
  "reason": "Payment confirmed via Stripe event evt_xxx"
}
```

Return `409 invalid_transition` if the transition is not permitted from the current state. Every successful transition must write an `order_audit_log` row before returning.

## Anti-patterns

- Do not expose SQLAlchemy model objects directly in responses — always use Pydantic schemas.
- Do not use `float` for money amounts — use integer cents.
- Do not skip `idempotency_key` on Stripe calls.
- Do not perform destructive DB operations in route handlers — call a service layer function.
- Do not mix admin and customer logic in the same router file.
- Do not return a 200 when an error occurred — use the correct HTTP status code.
