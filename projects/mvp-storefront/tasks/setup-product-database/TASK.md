---
name: Set up product database
assignee: backend-engineer
project: mvp-storefront
---

Design and implement the PostgreSQL database schema for the Figurio storefront.

## Tables

### products
- id (UUID, PK), name, slug (unique), description, category
- small_price, medium_price, large_price (integer, cents)
- images (JSONB array of URLs), model_3d_url (nullable)
- status (enum: draft, published, archived)
- created_at, updated_at

### customers
- id (UUID, PK), email (unique), name
- stripe_customer_id (nullable)
- created_at

### orders
- id (UUID, PK), customer_id (FK), status (enum: pending, paid, printing, shipped, delivered, cancelled)
- stripe_session_id, stripe_payment_intent_id
- total_amount (integer, cents), currency (default: EUR)
- shipping_address (JSONB), tracking_number (nullable)
- created_at, updated_at

### order_items
- id (UUID, PK), order_id (FK), product_id (FK)
- size_tier (enum: small, medium, large), quantity, unit_price (integer, cents)

## Technical Notes

- Use SQLAlchemy 2.0 with async engine
- Create Alembic migrations for all schema changes
- Add indexes on: products.slug, products.status, orders.customer_id, orders.status
- Seed script for development with sample products
