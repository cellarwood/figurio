---
name: api-design
description: >
  REST API conventions for Figurio's FastAPI backend — endpoint naming for
  products, orders, and users; pagination and error response shapes; Stripe
  checkout session and webhook integration patterns; order lifecycle state
  machine. Use whenever designing or reviewing API endpoints for the Figurio
  platform.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - backend
---

# API Design

## URL Structure

All Figurio API endpoints are versioned and grouped by resource:

```
/api/v1/products
/api/v1/products/{sku}
/api/v1/products/{sku}/images
/api/v1/categories
/api/v1/categories/{slug}/products

/api/v1/orders
/api/v1/orders/{order_id}
/api/v1/orders/{order_id}/items

/api/v1/users/me
/api/v1/users/me/orders

/api/v1/checkout/session          # create Stripe checkout session
/api/v1/webhooks/stripe           # Stripe webhook receiver

/api/v1/ai/generate               # submit AI custom figurine job
/api/v1/ai/jobs/{job_id}          # poll AI generation job status
```

Rules:
- Resource names are **plural nouns** in kebab-case (`size-tiers`, not `sizeTier`)
- SKUs are used as natural IDs for products; UUIDs for orders, users, jobs
- No trailing slashes

## Request / Response Conventions

### Pagination

All collection endpoints return the same envelope:

```json
{
  "items": [...],
  "total": 142,
  "page": 1,
  "page_size": 20,
  "pages": 8
}
```

Query params: `?page=1&page_size=20` (default page_size: 20, max: 100).

### Error Responses

All errors follow a consistent shape. Use FastAPI's `HTTPException` with a detail dict — never a plain string for client-facing errors:

```json
{
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order abc123 does not exist.",
    "field": null
  }
}
```

`code` is a SCREAMING_SNAKE_CASE string used by the frontend for i18n.
`field` is populated for validation errors (points to the offending request field).

Standard error codes:

| HTTP status | code |
|-------------|------|
| 400 | `INVALID_REQUEST` |
| 401 | `UNAUTHENTICATED` |
| 403 | `FORBIDDEN` |
| 404 | `{RESOURCE}_NOT_FOUND` |
| 409 | `{RESOURCE}_CONFLICT` |
| 422 | `VALIDATION_ERROR` |
| 500 | `INTERNAL_ERROR` |

Implement a shared `ErrorResponse` Pydantic model and a FastAPI exception handler that converts `HTTPException` to this shape.

### Success Responses

- Single resource: return the resource object directly (no envelope)
- Created resource: `201 Created` with the resource object
- Deleted resource: `204 No Content` with empty body
- Collection: pagination envelope (see above)

## Stripe Integration

### Checkout Session

`POST /api/v1/checkout/session` creates a Stripe Checkout session for a pending order.

Flow:
1. Validate the order belongs to the authenticated user and is in `PENDING` state
2. Call `stripe.checkout.Session.create()` with `line_items` mapped from order items
3. Set `metadata={"order_id": str(order.id)}` on the session — this is how webhooks correlate events back to orders
4. Set `success_url` and `cancel_url` pointing to the frontend
5. Return `{"checkout_url": session.url}` — the frontend redirects the user

Never store raw Stripe session IDs as the source of truth for payment status — use webhook events instead.

### Webhook Handler

`POST /api/v1/webhooks/stripe` — unauthenticated, verified by Stripe signature.

```python
@router.post("/webhooks/stripe", status_code=200)
async def stripe_webhook(request: Request):
    payload = await request.body()
    sig = request.headers.get("stripe-signature")
    event = stripe.Webhook.construct_event(payload, sig, settings.STRIPE_WEBHOOK_SECRET)
    # dispatch by event type
```

Events to handle:

| Stripe event | Action |
|---|---|
| `checkout.session.completed` | Transition order `PENDING` → `PAID`; persist `stripe_payment_intent_id` |
| `checkout.session.expired` | Transition order `PENDING` → `CANCELLED` |
| `charge.refunded` | Transition order `PAID` → `REFUNDED` |

Always return `200` quickly and process asynchronously (or in a background task) to avoid Stripe retry storms. Log unhandled event types but do not error.

## Order Lifecycle State Machine

```
PENDING → PAID → PROCESSING → SHIPPED → DELIVERED
   │         │
   └─────────┴──→ CANCELLED
                      │
              PAID ──→ REFUNDED
```

Valid transitions (enforce in the service layer, not the router):

| From | To | Trigger |
|---|---|---|
| `PENDING` | `PAID` | `checkout.session.completed` webhook |
| `PENDING` | `CANCELLED` | `checkout.session.expired` webhook or user cancellation |
| `PAID` | `PROCESSING` | MCAE fulfillment job started |
| `PAID` | `CANCELLED` | Admin cancellation before fulfillment |
| `PROCESSING` | `SHIPPED` | Tracking number recorded |
| `SHIPPED` | `DELIVERED` | Delivery confirmed |
| `PAID` | `REFUNDED` | `charge.refunded` webhook |
| `CANCELLED` | — | Terminal state |
| `DELIVERED` | — | Terminal state |
| `REFUNDED` | — | Terminal state |

Attempting an invalid transition raises `409 INVALID_ORDER_TRANSITION`.

## FastAPI Router Layout

Routers live in `app/routers/` and are included in `app/main.py`:

```python
# app/routers/products.py  → prefix="/api/v1/products"
# app/routers/orders.py    → prefix="/api/v1/orders"
# app/routers/users.py     → prefix="/api/v1/users"
# app/routers/checkout.py  → prefix="/api/v1/checkout"
# app/routers/webhooks.py  → prefix="/api/v1/webhooks"
# app/routers/ai.py        → prefix="/api/v1/ai"
```

Each router only handles HTTP wiring. Business logic lives in `app/services/`. Database access lives in `app/repositories/`.
