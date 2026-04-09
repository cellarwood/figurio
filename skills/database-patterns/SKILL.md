---
name: database-patterns
description: >
  PostgreSQL schema patterns for the Figurio e-commerce platform —
  product catalog, orders, customers, payments, and AI figurine jobs
  with migration conventions and indexing strategy.
---

# Database Patterns

## Core Tables

### products
```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
name VARCHAR(255) NOT NULL,
slug VARCHAR(255) UNIQUE NOT NULL,
description TEXT,
category VARCHAR(100) NOT NULL,
images JSONB NOT NULL DEFAULT '[]',
model_url VARCHAR(500),          -- .glb/.gltf 3D model URL
price_small_cents INTEGER,       -- ~8cm tier
price_medium_cents INTEGER,      -- ~15cm tier
price_large_cents INTEGER,       -- ~25cm tier
stock_status VARCHAR(20) DEFAULT 'available',
created_at TIMESTAMPTZ DEFAULT now(),
updated_at TIMESTAMPTZ DEFAULT now()
```

### orders
```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
customer_id UUID REFERENCES customers(id),
status VARCHAR(20) NOT NULL DEFAULT 'draft',  -- draft|paid|processing|printing|shipped|delivered
items JSONB NOT NULL,
shipping_address JSONB NOT NULL,
total_cents INTEGER NOT NULL,
stripe_payment_intent_id VARCHAR(255),
tracking_number VARCHAR(100),
created_at TIMESTAMPTZ DEFAULT now(),
updated_at TIMESTAMPTZ DEFAULT now()
```

### custom_figurine_jobs
```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
customer_id UUID REFERENCES customers(id),
prompt TEXT NOT NULL,
status VARCHAR(20) DEFAULT 'pending',  -- pending|generating|repairing|qa_review|preview_sent|approved|rejected
generated_model_url VARCHAR(500),
repaired_model_url VARCHAR(500),
preview_image_url VARCHAR(500),
deposit_payment_intent_id VARCHAR(255),
final_payment_intent_id VARCHAR(255),
created_at TIMESTAMPTZ DEFAULT now()
```

## Indexing Strategy

- Index on `products.category` and `products.slug`
- Index on `orders.customer_id` and `orders.status`
- Index on `custom_figurine_jobs.customer_id` and `custom_figurine_jobs.status`
- GIN index on `products.name` for full-text search

## Migration Conventions

- One migration per schema change, never combine unrelated changes
- Migration names: `{timestamp}_{description}.py` (e.g., `20260415_add_products_table.py`)
- Always include both upgrade and downgrade functions
- Test migrations against a copy of production data before deploying
