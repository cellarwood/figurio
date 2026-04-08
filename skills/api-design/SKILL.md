---
name: api-design
description: REST API design conventions for Figurio — endpoint naming, request/response format, pagination, error handling, and Stripe integration patterns
---

# API Design Conventions

## Endpoint Naming

- Use plural nouns: `/api/v1/figurines`, `/api/v1/orders`
- Nested resources for ownership: `/api/v1/orders/{id}/items`
- Use kebab-case for multi-word resources: `/api/v1/size-tiers`
- Version prefix: `/api/v1/`

## HTTP Methods

| Method | Purpose | Example |
|--------|---------|---------|
| GET | Read | `GET /api/v1/figurines` |
| POST | Create | `POST /api/v1/orders` |
| PUT | Full replace | `PUT /api/v1/figurines/{id}` |
| PATCH | Partial update | `PATCH /api/v1/orders/{id}/status` |
| DELETE | Remove | `DELETE /api/v1/figurines/{id}` |

## Response Format

```json
{
  "data": { ... },
  "meta": {
    "cursor": "abc123",
    "hasMore": true
  }
}
```

Error format:
```json
{
  "error": {
    "code": "FIGURINE_NOT_FOUND",
    "message": "Figurine with ID abc123 does not exist",
    "details": {}
  }
}
```

## Pagination

Use cursor-based pagination for catalog listings:
- `GET /api/v1/figurines?cursor=abc&limit=20`
- Response includes `meta.cursor` and `meta.hasMore`

## Stripe Integration Patterns

- Create Checkout Sessions server-side, never expose secret keys to frontend
- Use webhook endpoints for payment confirmations (don't rely on redirect)
- Always verify webhook signatures
- Implement idempotency keys for order creation
- Two-stage payment for custom figurines: create PaymentIntent with `capture_method: manual`, capture on approval

## Figurine-Specific Endpoints

```
GET    /api/v1/figurines                    # List catalog
GET    /api/v1/figurines/{id}               # Detail with size tiers
POST   /api/v1/figurines                    # Admin: create
POST   /api/v1/orders                       # Create order (from cart)
GET    /api/v1/orders/{id}                  # Order status
POST   /api/v1/custom-orders               # Submit AI prompt + deposit
PATCH  /api/v1/custom-orders/{id}/approve   # Customer approves preview
POST   /api/v1/webhooks/stripe              # Stripe webhook handler
```
