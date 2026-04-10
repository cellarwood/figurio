---
name: api-design
description: >
  REST API conventions for Figurio, the D2C 3D-printed figurine platform.
  Covers endpoint naming, cursor-based pagination, structured error responses,
  JWT authentication, Stripe checkout/webhook integration, two-stage payment
  flows for custom figurines, and AI text-to-3D generation job endpoints.
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

## URL Structure

All Figurio API endpoints are versioned under `/api/v1/`.

| Resource | Collection | Single Item |
|----------|------------|-------------|
| Products | `/api/v1/products` | `/api/v1/products/{product_id}` |
| Orders | `/api/v1/orders` | `/api/v1/orders/{order_id}` |
| Generation Jobs | `/api/v1/generation-jobs` | `/api/v1/generation-jobs/{job_id}` |
| Payments | `/api/v1/payments` | `/api/v1/payments/{payment_id}` |
| Webhooks (Stripe) | `/api/v1/webhooks/stripe` | — |

Use kebab-case for multi-word path segments. Use UUIDs (v4) for all resource IDs.

## Authentication

All endpoints except `/api/v1/webhooks/stripe` and public product listing require a bearer token:

```
Authorization: Bearer <jwt>
```

JWTs are short-lived (15 min). Clients refresh via `POST /api/v1/auth/refresh` using an `HttpOnly` cookie holding the refresh token.

Webhook endpoints authenticate via Stripe signature header (`Stripe-Signature`), verified with `stripe.WebhookSignature.verify_header`. Never use bearer auth on webhook routes.

## Pagination (Cursor-Based)

All list endpoints use cursor-based pagination — never offset/page-number.

**Request:**
```
GET /api/v1/orders?limit=20&cursor=<opaque_cursor>
```

**Response envelope:**
```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6InV1aWQiLCJkaXIiOiJuZXh0In0=",
    "has_more": true,
    "limit": 20
  }
}
```

- `cursor` is a base64-encoded JSON blob containing the last-seen `id` and sort direction.
- Return `"next_cursor": null` and `"has_more": false` when no further pages exist.
- Default `limit` is 20; max is 100.
- Sorting is always by `created_at DESC` unless the endpoint documents otherwise.

## Error Responses

Always return `application/json` error bodies. Never expose stack traces.

```json
{
  "error": {
    "code": "order_not_found",
    "message": "Order f3a1... does not exist or is not accessible.",
    "details": {}
  }
}
```

| Situation | HTTP Status | `code` example |
|-----------|-------------|----------------|
| Not found | 404 | `order_not_found` |
| Validation failure | 422 | `invalid_size_tier` |
| Unauthenticated | 401 | `token_expired` |
| Forbidden | 403 | `insufficient_permissions` |
| Stripe decline | 402 | `payment_declined` |
| Generation failure | 422 | `generation_job_failed` |
| Rate limit | 429 | `rate_limit_exceeded` |
| Internal error | 500 | `internal_error` |

`code` values are snake_case strings — use them in client code, not `message`.

## Stripe Payment Integration

### Standard Checkout (Catalog Products)

1. `POST /api/v1/orders` — create order, returns `order_id` in `pending` state.
2. `POST /api/v1/orders/{order_id}/checkout` — creates Stripe Checkout Session, returns `{ "checkout_url": "https://checkout.stripe.com/..." }`.
3. Redirect customer to `checkout_url`.
4. Stripe sends `checkout.session.completed` to `/api/v1/webhooks/stripe` — handler transitions order to `paid`.

### Two-Stage Payment (Custom Figurines)

Custom figurines go through AI generation before the final price is known.

**Stage 1 — Design deposit:**
1. `POST /api/v1/generation-jobs` — submit text prompt and size tier. Returns `job_id`.
2. `POST /api/v1/generation-jobs/{job_id}/deposit-checkout` — creates Stripe Checkout Session for the deposit (fixed per size tier: Small $5, Medium $10, Large $20). Returns `checkout_url`.
3. On `checkout.session.completed`: mark job as `deposit_paid`, enqueue AI generation task.

**Stage 2 — Balance payment after generation:**
1. When job reaches `completed` status, `POST /api/v1/generation-jobs/{job_id}/finalize` creates an order linked to the job and generates a Stripe PaymentIntent for the balance (full price minus deposit).
2. Client confirms via Stripe Elements or redirect.
3. On `payment_intent.succeeded`: order transitions to `paid`, fulfillment begins.

**Webhook handler rules:**
- Always verify `Stripe-Signature` before processing any event.
- Use idempotency: check if the event has already been processed by `stripe_event_id` before mutating state.
- Return `200` for events you don't handle — never return `4xx` for unknown event types.

## AI Generation Job Endpoints

```
POST   /api/v1/generation-jobs          # submit prompt + size_tier
GET    /api/v1/generation-jobs/{job_id} # poll status
DELETE /api/v1/generation-jobs/{job_id} # cancel (only if queued)
GET    /api/v1/generation-jobs          # list jobs for authenticated customer
```

**Job status values (ordered):**
`queued` → `deposit_pending` → `deposit_paid` → `generating` → `review` → `completed` | `failed`

Status polling response:
```json
{
  "job_id": "uuid",
  "status": "generating",
  "size_tier": "medium",
  "prompt": "A dragon holding a sword",
  "preview_url": null,
  "created_at": "2026-04-10T09:00:00Z",
  "updated_at": "2026-04-10T09:05:00Z",
  "estimated_completion_at": "2026-04-10T09:20:00Z"
}
```

`preview_url` is populated once the job reaches `review` status. Clients should poll at most every 5 seconds; document this in API responses via a `Retry-After` header (value: `5`).

## FastAPI Implementation Notes

- Use `APIRouter` per domain: `products`, `orders`, `generation_jobs`, `payments`, `webhooks`.
- Declare all request/response shapes as Pydantic v2 models.
- Use `async def` for all route handlers — never block the event loop.
- Dependency-inject the async SQLAlchemy session via `Depends(get_db)`.
- Stripe calls go through a thin `StripeClient` service class, not inline in route handlers.

## Anti-Patterns

- Do not use offset/page pagination — cursors only.
- Do not put business logic directly in route handlers — delegate to service functions.
- Do not return raw SQLAlchemy model objects — always serialize through Pydantic response models.
- Do not swallow Stripe webhook signature errors — always return `400` on signature mismatch.
- Do not hard-code Stripe keys — read from environment variables via `pydantic-settings`.
