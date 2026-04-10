---
name: database-patterns
description: >
  PostgreSQL schema patterns for Figurio's D2C 3D-figurine platform using
  async SQLAlchemy. Covers the product catalog (size tiers, printability),
  customer orders (lifecycle state machine), AI generation jobs (queue, status,
  retry), Stripe payment records, and fulfillment tracking.
allowed-tools:
  - Read
  - Grep
  - Write
metadata:
  paperclip:
    tags:
      - engineering
      - backend
      - database
---

# Database Patterns

## General Conventions

- All tables use `UUID` primary keys (PostgreSQL `uuid` type, generated with `gen_random_uuid()`).
- Every table has `created_at TIMESTAMPTZ NOT NULL DEFAULT now()` and `updated_at TIMESTAMPTZ NOT NULL DEFAULT now()`.
- `updated_at` is maintained by a shared PostgreSQL trigger — do not rely on application code to set it.
- Use `TIMESTAMPTZ` for all timestamps, never `TIMESTAMP`.
- Enum values are stored in PostgreSQL `TEXT` columns with `CHECK` constraints — not PostgreSQL `ENUM` types (avoids painful migrations).
- Monetary values are stored as `INTEGER` (cents), never `FLOAT` or `NUMERIC`. E.g., $15.00 = `1500`.
- Soft-delete is not used — rows are hard-deleted when appropriate, with audit logs written separately.

## SQLAlchemy Setup

Use `async_sessionmaker` with `AsyncSession` from `sqlalchemy.ext.asyncio`.

```python
# Base for all models
from sqlalchemy.orm import DeclarativeBase, mapped_column, Mapped
from sqlalchemy import func
import uuid

class Base(DeclarativeBase):
    pass

class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        server_default=func.now(), onupdate=func.now()
    )
```

Always use SQLAlchemy 2.x `Mapped` + `mapped_column` style — not the legacy `Column()` style.

## Product Catalog

```sql
CREATE TABLE products (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            TEXT NOT NULL,
    description     TEXT,
    size_tier       TEXT NOT NULL CHECK (size_tier IN ('small', 'medium', 'large')),
    height_cm       NUMERIC(5,1) NOT NULL,   -- 8.0, 15.0, 25.0
    price_cents     INTEGER NOT NULL,
    is_printable    BOOLEAN NOT NULL DEFAULT true,
    printability_notes TEXT,                 -- populated when is_printable = false
    stock_status    TEXT NOT NULL DEFAULT 'available'
                        CHECK (stock_status IN ('available', 'limited', 'out_of_stock')),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_size_tier ON products (size_tier);
CREATE INDEX idx_products_stock_status ON products (stock_status);
```

Size tier heights: Small = 8 cm, Medium = 15 cm, Large = 25 cm. These are product constants — enforce in application validation, not just the DB.

`is_printable` is set by the AI pipeline after mesh analysis. A product in the catalog may be marked non-printable if the uploaded mesh fails geometry checks. Expose `printability_notes` only to internal agents, never to customers.

## Customer Orders

```sql
CREATE TABLE orders (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id         UUID NOT NULL REFERENCES customers(id),
    status              TEXT NOT NULL DEFAULT 'pending'
                            CHECK (status IN (
                                'pending', 'paid', 'in_production',
                                'shipped', 'delivered', 'cancelled', 'refunded'
                            )),
    generation_job_id   UUID REFERENCES generation_jobs(id),  -- NULL for catalog orders
    total_cents         INTEGER NOT NULL,
    shipping_address    JSONB NOT NULL,
    stripe_session_id   TEXT,
    notes               TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_orders_status ON orders (status);
CREATE INDEX idx_orders_stripe_session_id ON orders (stripe_session_id)
    WHERE stripe_session_id IS NOT NULL;
```

**Order lifecycle:** `pending` → `paid` → `in_production` → `shipped` → `delivered`

Cancellation and refunds transition to `cancelled` or `refunded` from `paid` or `in_production` only — never from `shipped` or `delivered`. Enforce these transitions in a service-layer state machine, not ad-hoc UPDATE statements.

`generation_job_id` links custom figurine orders to their AI job. Null for standard catalog orders.

## AI Generation Jobs

```sql
CREATE TABLE generation_jobs (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id             UUID NOT NULL REFERENCES customers(id),
    prompt                  TEXT NOT NULL,
    size_tier               TEXT NOT NULL CHECK (size_tier IN ('small', 'medium', 'large')),
    status                  TEXT NOT NULL DEFAULT 'queued'
                                CHECK (status IN (
                                    'queued', 'deposit_pending', 'deposit_paid',
                                    'generating', 'review', 'completed', 'failed', 'cancelled'
                                )),
    deposit_cents           INTEGER NOT NULL,
    stripe_deposit_session_id TEXT,
    mesh_url                TEXT,           -- populated on completion
    preview_url             TEXT,           -- populated on review
    attempt_count           INTEGER NOT NULL DEFAULT 0,
    max_attempts            INTEGER NOT NULL DEFAULT 3,
    last_error              TEXT,
    worker_id               TEXT,           -- ID of the worker processing the job
    started_at              TIMESTAMPTZ,
    completed_at            TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_generation_jobs_customer_id ON generation_jobs (customer_id);
CREATE INDEX idx_generation_jobs_status ON generation_jobs (status);
-- For worker queue polling:
CREATE INDEX idx_generation_jobs_queue ON generation_jobs (created_at)
    WHERE status = 'deposit_paid';
```

**Retry logic:** When a generation attempt fails, increment `attempt_count` and set `status = 'queued'` if `attempt_count < max_attempts`, otherwise set `status = 'failed'`. Write `last_error` on every failure. Use `worker_id` + `started_at` for heartbeat-based stale job detection.

Claim a job atomically:
```sql
UPDATE generation_jobs
SET status = 'generating', worker_id = $1, started_at = now()
WHERE id = (
    SELECT id FROM generation_jobs
    WHERE status = 'deposit_paid'
    ORDER BY created_at ASC
    FOR UPDATE SKIP LOCKED
    LIMIT 1
)
RETURNING *;
```

## Payment Records

```sql
CREATE TABLE payments (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id            UUID REFERENCES orders(id),
    generation_job_id   UUID REFERENCES generation_jobs(id),
    stripe_event_id     TEXT NOT NULL UNIQUE,  -- idempotency key
    stripe_object_id    TEXT NOT NULL,         -- session or payment_intent ID
    payment_type        TEXT NOT NULL
                            CHECK (payment_type IN (
                                'checkout_session', 'payment_intent', 'refund'
                            )),
    amount_cents        INTEGER NOT NULL,
    currency            TEXT NOT NULL DEFAULT 'usd',
    status              TEXT NOT NULL
                            CHECK (status IN ('pending', 'succeeded', 'failed', 'refunded')),
    raw_event           JSONB NOT NULL,        -- full Stripe event payload, for audit
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_payments_order_id ON payments (order_id)
    WHERE order_id IS NOT NULL;
CREATE INDEX idx_payments_job_id ON payments (generation_job_id)
    WHERE generation_job_id IS NOT NULL;
CREATE INDEX idx_payments_stripe_event_id ON payments (stripe_event_id);
```

`stripe_event_id UNIQUE` enforces webhook idempotency at the DB level — use `INSERT ... ON CONFLICT DO NOTHING` in the webhook handler.

Either `order_id` or `generation_job_id` must be set; enforced with a `CHECK`:
```sql
CONSTRAINT payments_target_check
    CHECK (
        (order_id IS NOT NULL AND generation_job_id IS NULL) OR
        (order_id IS NULL AND generation_job_id IS NOT NULL)
    )
```

## Fulfillment Tracking

```sql
CREATE TABLE fulfillments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        UUID NOT NULL REFERENCES orders(id),
    carrier         TEXT,
    tracking_number TEXT,
    tracking_url    TEXT,
    status          TEXT NOT NULL DEFAULT 'pending'
                        CHECK (status IN (
                            'pending', 'printing', 'quality_check',
                            'packaged', 'handed_to_carrier', 'in_transit',
                            'delivered', 'exception'
                        )),
    estimated_delivery_at   TIMESTAMPTZ,
    delivered_at            TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_fulfillments_order_id ON fulfillments (order_id);
CREATE INDEX idx_fulfillments_status ON fulfillments (status)
    WHERE status NOT IN ('delivered', 'exception');
```

One fulfillment per order (1:1). Create the fulfillment row when the order transitions to `in_production`. Update `status` as the physical item moves through printing → QC → shipping.

## Migration Conventions

- Use Alembic for all schema changes. Never run raw DDL against production.
- Migration filenames: `YYYYMMDD_HHMM_<short_description>.py`.
- Every migration must have a working `downgrade()`.
- Adding a `NOT NULL` column to an existing table requires a default or a two-step migration (add nullable, backfill, add constraint).
