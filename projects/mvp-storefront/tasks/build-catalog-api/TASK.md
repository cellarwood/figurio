---
name: Build catalog API
assignee: backend-engineer
project: mvp-storefront
---

Build FastAPI endpoints for the product catalog that the storefront consumes.

## Endpoints

- `GET /api/products` — list products with pagination, search, and filtering (category, size tier, price range)
- `GET /api/products/{id}` — single product detail with all metadata
- `POST /api/products` — create product (admin only)
- `PUT /api/products/{id}` — update product (admin only)
- `DELETE /api/products/{id}` — soft-delete product (admin only)
- `GET /api/categories` — list available categories

## Product Model

- id, name, slug, description, category
- price per size tier (small_price, medium_price, large_price)
- images (list of URLs)
- 3d_model_url (optional, for the viewer)
- status (draft, published, archived)
- created_at, updated_at

## Technical Notes

- Use Pydantic models for request/response validation
- Implement cursor-based pagination for the product list
- Add full-text search on product name and description
- Write pytest tests for all endpoints
