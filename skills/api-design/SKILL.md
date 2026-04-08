---
name: api-design
description: REST API design conventions for Figurio's FastAPI backend — endpoint naming, pagination, error responses, and authentication for the figurine e-commerce platform.
---

# API Design Conventions

## Purpose

Define consistent REST API conventions for the Figurio FastAPI backend. All engineers must follow these patterns to ensure a predictable, well-documented API.

## Base Configuration

- **Base path**: `/api/v1/`
- **Framework**: FastAPI (Python 3.11+)
- **Serialization**: Pydantic v2 models for all request/response schemas.
- **Documentation**: Auto-generated OpenAPI at `/docs` (Swagger UI) and `/redoc`.
- **Content-Type**: `application/json` for all endpoints.

## Resource Naming

Use plural nouns, lowercase, hyphen-separated for multi-word resources:

| Resource              | Path                                  |
|-----------------------|---------------------------------------|
| Products              | `/api/v1/products`                    |
| Product size tiers    | `/api/v1/products/{sku}/size-tiers`   |
| Orders                | `/api/v1/orders`                      |
| Order items           | `/api/v1/orders/{id}/items`           |
| Customers             | `/api/v1/customers`                   |
| Custom orders         | `/api/v1/custom-orders`               |
| Custom order preview  | `/api/v1/custom-orders/{id}/preview`  |
| Custom order approval | `/api/v1/custom-orders/{id}/approve`  |
| Payments              | `/api/v1/payments`                    |
| Webhooks (Stripe)     | `/api/v1/webhooks/stripe`             |

## HTTP Methods

| Method  | Usage                          | Idempotent | Response Code    |
|---------|--------------------------------|------------|------------------|
| GET     | Retrieve resource(s)           | Yes        | 200              |
| POST    | Create new resource            | No         | 201              |
| PUT     | Full update of resource        | Yes        | 200              |
| PATCH   | Partial update of resource     | Yes        | 200              |
| DELETE  | Soft-delete resource           | Yes        | 204              |

## Pagination

All list endpoints must support pagination:

```
GET /api/v1/products?page=1&per_page=20
```

Response envelope:

```json
{
  "items": [...],
  "total": 150,
  "page": 1,
  "per_page": 20,
  "pages": 8
}
```

- Default `per_page`: 20.
- Maximum `per_page`: 100.
- Always return `total` and `pages` for client-side pagination UI.

## Filtering and Sorting

- Filters as query parameters: `GET /api/v1/products?category=gaming&size_tier=M`.
- Sorting: `?sort_by=price&sort_order=asc` (default: `created_at` desc).
- Search: `?q=dragon` for full-text search across relevant fields.

## Error Response Format

All errors must use this consistent structure:

```json
{
  "code": "VALIDATION_ERROR",
  "message": "Human-readable description of what went wrong.",
  "details": [
    {
      "field": "email",
      "issue": "Invalid email format."
    }
  ]
}
```

### Standard Error Codes

| HTTP Status | Code                    | When to use                            |
|-------------|-------------------------|----------------------------------------|
| 400         | VALIDATION_ERROR        | Invalid request body or parameters.    |
| 401         | UNAUTHORIZED            | Missing or invalid JWT token.          |
| 403         | FORBIDDEN               | Valid token but insufficient permissions.|
| 404         | NOT_FOUND               | Resource does not exist.               |
| 409         | CONFLICT                | Duplicate resource or state conflict.  |
| 422         | UNPROCESSABLE_ENTITY    | Valid syntax but business rule failure. |
| 429         | RATE_LIMITED             | Too many requests.                     |
| 500         | INTERNAL_ERROR          | Unexpected server error.               |
| 503         | SERVICE_UNAVAILABLE     | Dependency down (Stripe, AI service).  |

## Authentication

- **Method**: JWT Bearer tokens in the `Authorization` header.
- **Format**: `Authorization: Bearer <token>`
- **Token lifetime**: Access token 15 minutes, refresh token 7 days.
- **Issuer**: Figurio API (`iss: figurio-api`).

### Public Endpoints (No Auth Required)

- `GET /api/v1/products` — Product catalog browsing.
- `GET /api/v1/products/{sku}` — Single product detail.
- `GET /api/v1/products/{sku}/size-tiers` — Available sizes and prices.
- `GET /health` — Health check.
- `GET /docs` — OpenAPI documentation.
- `POST /api/v1/auth/login` — Login.
- `POST /api/v1/auth/register` — Registration.

### Authenticated Endpoints

All other endpoints require a valid JWT token.

## Figurio-Specific Endpoints

### Custom Order Flow

```
POST   /api/v1/custom-orders                  → Create custom order with prompt
GET    /api/v1/custom-orders/{id}              → Get order status and details
GET    /api/v1/custom-orders/{id}/preview      → Get 3D preview (GLB URL + thumbnail)
POST   /api/v1/custom-orders/{id}/approve      → Customer approves design for printing
POST   /api/v1/custom-orders/{id}/revise       → Customer requests revision with feedback
DELETE /api/v1/custom-orders/{id}              → Cancel custom order (before printing)
```

### Custom Order Status Flow

```
submitted → generating → preview_ready → approved → printing → shipped → delivered
                ↓                           ↓
            generation_failed          revision_requested → generating (loop)
```

### Stripe Webhook

```
POST /api/v1/webhooks/stripe
```

- Verify webhook signature using `STRIPE_WEBHOOK_SECRET`.
- Handle events: `payment_intent.succeeded`, `payment_intent.failed`, `charge.refunded`.
- Return 200 immediately, process asynchronously.

## Request Validation Rules

- All monetary amounts in the smallest currency unit (hellers for CZK, cents for EUR).
- Dates in ISO 8601 format (`2026-04-08T10:30:00Z`).
- SKUs follow pattern: `FIG-{CATEGORY}-{ID}` (e.g., `FIG-GAME-001`).
- UUIDs for all resource identifiers (not auto-increment integers).
- Email addresses validated with regex and domain check.

## Rate Limiting

- Public endpoints: 60 requests/minute per IP.
- Authenticated endpoints: 120 requests/minute per user.
- Custom order creation: 5 requests/hour per user (expensive AI generation).
- Webhook endpoints: no rate limit (Stripe controls the rate).
