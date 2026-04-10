---
name: database-patterns
description: >
  PostgreSQL patterns for Figurio's backend — product catalog schema, order
  state machine, payment records, user accounts, and 3D model metadata for
  both the standard catalog and AI "Prompt to Print" figurines.
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

Figurio uses PostgreSQL. Migrations run via Alembic. All tables use UUID primary keys generated server-side (`gen_random_uuid()`). Use `TIMESTAMPTZ` for all timestamps, stored in UTC.

## Naming Conventions

- Tables: `snake_case`, plural (`products`, `orders`, `users`)
- Columns: `snake_case`
- Foreign keys: `{referenced_table_singular}_id` (e.g., `user_id`, `order_id`)
- Indexes: `ix_{table}_{column(s)}`
- Unique constraints: `uq_{table}_{column(s)}`

## User Accounts

```sql
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           TEXT NOT NULL,
    password_hash   TEXT NOT NULL,
    role            TEXT NOT NULL DEFAULT 'customer',  -- 'customer' | 'admin'
    full_name       TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_users_email UNIQUE (email)
);
```

- Never store plaintext passwords — always bcrypt hash.
- `role` is enforced at the app layer; no PostgreSQL row-level security needed yet.

## Product Catalog

```sql
CREATE TABLE products (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sku             TEXT NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT,
    price_czk       NUMERIC(10, 2) NOT NULL,  -- Czech Koruna, two decimals
    weight_grams    INTEGER,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_products_sku UNIQUE (sku)
);

CREATE INDEX ix_products_is_active ON products (is_active);
```

- Prices are stored in CZK as `NUMERIC` — never `FLOAT`.
- Soft-delete with `is_active = FALSE`; never hard-delete catalog rows.

## 3D Model Metadata

Both catalog products and AI-generated figurines link to a model file record.

```sql
CREATE TABLE model_files (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    storage_key     TEXT NOT NULL,        -- object key in internal object store
    file_format     TEXT NOT NULL,        -- 'stl' | 'obj' | '3mf'
    file_size_bytes BIGINT,
    color_profile   TEXT,                 -- MCAE print color profile identifier
    is_printable    BOOLEAN NOT NULL DEFAULT FALSE,  -- validated by slicer check
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- AI-generated figurines
CREATE TABLE figurines (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users (id),
    prompt          TEXT NOT NULL,
    model_file_id   UUID REFERENCES model_files (id),
    generation_status TEXT NOT NULL DEFAULT 'pending',
        -- 'pending' | 'processing' | 'ready' | 'failed'
    error_message   TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX ix_figurines_user_id ON figurines (user_id);
CREATE INDEX ix_figurines_generation_status ON figurines (generation_status);
```

## Order State Machine

Orders follow a linear state machine. Store the current state in `status`; never delete or overwrite history.

Valid transitions:

```
draft → confirmed → payment_pending → payment_confirmed → printing → shipped → delivered
                                    ↘ payment_failed
                          (any state) → cancelled
                          (any state) → refunded
```

```sql
CREATE TABLE orders (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                     UUID NOT NULL REFERENCES users (id),
    status                      TEXT NOT NULL DEFAULT 'draft',
    total_czk                   NUMERIC(10, 2) NOT NULL,
    shipping_address            JSONB NOT NULL,
    stripe_payment_intent_id    TEXT,
    zasílkovna_packet_id        TEXT,
    tracking_number             TEXT,
    shipment_status             TEXT,
    notes                       TEXT,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX ix_orders_user_id ON orders (user_id);
CREATE INDEX ix_orders_status  ON orders (status);

CREATE TABLE order_items (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID NOT NULL REFERENCES orders (id) ON DELETE CASCADE,
    product_id      UUID REFERENCES products (id),      -- null for AI figurines
    figurine_id     UUID REFERENCES figurines (id),     -- null for catalog items
    quantity        INTEGER NOT NULL DEFAULT 1,
    unit_price_czk  NUMERIC(10, 2) NOT NULL,            -- snapshot at time of order
    CONSTRAINT chk_order_items_source CHECK (
        (product_id IS NOT NULL) != (figurine_id IS NOT NULL)  -- exactly one source
    )
);
```

- `shipping_address` is JSONB (name, street, city, postal_code, country).
- `unit_price_czk` is a snapshot — do not join back to `products.price_czk` for financial reporting.

## Payment Records

```sql
CREATE TABLE payments (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id                    UUID NOT NULL REFERENCES orders (id),
    stripe_payment_intent_id    TEXT NOT NULL,
    amount_czk                  NUMERIC(10, 2) NOT NULL,
    currency                    TEXT NOT NULL DEFAULT 'czk',
    status                      TEXT NOT NULL,
        -- mirrors Stripe: 'requires_payment_method' | 'processing' | 'succeeded' | 'canceled'
    stripe_event_id             TEXT,           -- idempotency: last processed Stripe event
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_payments_stripe_payment_intent_id UNIQUE (stripe_payment_intent_id)
);
```

- One payment row per PaymentIntent. Append a new row for re-attempts, do not overwrite.
- Store `stripe_event_id` to deduplicate webhook deliveries.

## General Patterns

**updated_at trigger** — apply to every mutable table:

```sql
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
```

**No soft-delete by default** — only `products` uses `is_active`. Other tables retain rows permanently for audit purposes.

**JSONB vs columns** — use JSONB only for genuinely variable-shape data (shipping addresses, print settings). Keep all queryable/filterable fields as proper columns.
