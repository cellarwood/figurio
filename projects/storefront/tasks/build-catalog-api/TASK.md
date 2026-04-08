---
name: Build Catalog API
assignee: backend-engineer
project: storefront
---

Build the REST API for the figurine catalog. This is the backbone of the storefront — every product page, search result, and cart interaction depends on it.

## Requirements

- CRUD endpoints for figurine products (admin-only for create/update/delete)
- Product model: name, description, images, 3D model file reference, size tiers with pricing, category, tags, availability status
- Size tier pricing: Small (~8cm), Medium (~15cm), Large (~25cm) with per-product pricing per tier
- List endpoint with filtering (category, price range, size), sorting (price, newest, popularity), and pagination
- Single product detail endpoint with full metadata and related products
- Search endpoint with text-based search across name, description, and tags
- PostgreSQL database with proper indexing for filter/sort performance

## Tech Stack

- Python 3.10+ with FastAPI
- PostgreSQL with SQLAlchemy/Alembic for migrations
- Pydantic models for request/response validation
- uv for dependency management

## Acceptance Criteria

- All endpoints return proper HTTP status codes and error messages
- Pagination works correctly with cursor-based or offset pagination
- Database migrations are reversible
- API documentation auto-generated via FastAPI OpenAPI
