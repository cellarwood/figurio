---
name: Design and implement the database schema
assignee: backend-engineer
project: mvp-platform
---

Design and implement the PostgreSQL database schema for the Figurio platform.

## Core Tables

### products
- id, name, slug, description, category, images (JSONB), model_3d_url
- size_tiers (JSONB: [{tier: "small", height_cm: 8, price_cents: ...}, ...])
- stock_status (enum: available, out_of_stock, discontinued)
- source_type (enum: licensed, commissioned, community)
- is_printable_validated (boolean)
- created_at, updated_at

### customers
- id, email, password_hash, first_name, last_name
- stripe_customer_id
- created_at, updated_at

### orders
- id, customer_id (FK), status (enum: pending, paid, printing, shipped, delivered, refunded)
- total_cents, currency
- shipping_address (JSONB)
- stripe_checkout_session_id, stripe_payment_intent_id
- mcae_print_job_id (nullable)
- tracking_number (nullable)
- created_at, updated_at

### order_items
- id, order_id (FK), product_id (FK, nullable for AI-custom), ai_job_id (FK, nullable)
- size_tier, quantity, unit_price_cents

### ai_jobs
- id, customer_id (FK), prompt_text, status (enum: pending, generating, repairing, rendering, ready_for_review, approved, rejected, failed)
- provider (enum: meshy, tripo3d, etc.)
- raw_model_url, repaired_model_url, preview_images (JSONB)
- estimated_price_cents, deposit_paid (boolean), deposit_payment_intent_id
- final_payment_intent_id (nullable)
- error_message (nullable)
- created_at, updated_at

## Technical Details

- ORM: SQLAlchemy with async support
- Migrations: Alembic
- Indexes: on products(category), products(slug), orders(customer_id, status), ai_jobs(customer_id, status)
- Use JSONB for flexible nested data (images, size_tiers, shipping_address)

## Acceptance Criteria

- All tables created with proper constraints and indexes
- Alembic migration files generated and tested
- SQLAlchemy models matching the schema
- Seed data script for development (sample products across categories and sizes)
