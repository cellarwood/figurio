---
name: database-patterns
description: >
  PostgreSQL schema conventions for Figurio — product catalog tables (figurines,
  categories, size tiers, images), orders and line items, payments, users and
  auth, AI generation jobs. Migration patterns with Alembic including naming
  conventions and multi-step schema changes. Use whenever designing schema
  changes, writing queries, or authoring Alembic migrations.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - backend
      - database
---

# Database Patterns

## General Conventions

- All tables use **snake_case** names, plural (`figurines`, `orders`, `users`)
- Primary keys: `UUID` generated with `gen_random_uuid()` for all user-facing entities; `SERIAL` only for internal lookup tables where human-readable IDs are never exposed
- All tables have `created_at TIMESTAMPTZ DEFAULT NOW()` and `updated_at TIMESTAMPTZ DEFAULT NOW()`; manage `updated_at` via a trigger (one shared trigger function `set_updated_at`)
- Soft deletes: use `deleted_at TIMESTAMPTZ` on `figurines` and `users`; hard deletes everywhere else
- Monetary values: store as `INTEGER` cents (CZK), never `FLOAT` or `NUMERIC` with currency symbols
- Timestamps: always `TIMESTAMPTZ`, never `TIMESTAMP`

## Core Schema

### Product Catalog

```sql
-- Top-level categories (e.g., "Fantasy", "Sci-Fi", "Sports")
CREATE TABLE categories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug        TEXT NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Size tiers (e.g., "Small 10cm", "Medium 15cm", "Large 20cm")
CREATE TABLE size_tiers (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    height_mm   INTEGER NOT NULL,
    price_czk   INTEGER NOT NULL,  -- base price in haléře (cents)
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Catalog figurines and AI-custom base templates
CREATE TABLE figurines (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sku             TEXT NOT NULL UNIQUE,
    category_id     UUID NOT NULL REFERENCES categories(id),
    name            TEXT NOT NULL,
    description     TEXT,
    is_custom       BOOLEAN NOT NULL DEFAULT FALSE,  -- TRUE for AI-generated
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Price per figurine per size tier (overrides size_tiers.price_czk)
CREATE TABLE figurine_size_prices (
    figurine_id     UUID NOT NULL REFERENCES figurines(id) ON DELETE CASCADE,
    size_tier_id    INTEGER NOT NULL REFERENCES size_tiers(id),
    price_czk       INTEGER NOT NULL,
    PRIMARY KEY (figurine_id, size_tier_id)
);

-- Images for each figurine (multiple angles)
CREATE TABLE figurine_images (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    figurine_id     UUID NOT NULL REFERENCES figurines(id) ON DELETE CASCADE,
    url             TEXT NOT NULL,
    alt_text        TEXT,
    sort_order      INTEGER NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

### Users and Auth

```sql
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           TEXT NOT NULL UNIQUE,
    hashed_password TEXT NOT NULL,
    full_name       TEXT,
    is_admin        BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);
```

No OAuth tables yet — email/password only. JWT tokens are stateless; no refresh token table.

### Orders and Payments

```sql
CREATE TYPE order_status AS ENUM (
    'PENDING', 'PAID', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'REFUNDED'
);

CREATE TABLE orders (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                 UUID NOT NULL REFERENCES users(id),
    status                  order_status NOT NULL DEFAULT 'PENDING',
    stripe_session_id       TEXT,
    stripe_payment_intent_id TEXT,
    shipping_address        JSONB NOT NULL,
    total_czk               INTEGER NOT NULL,
    created_at              TIMESTAMPTZ DEFAULT NOW(),
    updated_at              TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE order_items (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    figurine_id     UUID NOT NULL REFERENCES figurines(id),
    size_tier_id    INTEGER NOT NULL REFERENCES size_tiers(id),
    quantity        INTEGER NOT NULL DEFAULT 1,
    unit_price_czk  INTEGER NOT NULL,  -- snapshot at time of order
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

`shipping_address` is JSONB (not a normalized table) because address structure varies and it must be an immutable snapshot.
`unit_price_czk` is always snapshotted at order creation — never re-read from `figurine_size_prices` after the order is placed.

### AI Generation Jobs

```sql
CREATE TYPE job_status AS ENUM ('QUEUED', 'PROCESSING', 'COMPLETED', 'FAILED');

CREATE TABLE ai_generation_jobs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id),
    order_item_id   UUID REFERENCES order_items(id),  -- NULL until linked to an order
    prompt          TEXT NOT NULL,
    result_url      TEXT,
    status          job_status NOT NULL DEFAULT 'QUEUED',
    error_message   TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);
```

## Indexes

Create indexes for every foreign key (PostgreSQL does not do this automatically) and for common query patterns:

```sql
-- figurines
CREATE INDEX idx_figurines_category_id ON figurines(category_id);
CREATE INDEX idx_figurines_sku ON figurines(sku);  -- already unique, index is implicit

-- orders
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_stripe_session_id ON orders(stripe_session_id);

-- order_items
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_figurine_id ON order_items(figurine_id);

-- ai_generation_jobs
CREATE INDEX idx_ai_jobs_user_id ON ai_generation_jobs(user_id);
CREATE INDEX idx_ai_jobs_status ON ai_generation_jobs(status);
```

## Alembic Conventions

### File Layout

```
alembic/
├── env.py
├── versions/
│   └── 20240101_001_create_categories.py
```

Filename format: `YYYYMMDD_NNN_<short_description>.py`

### Migration Template

```python
"""create categories

Revision ID: abc123
Revises: None
Create Date: 2024-01-01 10:00:00
"""
from alembic import op
import sqlalchemy as sa

revision = "abc123"
down_revision = None
branch_labels = None
depends_on = None

def upgrade() -> None:
    op.create_table(
        "categories",
        sa.Column("id", sa.UUID(), server_default=sa.text("gen_random_uuid()"), primary_key=True),
        sa.Column("slug", sa.Text(), nullable=False),
        sa.Column("name", sa.Text(), nullable=False),
        sa.Column("created_at", sa.TIMESTAMP(timezone=True), server_default=sa.text("NOW()")),
        sa.Column("updated_at", sa.TIMESTAMP(timezone=True), server_default=sa.text("NOW()")),
    )
    op.create_unique_constraint("uq_categories_slug", "categories", ["slug"])

def downgrade() -> None:
    op.drop_table("categories")
```

### Multi-Step Schema Changes

For changes that require a data backfill or a column rename, use two migrations:

1. **Migration A** — add the new column as nullable, backfill data
2. **Migration B** — add `NOT NULL` constraint or drop old column

Never add a `NOT NULL` column without a `server_default` in a single step on a table that has existing rows.

### Enum Changes

Adding a value to a PostgreSQL `ENUM` is irreversible in Alembic's `downgrade`. Document this in the migration docstring and do not implement a meaningful `downgrade` for enum additions:

```python
def upgrade() -> None:
    op.execute("ALTER TYPE order_status ADD VALUE 'REFUNDED'")

def downgrade() -> None:
    raise NotImplementedError("Cannot remove enum values in PostgreSQL")
```
