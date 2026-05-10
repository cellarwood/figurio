---
name: order-data-model
description: Model Figurio order, payment, approval, and production data for Postgres-backed prepaid workflows.
---

# Order Data Model

Model the data so operations can track prepaid figurine orders from checkout through MCAE handoff without guesswork.

## Use This Skill For

- Postgres schemas for catalog orders, custom figurine requests, and line items
- Payment, refund, and Stripe webhook reconciliation tables
- Approval, moderation, and rejection history for AI custom figurines
- Production handoff records, retry status, and operator audit trails

## Modeling Rules

- Keep order state, payment state, and production state distinct.
- Prefer append-only history for important transitions over overwriting evidence.
- Store enough detail to reconcile Stripe events without depending on webhook order.
- Make manual operations visible with actor, timestamp, and reason fields.
- Separate launch-critical entities from speculative future concepts.

## Core Entities

- `orders`: commercial parent record for customer intent, totals, currency, and lifecycle
- `order_items`: catalog and custom figurine units with pricing snapshots
- `payments`: Stripe session/payment intent linkage and reconciliation status
- `refunds`: partial or full refund records with internal reason tracking
- `custom_requests`: prompt, source asset, moderation, and printability review data
- `approval_events`: approve/reject/request_changes history with actor and rationale
- `production_handoffs`: MCAE-ready payload, send attempt status, and acknowledgement fields

## Schema Expectations

- Use UUID primary keys unless an external integration requires otherwise.
- Snapshot sell price, cost inputs, and key product attributes at purchase time.
- Normalize state machines enough for integrity, but not so far that operations queries become brittle.
- Add unique constraints for idempotency keys and external Stripe identifiers.
- Add timestamps for created, updated, paid, approved, handed_off, and terminal outcomes where relevant.

## Avoid

- Single-table designs that merge payment, review, and production concerns
- Nullable-field sprawl that hides whether an order is catalog, custom, or mixed
- Derived-state shortcuts that make support reconciliation ambiguous
