---
name: api-design
description: >
  REST API conventions for the Figurio D2C 3D-figurine platform built with FastAPI.
  Covers endpoint naming for catalog products, AI generation job queue, order pipeline,
  Stripe checkout and webhook integration, pagination, error responses, and authentication patterns.
allowed-tools:
  - Read
  - Grep
  - Write
  - Bash
metadata:
  paperclip:
    tags: [engineering, backend, api]
---

# API Design

## Base URL Structure

All public API endpoints live under `/api/v1/`. Services are grouped by resource domain.

```
/api/v1/products/          # Catalog figurines
/api/v1/orders/            # Order lifecycle
/api/v1/generation-jobs/   # AI prompt-to-print pipeline
/api/v1/users/             # Account management
/api/v1/webhooks/stripe    # Stripe event sink (no /v1/ version prefix — Stripe controls the URL)
```

## Endpoint Naming

- Collections: plural noun, no trailing slash — `/api/v1/products`
- Single resource: `/{id}` suffix — `/api/v1/products/{product_id}`
- Sub-resources follow the parent: `/api/v1/orders/{order_id}/items`
- Actions that are not CRUD go on a verb sub-path: `/api/v1/generation-jobs/{job_id}/approve`
- Use kebab-case for multi-word path segments: `/api/v1/generation-jobs`

## Key Resource Endpoints

### Products (Catalog)

```
GET    /api/v1/products                  # paginated list with filters
GET    /api/v1/products/{product_id}     # detail
POST   /api/v1/products                  # admin: create
PATCH  /api/v1/products/{product_id}     # admin: update
DELETE /api/v1/products/{product_id}     # admin: soft-delete (sets is_active=false)
```

Query params: `?category=fantasy&size_tier=medium&page=1&page_size=20`

### Orders

```
POST   /api/v1/orders                         # create order, returns checkout session URL
GET    /api/v1/orders/{order_id}              # order detail + current state
GET    /api/v1/orders                         # user's orders (paginated)
POST   /api/v1/orders/{order_id}/cancel       # request cancellation (only in placed state)
```

Orders are created with status `placed`. The state machine is driven by Stripe webhooks
and internal transitions — never by direct PATCH to the status field from outside.

### AI Generation Jobs

```
POST   /api/v1/generation-jobs                        # submit prompt, creates job
GET    /api/v1/generation-jobs/{job_id}               # poll status + preview URL
POST   /api/v1/generation-jobs/{job_id}/approve       # customer approves preview → triggers order
POST   /api/v1/generation-jobs/{job_id}/reject        # customer rejects → job loops back to queued
GET    /api/v1/generation-jobs                        # user's jobs (paginated)
```

Job polling should be done client-side at a reasonable interval (5–10 seconds). Do not
use long-polling or SSE for the MVP — simple GET is sufficient.

### Stripe Integration

#### Checkout

Order creation (`POST /api/v1/orders`) responds with a Stripe Checkout Session URL.
The frontend redirects the customer there. Do not handle card data server-side.

```python
# Response shape for POST /api/v1/orders
{
  "order_id": "ord_abc123",
  "checkout_url": "https://checkout.stripe.com/pay/cs_live_..."
}
```

For AI-custom orders, a 50% deposit Checkout Session is created at job submission
(`POST /api/v1/generation-jobs`). The remaining 50% is charged on approval.

#### Webhooks

All Stripe events are received at `POST /webhooks/stripe`.

- Verify the `Stripe-Signature` header using `stripe.Webhook.construct_event()` before processing.
- Return `200 OK` immediately after signature verification, then process async to avoid Stripe retries.
- Events handled: `checkout.session.completed`, `payment_intent.succeeded`,
  `payment_intent.payment_failed`, `charge.dispute.created`.

```python
@router.post("/webhooks/stripe", status_code=200)
async def stripe_webhook(request: Request, background_tasks: BackgroundTasks):
    payload = await request.body()
    sig = request.headers.get("stripe-signature")
    event = stripe.Webhook.construct_event(payload, sig, settings.STRIPE_WEBHOOK_SECRET)
    background_tasks.add_task(handle_stripe_event, event)
    return {"received": True}
```

## Authentication

- JWT Bearer tokens for all authenticated endpoints.
- Token issued at `/api/v1/auth/token` (POST, body: email + password).
- Token refresh at `/api/v1/auth/refresh`.
- Admin-only endpoints protected by a `require_admin` dependency — check `user.role == "admin"`.
- The Stripe webhook endpoint is authenticated by signature verification only — no JWT.

```python
# Dependency pattern
async def get_current_user(token: str = Depends(oauth2_scheme), db: AsyncSession = Depends(get_db)) -> User:
    ...

async def require_admin(user: User = Depends(get_current_user)) -> User:
    if user.role != "admin":
        raise HTTPException(status_code=403, detail="Admin access required")
    return user
```

## Pagination

All list endpoints use cursor-free offset pagination for the MVP.

**Request:** `?page=1&page_size=20` (page is 1-indexed; default page_size=20, max=100)

**Response envelope:**

```json
{
  "items": [...],
  "total": 142,
  "page": 1,
  "page_size": 20,
  "pages": 8
}
```

Use a shared `PaginatedResponse[T]` generic Pydantic model — do not repeat this shape per endpoint.

## Error Responses

All errors follow a single envelope:

```json
{
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order ord_abc123 does not exist.",
    "details": {}
  }
}
```

| HTTP Status | When to use |
|-------------|-------------|
| 400 | Validation errors, bad request body |
| 401 | Missing or invalid token |
| 403 | Authenticated but insufficient permissions |
| 404 | Resource not found |
| 409 | State conflict (e.g., cancelling a shipped order) |
| 422 | FastAPI/Pydantic schema validation failure (default behavior) |
| 500 | Unexpected server error — never leak stack traces |

Use string `code` values in SCREAMING_SNAKE_CASE for programmatic handling by the frontend.

## Request / Response Schemas

- Define separate Pydantic models for request body (input) and response (output) — never reuse the ORM model directly.
- Naming convention: `ProductCreate`, `ProductUpdate`, `ProductResponse`, `ProductListResponse`.
- All timestamps as ISO 8601 strings in UTC: `"2026-04-11T14:00:00Z"`.
- Monetary amounts in **integer cents** (CZK or EUR), never floats. Include the currency code field.
- Size tier values: `"small"`, `"medium"`, `"large"` (lowercase string enum).

## Versioning

The current version is `v1`. Breaking changes require a new prefix (`/api/v2/...`).
Non-breaking additions (new optional fields, new endpoints) do not require a version bump.
