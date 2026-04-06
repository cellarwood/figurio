---
name: api-design
description: REST API design conventions for the Figurio backend
---

# API Design Conventions

## URL Structure

```
/api/v1/products
/api/v1/products/{id}
/api/v1/orders
/api/v1/orders/{id}
/api/v1/ai-jobs
/api/v1/ai-jobs/{id}
/api/v1/ai-jobs/{id}/approve
/api/v1/customers/me
/api/v1/webhooks/stripe
```

- Plural nouns for collections
- kebab-case for multi-word resources
- Version prefix `/api/v1/`
- Actions as sub-resources (e.g., `/approve`, `/reject`)

## Request/Response Format

- Always JSON (`Content-Type: application/json`)
- Use Pydantic models for validation and serialization
- Dates in ISO 8601 format
- Money in cents (integer) with currency field

### Standard Response Envelope

```json
{
  "data": { ... },
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 142
  }
}
```

### Error Response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable description",
    "details": [
      {"field": "email", "message": "Invalid email format"}
    ]
  }
}
```

## Status Codes

| Code | Usage |
|------|-------|
| 200 | Success (GET, PUT) |
| 201 | Created (POST) |
| 204 | No content (DELETE) |
| 400 | Validation error |
| 401 | Not authenticated |
| 403 | Not authorized |
| 404 | Not found |
| 409 | Conflict (duplicate, state mismatch) |
| 422 | Unprocessable (valid format, business rule violation) |
| 500 | Server error |

## Pagination

Offset-based for catalog browsing:

```
GET /api/v1/products?page=2&per_page=20&category=fantasy&size=medium&sort=-created_at
```

## Authentication

- JWT Bearer tokens in `Authorization` header
- Access token (short-lived, 15min) + Refresh token (long-lived, 7 days)
- Stripe webhooks: verify signature, no JWT needed
