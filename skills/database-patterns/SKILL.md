---
name: Database Patterns
description: PostgreSQL schema patterns, migration conventions, and indexing strategy for Figurio
---

# Database Patterns

## Core Schema

### Users
```sql
users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
)
```

### Products (Catalog Figurines)
```sql
products (
  id UUID PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  category VARCHAR(50),          -- trending, seasonal, evergreen, fantasy, sci-fi
  model_file_url TEXT NOT NULL,  -- GLB/OBJ file for 3D viewer
  thumbnail_url TEXT,
  price_small_cents INTEGER NOT NULL,
  price_medium_cents INTEGER NOT NULL,
  price_large_cents INTEGER NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
)
```

### Orders
```sql
orders (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  status VARCHAR(30) NOT NULL DEFAULT 'pending_payment',
  -- pending_payment, paid, preparing, sent_to_printer, printing, shipped, delivered, cancelled
  total_cents INTEGER NOT NULL,
  currency VARCHAR(3) DEFAULT 'EUR',
  stripe_payment_intent_id VARCHAR(255),
  tracking_number VARCHAR(255),
  shipping_address JSONB,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
)
```

### Order Items
```sql
order_items (
  id UUID PRIMARY KEY,
  order_id UUID REFERENCES orders(id),
  product_id UUID REFERENCES products(id) NULL,  -- null for custom orders
  custom_order_id UUID REFERENCES custom_orders(id) NULL,
  size VARCHAR(10) NOT NULL,  -- small, medium, large
  quantity INTEGER DEFAULT 1,
  unit_price_cents INTEGER NOT NULL
)
```

### Custom Orders (AI Pipeline)
```sql
custom_orders (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  prompt TEXT NOT NULL,
  status VARCHAR(30) DEFAULT 'generating',
  -- generating, repairing, qa_review, preview_ready, approved, rejected, cancelled
  model_file_url TEXT,
  repair_report JSONB,
  qa_notes TEXT,
  deposit_payment_intent_id VARCHAR(255),
  final_payment_intent_id VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
)
```

## Migration Conventions

- Use Alembic for all migrations
- One migration per logical change
- Migration file naming: `{revision}_{description}.py`
- Always include both `upgrade()` and `downgrade()`
- Test migrations against a copy of production data before applying
- Never use raw SQL in application code for schema changes

## Indexing Strategy

```sql
CREATE INDEX idx_products_category ON products(category) WHERE is_active = true;
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX idx_custom_orders_user_id ON custom_orders(user_id);
CREATE INDEX idx_custom_orders_status ON custom_orders(status);
```

## Rules

- All monetary values stored as integers in cents (avoid floating point)
- All timestamps are TIMESTAMPTZ (timezone-aware)
- Use UUIDs for primary keys (no sequential IDs exposed to users)
- JSONB for flexible data (shipping address, repair reports) — but don't overuse
- Foreign keys always have ON DELETE behavior specified
