---
name: database-patterns
description: PostgreSQL schema patterns for Figurio — figurines, orders, customers, payments, and AI pipeline models
---

# Database Patterns

## Core Schema

### figurines
```sql
CREATE TABLE figurines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    category VARCHAR(100),
    tags TEXT[],
    images JSONB NOT NULL DEFAULT '[]',
    model_file_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### size_tiers
```sql
CREATE TABLE size_tiers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    figurine_id UUID REFERENCES figurines(id) ON DELETE CASCADE,
    size VARCHAR(20) NOT NULL CHECK (size IN ('small', 'medium', 'large')),
    height_cm NUMERIC(5,1) NOT NULL,
    price_cents INTEGER NOT NULL,
    UNIQUE(figurine_id, size)
);
```

### orders
```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(20) UNIQUE NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'confirmed',
    stripe_payment_intent_id VARCHAR(255),
    stripe_checkout_session_id VARCHAR(255),
    total_cents INTEGER NOT NULL,
    shipping_address JSONB,
    tracking_number VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- Status enum: confirmed, preparing, in_production, quality_check, shipped, delivered, cancelled
```

### custom_orders (AI pipeline)
```sql
CREATE TABLE custom_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id),
    prompt_text TEXT NOT NULL,
    style VARCHAR(50),
    size VARCHAR(20) NOT NULL,
    deposit_payment_intent_id VARCHAR(255),
    final_payment_intent_id VARCHAR(255),
    generated_model_url TEXT,
    repaired_model_url TEXT,
    qa_status VARCHAR(20) DEFAULT 'pending',
    customer_approved BOOLEAN,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

## Indexing Strategy

```sql
CREATE INDEX idx_figurines_category ON figurines(category) WHERE is_active;
CREATE INDEX idx_figurines_tags ON figurines USING GIN(tags);
CREATE INDEX idx_orders_email ON orders(customer_email);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_custom_orders_qa ON custom_orders(qa_status) WHERE customer_approved IS NULL;
```

## Migration Rules

- Use Alembic for all migrations
- Every migration must be reversible (include downgrade)
- Never modify a deployed migration — create a new one
- Test migrations against a copy of production data before deploying
