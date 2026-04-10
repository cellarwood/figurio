---
name: api-design
description: >
  REST API conventions for Figurio's FastAPI backend. Covers endpoint naming,
  pagination, error responses, authentication patterns, Stripe payment integration,
  and the order state machine for catalog and AI-custom ("Prompt to Print") figurine orders.
metadata:
  paperclip:
    tags:
      - engineering
      - backend
---

# API Design

## URL Structure

All Figurio API endpoints follow:

- `/api/v1/{resource}` — collections
- `/api/v1/{resource}/{id}` — single items
- `/api/v1/{resource}/{id}/{sub-resource}` — nested sub-resources

Resource naming uses lowercase kebab-case plural nouns:

```
/api/v1/products
/api/v1/products/{product_id}
/api/v1/orders
/api/v1/orders/{order_id}
/api/v1/orders/{order_id}/items
/api/v1/custom-figurines
/api/v1/custom-figurines/{figurine_id}
/api/v1/customers/{customer_id}/orders
```

## Authentication

All endpoints (except `/api/v1/auth/*` and public product catalog reads) require a Bearer JWT in the `Authorization` header. The JWT encodes `customer_id`, `email`, and `role` (`customer` or `admin`).

```
Authorization: Bearer <jwt>
```

Admin-only routes are protected by a `require_admin` dependency. Never expose internal IDs (e.g., raw DB primary keys) in routes accessible to customers — use UUIDs.

Stripe webhook endpoints authenticate via `Stripe-Signature` header, verified with `stripe.WebhookSignature.verify_header`. Webhook routes live under `/api/v1/webhooks/stripe`.

## Request and Response Conventions

- All request/response bodies are JSON.
- Use Pydantic v2 models for all request bodies and response schemas. Never return raw SQLAlchemy ORM objects.
- `snake_case` for all JSON field names.
- Timestamps are ISO 8601 UTC strings: `"2024-03-15T10:30:00Z"`.
- Monetary values (prices, totals) are integers in CZK halers (i.e., smallest unit) — never floats.
- Product SKUs are strings, not integers.

## Pagination

All list endpoints support cursor-based pagination using `after` and `limit` query parameters:

```
GET /api/v1/products?limit=20&after=<cursor>
```

Response envelope for paginated lists:

```json
{
  "data": [...],
  "pagination": {
    "limit": 20,
    "after": "<next_cursor>",
    "has_more": true
  }
}
```

Default `limit` is 20, maximum is 100. `after` is an opaque base64-encoded cursor (encodes the last item's `id` and `created_at`). Never expose raw SQL offsets as pagination parameters.

## Error Responses

All errors use a consistent envelope:

```json
{
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order with id 'abc123' does not exist.",
    "details": {}
  }
}
```

Standard HTTP status codes:

| Status | Use case |
|--------|----------|
| 400 | Validation errors, bad request |
| 401 | Missing or invalid JWT |
| 403 | Authenticated but unauthorized (e.g., customer accessing another's order) |
| 404 | Resource not found |
| 409 | State conflict (e.g., attempting to cancel a shipped order) |
| 422 | Pydantic validation failure (FastAPI default) |
| 500 | Unexpected server error |

Error `code` values are SCREAMING_SNAKE_CASE and domain-specific (e.g., `INVALID_FIGURINE_PROMPT`, `STRIPE_PAYMENT_FAILED`, `ORDER_STATE_CONFLICT`).

Pydantic 422 validation errors are reformatted into the standard envelope by a global exception handler — do not return FastAPI's default 422 structure to clients.

## Order State Machine

All orders (catalog and custom figurine) progress through these states. Invalid transitions return `409 ORDER_STATE_CONFLICT`.

```
PENDING_PAYMENT
    → PAID              (Stripe webhook: payment_intent.succeeded)
    → CANCELLED         (payment_intent.payment_failed or manual cancel before payment)

PAID
    → IN_PRODUCTION     (admin marks order as sent to MCAE)
    → CANCELLED         (admin cancel, triggers Stripe refund)

IN_PRODUCTION
    → SHIPPED           (admin records tracking number)

SHIPPED
    → DELIVERED         (admin confirms delivery)
```

Custom figurine orders have an additional pre-payment state:

```
PROMPT_RECEIVED
    → RENDER_IN_PROGRESS  (AI generation started)
    → RENDER_COMPLETE     (customer approval pending)
    → PENDING_PAYMENT     (customer approved render)
    → RENDER_REJECTED     (customer rejected render — loops back to PROMPT_RECEIVED)
```

State transitions are performed via dedicated action endpoints, not PATCH on `status`:

```
POST /api/v1/orders/{order_id}/cancel
POST /api/v1/orders/{order_id}/mark-in-production
POST /api/v1/orders/{order_id}/mark-shipped
POST /api/v1/custom-figurines/{figurine_id}/approve-render
POST /api/v1/custom-figurines/{figurine_id}/reject-render
```

## Stripe Payment Integration

All orders are prepaid. The payment flow:

1. Client calls `POST /api/v1/orders/{order_id}/create-payment-intent` — returns a `client_secret`.
2. Client completes payment in browser using Stripe.js.
3. Stripe calls `/api/v1/webhooks/stripe` with `payment_intent.succeeded` — backend transitions order to `PAID`.

Never trust client-side confirmation. Always rely on the Stripe webhook to advance order state. Store `stripe_payment_intent_id` on the order record. Idempotency keys for PaymentIntent creation use `order_id` as the key prefix.

Refunds are initiated server-side via `stripe.Refund.create(payment_intent=...)` — never expose Stripe secret keys to the client.

## FastAPI Conventions

- Group routes with `APIRouter`, one router per domain module (e.g., `orders`, `products`, `customers`, `custom_figurines`).
- Use FastAPI `Depends` for auth, DB session, and pagination parameter injection.
- Async route handlers and async SQLAlchemy sessions throughout — no synchronous DB calls.
- Background tasks (e.g., triggering AI render) use FastAPI `BackgroundTasks` for lightweight work, or enqueue to a task queue for long-running jobs.
