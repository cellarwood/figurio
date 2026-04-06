---
name: Design and implement product catalog API
assignee: backend-engineer
project: mvp-platform
---

Build the product catalog API using FastAPI. This is the foundation for browsing and purchasing figurines.

## Requirements

- CRUD endpoints for products: `GET /products`, `GET /products/{id}`, `POST /products` (admin), `PUT /products/{id}` (admin), `DELETE /products/{id}` (admin)
- Filtering: by category (fantasy, sci-fi, seasonal, meme, etc.), size tier (small/medium/large), price range, availability
- Search: full-text search on product name and description
- Pagination: cursor-based or offset pagination
- Product model fields: name, description, category, size_tiers (with price per tier), images (URLs), 3d_model_url, stock_status, created_at

## Technical Details

- Framework: FastAPI with async endpoints
- Database: PostgreSQL with SQLAlchemy async ORM
- Validation: Pydantic models for request/response schemas
- Documentation: auto-generated OpenAPI spec
- Use `uv` for dependency management

## Acceptance Criteria

- All endpoints working with proper validation and error responses
- OpenAPI spec generated and accessible at `/docs`
- Unit tests with pytest covering CRUD operations and filtering
- Database migrations set up (Alembic)
