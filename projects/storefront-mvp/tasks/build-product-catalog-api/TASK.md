---
name: Build product catalog API
slug: build-product-catalog-api
assignee: cto
priority: critical
status: todo
---

# Build Product Catalog API

Implement the backend API for browsing, searching, and managing the figurine catalog.

## Expected Subtasks

- CTO delegates to Backend Engineer
- GET /products -- list with pagination, filtering (category, size, price range), search
- GET /products/{slug} -- product detail with 3D model URL, pricing per size tier, images
- POST/PUT/DELETE /products -- admin CRUD
- Category management endpoints
- Image and 3D model file upload/serving (S3 or local storage initially)
- OpenAPI documentation
