---
name: Build Product Catalog API
assignee: backend-engineer
project: mvp-storefront
---

Design and implement the product catalog REST API with FastAPI.

- Design PostgreSQL schema: products (name, description, category, images, 3d_model_url, sizes, prices, stock_status)
- Implement CRUD endpoints: GET /products, GET /products/{id}, POST /products (admin), PATCH /products/{id}
- Add filtering by category, search by name/description, pagination
- Add size tier pricing (small ~8cm, medium ~15cm, large ~25cm) as a product attribute
- Implement image and 3D model URL management
- Write Alembic migration for the products table
- Add OpenAPI documentation with request/response examples
- Write pytest tests for all endpoints
