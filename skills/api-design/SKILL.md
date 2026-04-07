---
name: API Design
description: REST API conventions, endpoint naming, and error handling standards for Figurio's FastAPI backend
---

# API Design

## URL Convention

```
/api/v1/{resource}              # Collection
/api/v1/{resource}/{id}         # Single resource
/api/v1/{resource}/{id}/{sub}   # Sub-resource
```

All endpoints prefixed with `/api/v1/`. Resource names are plural, kebab-case.

## Figurio API Resources

| Resource | Endpoints | Auth Required |
|----------|-----------|---------------|
| `/api/v1/products` | GET (list), GET /{id} | No |
| `/api/v1/orders` | POST, GET (list), GET /{id}, PATCH /{id}/status | Yes |
| `/api/v1/custom-orders` | POST, GET /{id}, POST /{id}/approve, POST /{id}/reject | Yes |
| `/api/v1/users` | POST /register, POST /login, GET /me, PATCH /me | Partial |
| `/api/v1/checkout` | POST /sessions | Yes |
| `/api/v1/webhooks/stripe` | POST | No (signature verified) |
| `/api/v1/admin/qa-queue` | GET, PATCH /{id}/approve, PATCH /{id}/reject | Admin |

## Response Format

```json
{
  "data": { ... },
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 150
  }
}
```

Error responses:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable message",
    "details": [
      { "field": "email", "message": "Invalid email format" }
    ]
  }
}
```

## Pagination

Use cursor-based pagination for lists:
- `?cursor={last_id}&limit=20`
- Default limit: 20, max: 100
- Response includes `meta.next_cursor` if more results exist

## Status Codes

| Code | When |
|------|------|
| 200 | Successful GET, PATCH |
| 201 | Successful POST (resource created) |
| 400 | Validation error, malformed request |
| 401 | Missing or invalid auth token |
| 403 | Valid auth but insufficient permissions |
| 404 | Resource not found |
| 409 | Conflict (duplicate order, concurrent modification) |
| 422 | Unprocessable (valid format but business logic violation) |
| 500 | Unexpected server error |

## Stripe Webhook Handling

- Always verify webhook signature with `STRIPE_WEBHOOK_SECRET`
- Process idempotently (use Stripe event ID for deduplication)
- Return 200 immediately, process asynchronously if needed
- Log every webhook event (type, id, outcome)
