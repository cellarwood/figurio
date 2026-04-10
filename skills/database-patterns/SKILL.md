---
name: database-patterns
description: >
  PostgreSQL schema and SQLAlchemy patterns for Figurio — product catalog with
  size tier pricing, order lifecycle state machine, payment records, user
  accounts, and 3D model metadata. Covers Alembic migration conventions and
  ORM best practices.
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

PostgreSQL schema design and SQLAlchemy conventions for the Figurio backend.

## Base Model

All tables inherit from a shared base that provides `id`, `created_at`, and `updated_at`:

```python
import uuid
from datetime import datetime
from sqlalchemy import DateTime, func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy.dialects.postgresql import UUID

class Base(DeclarativeBase):
    pass

class TimestampMixin:
    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
```

Use `UUID` primary keys everywhere. Never use integer auto-increment IDs for entities exposed in the API.

## User Accounts

```python
class User(TimestampMixin, Base):
    __tablename__ = "users"

    email: Mapped[str] = mapped_column(unique=True, nullable=False, index=True)
    hashed_password: Mapped[str] = mapped_column(nullable=False)
    role: Mapped[str] = mapped_column(nullable=False, default="customer")  # "customer" | "admin"
    is_active: Mapped[bool] = mapped_column(nullable=False, default=True)
    stripe_customer_id: Mapped[str | None] = mapped_column(unique=True, nullable=True)
```

Index `email` and `stripe_customer_id`. Store only `hashed_password` — never plaintext.

## Product Catalog

```python
class Product(TimestampMixin, Base):
    __tablename__ = "products"

    slug: Mapped[str] = mapped_column(unique=True, nullable=False, index=True)
    name: Mapped[str] = mapped_column(nullable=False)
    description: Mapped[str | None]
    category: Mapped[str] = mapped_column(nullable=False)  # "catalog" | "custom"
    is_available: Mapped[bool] = mapped_column(nullable=False, default=True)

    variants: Mapped[list["ProductVariant"]] = relationship(back_populates="product")


class ProductVariant(TimestampMixin, Base):
    __tablename__ = "product_variants"

    product_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("products.id"), nullable=False, index=True)
    size_tier: Mapped[str] = mapped_column(nullable=False)   # "small" | "medium" | "large" | "xl"
    price_cents: Mapped[int] = mapped_column(nullable=False) # always integer cents
    currency: Mapped[str] = mapped_column(nullable=False, default="usd")
    sku: Mapped[str] = mapped_column(unique=True, nullable=False)
    is_available: Mapped[bool] = mapped_column(nullable=False, default=True)

    product: Mapped["Product"] = relationship(back_populates="variants")
```

Size tier pricing lives on `ProductVariant`, not on `Product`. Each variant has its own `price_cents` and `sku`.

## 3D Model Metadata

Custom figurine orders carry a reference to a generated mesh. Store metadata — not the file — in Postgres; actual mesh files live in object storage.

```python
class FigurineModel(TimestampMixin, Base):
    __tablename__ = "figurine_models"

    order_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("orders.id"), nullable=False, unique=True)
    prompt_text: Mapped[str] = mapped_column(nullable=False)
    storage_key: Mapped[str] = mapped_column(nullable=False)      # S3/GCS object key
    file_format: Mapped[str] = mapped_column(nullable=False)      # "stl" | "obj" | "3mf"
    mesh_repair_status: Mapped[str] = mapped_column(nullable=False, default="pending")
    # "pending" | "passed" | "failed"
    moderation_status: Mapped[str] = mapped_column(nullable=False, default="pending")
    # "pending" | "approved" | "rejected"
    moderation_reason: Mapped[str | None]
    polygon_count: Mapped[int | None]
```

## Orders

```python
class Order(TimestampMixin, Base):
    __tablename__ = "orders"

    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id"), nullable=False, index=True)
    status: Mapped[str] = mapped_column(nullable=False, default="placed", index=True)
    total_amount_cents: Mapped[int] = mapped_column(nullable=False)
    currency: Mapped[str] = mapped_column(nullable=False, default="usd")
    stripe_checkout_session_id: Mapped[str | None] = mapped_column(unique=True, nullable=True)

    line_items: Mapped[list["OrderLineItem"]] = relationship(back_populates="order")
    payments: Mapped[list["PaymentRecord"]] = relationship(back_populates="order")
    audit_logs: Mapped[list["OrderAuditLog"]] = relationship(back_populates="order")


class OrderLineItem(TimestampMixin, Base):
    __tablename__ = "order_line_items"

    order_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("orders.id"), nullable=False, index=True)
    variant_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("product_variants.id"), nullable=False)
    quantity: Mapped[int] = mapped_column(nullable=False)
    unit_price_cents: Mapped[int] = mapped_column(nullable=False)  # snapshot at time of order
    currency: Mapped[str] = mapped_column(nullable=False, default="usd")
```

`unit_price_cents` is snapshotted at order creation — do not join to `product_variants.price_cents` to reconstruct historical totals.

## Order State Machine

Valid transitions (enforced in the service layer, not in the DB):

```
placed       → paid | payment_failed | cancelled
paid         → preparing | cancelled
preparing    → printing
printing     → shipped
shipped      → delivered
payment_failed → (terminal)
cancelled    → (terminal)
```

Every transition writes an `OrderAuditLog` row atomically in the same transaction:

```python
class OrderAuditLog(Base):
    __tablename__ = "order_audit_logs"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("orders.id"), nullable=False, index=True)
    from_status: Mapped[str] = mapped_column(nullable=False)
    to_status: Mapped[str] = mapped_column(nullable=False)
    actor: Mapped[str] = mapped_column(nullable=False)    # "system" | "admin:{user_id}" | "webhook"
    reason: Mapped[str | None]
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    order: Mapped["Order"] = relationship(back_populates="audit_logs")
```

`OrderAuditLog` has no `updated_at` — audit rows are immutable.

## Payment Records

```python
class PaymentRecord(TimestampMixin, Base):
    __tablename__ = "payment_records"

    order_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("orders.id"), nullable=False, index=True)
    stripe_event_id: Mapped[str] = mapped_column(unique=True, nullable=False)  # idempotency key
    stripe_payment_intent_id: Mapped[str | None] = mapped_column(nullable=True)
    event_type: Mapped[str] = mapped_column(nullable=False)  # e.g. "checkout.session.completed"
    amount_cents: Mapped[int] = mapped_column(nullable=False)
    currency: Mapped[str] = mapped_column(nullable=False)
    status: Mapped[str] = mapped_column(nullable=False)  # "succeeded" | "failed" | "refunded"

    order: Mapped["Order"] = relationship(back_populates="payments")
```

`stripe_event_id` has a unique constraint — use it to detect duplicate webhook deliveries before processing.

## Alembic Conventions

- One migration per logical change. Do not bundle unrelated schema changes.
- Migration filenames: Alembic's default timestamp prefix is fine.
- Always provide a `downgrade()` that fully reverses the `upgrade()`.
- For data migrations, use raw SQL via `op.execute()` — do not import ORM models inside migration files (they may not exist at downgrade time).
- New columns on existing tables: add as `nullable=True` or with a server default so the migration runs without locking the table.
- Index creation: use `op.create_index(..., postgresql_concurrently=True)` for large tables in production migrations.

## Query Patterns

Async sessions everywhere:

```python
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

async def get_order(db: AsyncSession, order_id: uuid.UUID) -> Order | None:
    result = await db.execute(select(Order).where(Order.id == order_id))
    return result.scalar_one_or_none()
```

Avoid N+1 queries — use `selectinload` or `joinedload` when you know you need relationships:

```python
result = await db.execute(
    select(Order)
    .options(selectinload(Order.line_items))
    .where(Order.id == order_id)
)
```

Never call `db.commit()` inside a route handler directly — commit in the service layer or use a dependency that commits on success.

## Anti-patterns

- Do not use `Float` or `Numeric` for money columns — use `Integer` (cents).
- Do not import ORM models inside Alembic migration files.
- Do not store raw Stripe webhook payloads — store only the verified event fields.
- Do not add business logic to SQLAlchemy event hooks — keep transitions in the service layer.
- Do not skip the unique constraint on `stripe_event_id` — it is the idempotency guard.
