---
name: architecture-review
description: >
  Review system architecture decisions for the Figurio platform — a D2C e-commerce
  for 3D-printed figurines. Covers API design between React/FastAPI layers, PostgreSQL
  schema design, service boundary decisions, and integration patterns for the MCAE
  print pipeline, Stripe payments, and Zásilkovna shipping.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags:
      - engineering
      - architecture
      - review
---

# Architecture Review

## When to Use

Invoke this skill when evaluating or proposing:
- New FastAPI service endpoints or restructuring existing ones
- PostgreSQL schema changes (new tables, migrations, index strategy)
- Service boundary decisions (what lives in the API vs. a background worker vs. a pipeline step)
- Integration patterns for external systems: MCAE print pipeline, Stripe, Zásilkovna
- AI "Prompt to Print" pipeline architecture (prompt → 3D model generation → print queue)

## Core Architecture Overview

Figurio runs on:
- **Frontend**: React + TypeScript, shadcn/ui components, hosted separately
- **Backend**: Python/FastAPI — single deployable service, versioned under `/api/v1/`
- **Database**: PostgreSQL — one primary DB, migrations via Alembic
- **Infrastructure**: Docker containers orchestrated with Kubernetes (GKE or similar)
- **Payments**: Stripe (checkout sessions + webhooks)
- **Shipping**: Zásilkovna API (parcel label generation, tracking)
- **Print**: MCAE pipeline integration — orders submitted as print jobs, status polled or webhoooked back

## API Design Conventions

### Endpoint Structure

```
/api/v1/{resource}            # collections (GET list, POST create)
/api/v1/{resource}/{id}       # single item (GET, PATCH, DELETE)
/api/v1/{resource}/{id}/{sub} # nested sub-resource
```

Domain-specific examples:
- `/api/v1/products` — catalog listings
- `/api/v1/orders/{order_id}` — order detail
- `/api/v1/orders/{order_id}/print-jobs` — print jobs for an order
- `/api/v1/generations` — AI prompt-to-3D generation requests
- `/api/v1/generations/{generation_id}/preview` — 3D preview asset

### Response Shape

All responses use a consistent envelope:
```json
{
  "data": { ... },
  "meta": { "page": 1, "total": 120 }   // list endpoints only
}
```

Errors follow RFC 9457 (Problem Details):
```json
{
  "type": "https://figurio.cz/errors/print-job-rejected",
  "title": "Print job rejected",
  "status": 422,
  "detail": "MCAE pipeline rejected model: non-manifold geometry"
}
```

### Authentication

- Customer-facing routes: JWT bearer tokens issued at login
- Webhook routes (Stripe, MCAE callback): HMAC signature verification middleware, not JWT
- Internal service-to-service: mTLS or shared secret via Kubernetes secrets

## Database Schema Guidelines

### Naming

- Tables: `snake_case`, plural nouns (`orders`, `print_jobs`, `ai_generations`)
- Foreign keys: `{table_singular}_id` (e.g., `order_id`, `product_id`)
- Timestamps: always include `created_at`, `updated_at` (with DB-level defaults)
- Soft deletes: use `deleted_at` nullable timestamp, not a boolean flag

### Key Tables and Boundaries

| Domain | Tables | Notes |
|--------|--------|-------|
| Catalog | `products`, `product_variants` | SKU lives on variant |
| Orders | `orders`, `order_items` | Stripe `payment_intent_id` stored on `orders` |
| Print | `print_jobs` | FK to `order_items`; MCAE job ID tracked here |
| AI Gen | `ai_generations` | FK to `orders` when converted to order item |
| Shipping | `shipments` | Zásilkovna parcel ID, tracking URL |

### Indexing

- Always index FK columns used in JOIN-heavy queries
- Add partial index on `print_jobs.status` for polling queries: `WHERE status IN ('pending', 'processing')`
- `ai_generations` table: index `(user_id, created_at DESC)` for customer history queries

## Service Boundary Rules

### What Stays in FastAPI

- Request validation (Pydantic models)
- Business rule enforcement (e.g., order state machine transitions)
- Stripe checkout session creation and webhook handling
- Zásilkovna label generation requests
- Serving product catalog and order history

### What Goes to Background Workers (Celery/ARQ)

- Polling MCAE print job status (do not block API request/response)
- Sending transactional emails (order confirmation, shipping notification)
- Post-processing AI-generated 3D models (geometry validation, thumbnail render)
- Retrying failed Zásilkovna API calls

### 3D Print Pipeline Integration

The MCAE integration is async by nature — do not make synchronous HTTP calls to MCAE from API request handlers.

Flow:
1. Order confirmed (Stripe webhook) → API writes `print_job` row with `status=pending`
2. Background worker picks up pending jobs → submits to MCAE API → updates `status=submitted`, stores MCAE job ID
3. MCAE sends webhook callback (or worker polls) → updates `status=printing|completed|rejected`
4. On completion: trigger shipment creation via Zásilkovna

## Review Checklist

When reviewing an architecture proposal, verify:

- [ ] Endpoints follow `/api/v1/` conventions; no business logic leaking into URL design
- [ ] Async operations (MCAE, email) are offloaded to workers, not blocking API handlers
- [ ] Stripe and MCAE webhook handlers verify signatures before processing
- [ ] New tables have `created_at`, `updated_at`, proper FK indexes
- [ ] No direct DB calls from the AI generation pipeline — goes through the API layer
- [ ] Service boundaries are respected: workers write to DB, API reads from DB, never reversed for critical paths
- [ ] Schema migrations are additive where possible (backward-compatible with running pods during rolling deploy)

## Anti-patterns

- Synchronous HTTP calls to MCAE or Zásilkovna inside API request handlers
- Storing Stripe secret keys or MCAE credentials in environment variables without Kubernetes Secrets
- Fat endpoints that mix catalog logic with order logic — keep domain boundaries in router modules
- Polling print job status from the frontend — status should be pushed via websocket or SSE from the backend
- Nullable columns used as soft deletes instead of `deleted_at`
