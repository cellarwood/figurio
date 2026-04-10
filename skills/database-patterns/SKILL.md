---
name: database-patterns
description: >
  Database schema patterns for Figurio's PostgreSQL backend using SQLAlchemy async
  and Alembic. Covers product catalog with size tiers, order lifecycle, custom
  figurine workflow states, Stripe payment records, and customer accounts.
metadata:
  paperclip:
    tags:
      - engineering
      - backend
      - database
---

# Database Patterns

## General Conventions

- All tables use UUID primary keys (`uuid` type, default `gen_random_uuid()`). Never use serial integer PKs on domain entities.
- Every table has `created_at` and `updated_at` columns (`TIMESTAMPTZ`, default `now()`). `updated_at` is maintained by a trigger or SQLAlchemy `onupdate`.
- All monetary values stored as `INTEGER` in CZK halers (smallest unit). Never use `FLOAT` or `NUMERIC` for money.
- Enum columns use PostgreSQL native `ENUM` types, mirrored as Python `enum.Enum` classes.
- Soft deletes with `deleted_at TIMESTAMPTZ NULL` on catalog entities (products). Hard deletes are used for transient data only.

## SQLAlchemy Async Setup

Use `AsyncSession` from `sqlalchemy.ext.asyncio` everywhere. Session lifecycle is managed via a `get_db` FastAPI dependency. Never use synchronous sessions.

```python
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import func
import uuid

class Base(DeclarativeBase):
    pass

class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(default=func.now())
    updated_at: Mapped[datetime] = mapped_column(default=func.now(), onupdate=func.now())
```

All models inherit from `Base` and `TimestampMixin`.

## Product Catalog

Products represent physical figurine variants. Each product has one or more size tiers.

**`products` table**

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `sku` | VARCHAR UNIQUE NOT NULL | e.g., `"FIG-DRAGON-S"` |
| `name` | VARCHAR NOT NULL | Display name |
| `description` | TEXT | |
| `category` | product_category ENUM | e.g., `FANTASY`, `PORTRAIT`, `ANIMAL` |
| `is_active` | BOOLEAN DEFAULT true | Controls storefront visibility |
| `deleted_at` | TIMESTAMPTZ NULL | Soft delete |

**`product_size_tiers` table**

Each product has multiple size tiers (S, M, L, XL). Prices are per-tier, per-product.

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `product_id` | UUID FK → products.id | |
| `size` | size_tier ENUM | `S`, `M`, `L`, `XL` |
| `price_halers` | INTEGER NOT NULL | Price in CZK halers |
| `weight_grams` | INTEGER | Approximate print weight |
| `print_time_hours` | NUMERIC(5,2) | Estimated MCAE production time |

Unique constraint on `(product_id, size)`.

## Customer Accounts

**`customers` table**

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `email` | VARCHAR UNIQUE NOT NULL | |
| `full_name` | VARCHAR | |
| `stripe_customer_id` | VARCHAR UNIQUE | Set on first Stripe interaction |
| `role` | customer_role ENUM | `CUSTOMER`, `ADMIN` |
| `deleted_at` | TIMESTAMPTZ NULL | Soft delete |

Do not store passwords directly — use hashed passwords with bcrypt in a separate `customer_credentials` table, or rely on Stripe Identity / external auth. Store `stripe_customer_id` as soon as a Stripe Customer object is created, to support saved payment methods.

## Orders

**`orders` table**

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `customer_id` | UUID FK → customers.id | |
| `status` | order_status ENUM | See state machine in `api-design` skill |
| `type` | order_type ENUM | `CATALOG`, `CUSTOM` |
| `total_halers` | INTEGER NOT NULL | Sum of line items at time of checkout |
| `shipping_address_id` | UUID FK → addresses.id | |
| `stripe_payment_intent_id` | VARCHAR UNIQUE NULL | Set on PaymentIntent creation |
| `stripe_refund_id` | VARCHAR NULL | Set if refunded |
| `notes` | TEXT NULL | Internal admin notes |

**`order_items` table**

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `order_id` | UUID FK → orders.id | |
| `product_id` | UUID FK → products.id NULL | NULL for custom figurine items |
| `custom_figurine_id` | UUID FK → custom_figurines.id NULL | NULL for catalog items |
| `size` | size_tier ENUM | |
| `quantity` | SMALLINT NOT NULL DEFAULT 1 | |
| `unit_price_halers` | INTEGER NOT NULL | Snapshot price at checkout — never recalculate from product |

Exactly one of `product_id` or `custom_figurine_id` must be non-NULL per row (enforce with a CHECK constraint).

## Custom Figurine Workflow

**`custom_figurines` table**

Tracks the full "Prompt to Print" lifecycle from prompt submission through render approval to production.

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `customer_id` | UUID FK → customers.id | |
| `prompt` | TEXT NOT NULL | Customer's original text prompt |
| `status` | figurine_status ENUM | `PROMPT_RECEIVED`, `RENDER_IN_PROGRESS`, `RENDER_COMPLETE`, `RENDER_REJECTED`, `PENDING_PAYMENT`, etc. |
| `size` | size_tier ENUM | Chosen by customer at prompt submission |
| `render_url` | VARCHAR NULL | URL of generated preview image (stored in S3/GCS) |
| `render_completed_at` | TIMESTAMPTZ NULL | |
| `rejection_reason` | TEXT NULL | Customer's reason when rejecting a render |
| `rejection_count` | SMALLINT DEFAULT 0 | Incremented on each rejection |
| `order_id` | UUID FK → orders.id NULL | Set when customer approves render and proceeds to payment |

**`figurine_status` ENUM values:**
`PROMPT_RECEIVED`, `RENDER_IN_PROGRESS`, `RENDER_COMPLETE`, `RENDER_REJECTED`, `PENDING_PAYMENT`, `PAID`, `IN_PRODUCTION`, `SHIPPED`, `DELIVERED`, `CANCELLED`

## Stripe Payment Records

**`stripe_events` table**

Log all inbound Stripe webhook events to support idempotency and debugging.

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `stripe_event_id` | VARCHAR UNIQUE NOT NULL | Stripe's `evt_xxx` ID — idempotency key |
| `event_type` | VARCHAR NOT NULL | e.g., `payment_intent.succeeded` |
| `payload` | JSONB NOT NULL | Full raw event body |
| `processed_at` | TIMESTAMPTZ NULL | NULL = not yet processed or failed |
| `error` | TEXT NULL | Set if processing raised an exception |

Always check for an existing `stripe_event_id` before processing — Stripe may deliver the same event more than once.

## Addresses

**`addresses` table**

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `customer_id` | UUID FK → customers.id | |
| `line1` | VARCHAR NOT NULL | |
| `line2` | VARCHAR NULL | |
| `city` | VARCHAR NOT NULL | |
| `postal_code` | VARCHAR NOT NULL | |
| `country_code` | CHAR(2) NOT NULL | ISO 3166-1 alpha-2, default `'CZ'` |

## Alembic Conventions

- One migration per logical schema change. Never combine unrelated changes in a single migration.
- Migration filenames: `{rev}_{short_description}.py` — keep descriptions under 6 words.
- Always test `downgrade()` — every migration must be reversible unless there is an explicit documented reason it cannot be.
- Use `op.execute` with raw SQL for enum type creation/alteration (`ALTER TYPE ... ADD VALUE` cannot run inside a transaction — use `with op.get_context().autocommit_block()`).

## Query Patterns

- Use `select()` + `scalars()` for ORM queries. Avoid `session.query()` (legacy style).
- Eager-load relationships needed in the same request using `selectinload` or `joinedload` to avoid N+1 queries.
- For list endpoints, always apply `WHERE deleted_at IS NULL` on soft-deleted tables.
- Index foreign keys and frequently filtered columns (`status`, `customer_id`, `stripe_payment_intent_id`).
