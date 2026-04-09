---
name: api-design
description: >
  REST API design conventions for the Figurio e-commerce platform —
  endpoint naming, pagination, error responses, authentication,
  and Stripe webhook handling patterns.
---

# API Design

## URL Structure

```
/api/v1/products                    # Product catalog
/api/v1/products/{id}               # Single product
/api/v1/orders                      # Customer orders
/api/v1/orders/{id}                 # Single order
/api/v1/orders/{id}/status          # Order status updates
/api/v1/custom-figurines            # AI custom figurine jobs
/api/v1/custom-figurines/{id}       # Single custom figurine job
/api/v1/webhooks/stripe             # Stripe webhook endpoint
```

## Pagination

All list endpoints use cursor-based pagination:

```json
{
  "items": [...],
  "cursor": "eyJpZCI6MTIzfQ==",
  "hasMore": true
}
```

Query params: `?cursor={cursor}&limit={limit}` (default limit: 20, max: 100).

## Error Response Format

```json
{
  "error": {
    "code": "PRODUCT_NOT_FOUND",
    "message": "Product with ID 'abc123' does not exist",
    "details": {}
  }
}
```

HTTP status codes: 400 (validation), 401 (auth), 403 (forbidden), 404 (not found), 409 (conflict), 422 (unprocessable), 500 (server error).

## Stripe Webhook Handling

- Verify webhook signature using `stripe.Webhook.construct_event()`
- Handle events idempotently (store processed event IDs)
- Key events: `payment_intent.succeeded`, `payment_intent.payment_failed`, `charge.refunded`
- Return 200 immediately, process asynchronously if needed

## Authentication

- Customer auth: JWT tokens via `/api/v1/auth/login` and `/api/v1/auth/register`
- Admin auth: separate admin JWT with elevated permissions
- Stripe webhooks: signature verification (no JWT)
