---
name: database-patterns
description: PostgreSQL schema patterns and conventions for the Figurio platform
---

# Database Patterns

## Schema Conventions

- Table names: plural, snake_case (`products`, `order_items`, `ai_jobs`)
- Primary keys: `id` (UUID or bigint auto-increment)
- Foreign keys: `{table_singular}_id` (e.g., `customer_id`, `order_id`)
- Timestamps: `created_at` and `updated_at` on every table (UTC, timezone-aware)
- Soft delete: use `deleted_at` timestamp instead of hard delete for orders and customers
- Enums: PostgreSQL native enum types for status fields

## JSONB Usage

Use JSONB for:
- `products.images` — array of image URLs with alt text
- `products.size_tiers` — array of {tier, height_cm, price_cents}
- `orders.shipping_address` — structured address object
- `ai_jobs.preview_images` — array of rendered preview URLs

Do NOT use JSONB for:
- Frequently queried/filtered fields (use proper columns)
- Relationships between records (use foreign keys)

## Index Strategy

```sql
-- Hot query paths
CREATE INDEX idx_products_category ON products(category) WHERE deleted_at IS NULL;
CREATE INDEX idx_products_slug ON products(slug) WHERE deleted_at IS NULL;
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status);
CREATE INDEX idx_ai_jobs_customer_status ON ai_jobs(customer_id, status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
```

## Migration Rules

- Use Alembic for all schema changes
- Never modify a deployed migration — create a new one
- Migrations must be reversible (include `downgrade()`)
- Test migrations against a copy of production data before deploying

## Money Handling

- Store all monetary values as integer cents (`price_cents INTEGER NOT NULL`)
- Include `currency VARCHAR(3) DEFAULT 'EUR'` alongside every money field
- Never use FLOAT or DECIMAL for money
- Stripe amounts are already in cents — no conversion needed
