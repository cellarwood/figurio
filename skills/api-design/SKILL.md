---
name: api-design
description: >
  REST API conventions for Figurio's FastAPI backend — endpoint naming,
  pagination, error responses, authentication patterns, and integration
  specifics for Stripe payments and Zásilkovna shipping.
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

Figurio's backend is a Python/FastAPI service. All endpoints live under `/api/v1/`.

## URL Structure

Follow resource-oriented naming. Collections are plural nouns; identifiers go at the end.

```
GET    /api/v1/products                   # catalog listing
GET    /api/v1/products/{sku}             # single product by SKU
POST   /api/v1/orders                     # place an order
GET    /api/v1/orders/{order_id}          # fetch order
PATCH  /api/v1/orders/{order_id}          # update order fields
GET    /api/v1/users/{user_id}/orders     # orders scoped to a user

POST   /api/v1/figurines/generate         # AI Prompt to Print job submit
GET    /api/v1/figurines/{figurine_id}    # AI-generated figurine detail
```

Nested resources are acceptable only one level deep. Prefer query params for filtering.

## Authentication

All non-public endpoints require a Bearer JWT in `Authorization: Bearer <token>`.

- Tokens are issued by Figurio's own auth service (not a third-party IdP).
- Token payload must include `sub` (user UUID), `role` (`customer` | `admin`), `exp`.
- Public endpoints (product catalog, health checks) require no token.
- Admin-only endpoints (`/api/v1/admin/...`) enforce `role == "admin"` in a FastAPI dependency.

```python
# Standard auth dependency
async def require_customer(token: str = Depends(oauth2_scheme)) -> TokenPayload:
    ...

async def require_admin(token: str = Depends(oauth2_scheme)) -> TokenPayload:
    payload = decode_token(token)
    if payload.role != "admin":
        raise HTTPException(status_code=403, detail="Admin access required")
    return payload
```

## Pagination

All collection endpoints paginate using `limit` / `offset` query params.

- Default `limit`: 24 (one catalog page)
- Max `limit`: 100
- Response envelope:

```json
{
  "items": [...],
  "total": 312,
  "limit": 24,
  "offset": 0
}
```

Never return bare arrays at the top level.

## Error Responses

All errors follow a single envelope shape:

```json
{
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order abc123 does not exist.",
    "detail": {}
  }
}
```

- `code` is a screaming-snake string constant — define in `app/errors/codes.py`.
- `message` is human-readable and safe to surface in the frontend.
- `detail` carries extra structured data (e.g., validation field errors).
- HTTP status follows standard semantics: 400 bad input, 401 unauthenticated, 403 forbidden, 404 not found, 409 conflict, 422 validation, 500 internal.

Do NOT return FastAPI's default 422 Unprocessable Entity envelope directly — wrap it in the standard shape via an exception handler.

## Stripe Integration

Stripe is the sole payment processor. Keep Stripe-specific logic inside `app/integrations/stripe/`.

Key conventions:

- Create a `PaymentIntent` when the order is confirmed; store `stripe_payment_intent_id` on the order row.
- Expose `POST /api/v1/payments/webhook` for Stripe webhooks. Verify signatures with `stripe.Webhook.construct_event` before processing any event.
- Never log or return raw Stripe objects — map them to internal types.
- Idempotency: pass `idempotency_key=order_id` when creating PaymentIntents to prevent double-charges on retries.

Webhook events to handle:

| Event | Action |
|---|---|
| `payment_intent.succeeded` | Move order to `payment_confirmed` |
| `payment_intent.payment_failed` | Move order to `payment_failed`, notify user |
| `charge.refunded` | Move order to `refunded`, update payment record |

## Zásilkovna (Packeta) Integration

Zásilkovna is the shipping carrier. Integration lives in `app/integrations/zasílkovna/`.

Key conventions:

- Use the Packeta REST API v5 (`https://api.packeta.com/v5/`). Authenticate with the Figurio API key stored in env var `ZASÍLKOVNA_API_KEY`.
- Create a shipment via `POST /api/v1/orders/{order_id}/shipment` which calls Packeta's packet creation endpoint.
- Store `zasílkovna_packet_id` and `tracking_number` on the order row after successful creation.
- Expose a webhook receiver at `POST /api/v1/shipping/webhook` for Packeta status push events; update `shipment_status` on the order.

## Health and Observability

```
GET /api/v1/health        # liveness — returns {"status": "ok"}
GET /api/v1/health/ready  # readiness — checks DB connection
```

Include `X-Request-ID` in every response (generate via middleware if absent in request headers). Log request ID with every structured log entry.
