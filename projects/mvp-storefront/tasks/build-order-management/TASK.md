---
name: Build Order Management System
assignee: backend-engineer
project: mvp-storefront
---

Implement the order lifecycle management system.

- Design PostgreSQL schema: orders (customer, items, shipping_address, status, payment_id, tracking_number)
- Implement order state machine: draft → paid → processing → printing → shipped → delivered
- Build API endpoints: POST /orders, GET /orders/{id}, GET /orders (customer's orders), PATCH /orders/{id}/status
- Send email notifications on status transitions (order confirmed, shipped, delivered)
- Implement order tracking endpoint that returns current status and estimated delivery
- Add admin endpoints for updating order status (used by Head of Operations)
- Write Alembic migrations and pytest tests
