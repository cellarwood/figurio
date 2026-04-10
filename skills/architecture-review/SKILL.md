---
name: architecture-review
description: >
  Review system architecture decisions for Figurio's D2C 3D-figurine platform.
  Covers API design and versioning, PostgreSQL schema design, service boundary
  definitions between catalog/order/AI-pipeline services, and build-vs-buy
  evaluation for 3D model processing and AI generation workflows.
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

Use this skill when evaluating or challenging design decisions across Figurio's
backend services, database schema, API surface, or infrastructure topology.

## Service Boundaries

Figurio's backend is split into three primary service domains. Keep these
boundaries explicit — cross-service calls must go through defined API contracts,
not shared database tables.

### Catalog Service
- Owns product definitions: SKU, name, thumbnail, material options, price tiers
- Read-heavy; data changes only when ops team updates the figurine lineup
- Exposes: `GET /api/v1/products`, `GET /api/v1/products/{sku}`
- No writes from order or AI-pipeline services into catalog tables

### Order Service
- Owns the full order lifecycle: cart → Stripe prepayment → fulfillment handoff
- Holds references to catalog SKUs (foreign key by SKU string, not catalog DB row ID)
- Communicates MCAE production status via webhook receiver — does not poll
- Exposes: `POST /api/v1/orders`, `GET /api/v1/orders/{order_id}`, fulfillment webhook

### AI-Pipeline Service
- Owns the "Prompt to Print" workflow: prompt intake → model generation → review → STL handoff
- Calls external vendor API (Meshy or Tripo3D) asynchronously; never blocks the HTTP response
- Stores generation job state (pending/processing/approved/rejected) in its own schema
- On approval, pushes STL reference into order service via internal API call — does not write to order tables directly

## API Design Conventions

- All public endpoints: `/api/v1/{resource}` (collections) and `/api/v1/{resource}/{id}` (single item)
- Internal service-to-service endpoints: `/internal/v1/{resource}` — not exposed through Traefik ingress
- Error responses always return `{ "error": { "code": "SNAKE_CASE_CODE", "message": "..." } }`
- Pagination via `?page=` and `?per_page=` (default 20, max 100) on all collection endpoints
- Stripe webhook handler lives at `/webhooks/stripe` — validate signature before processing

## Database Schema Principles

- Each service domain has its own PostgreSQL schema (`catalog`, `orders`, `ai_pipeline`) in the shared cluster
- No cross-schema foreign key constraints — reference by business key (e.g., `sku`, `order_id` UUID)
- Use `TIMESTAMPTZ` for all timestamps; store in UTC
- Soft-delete pattern (`deleted_at TIMESTAMPTZ`) for catalog items and orders — never hard delete
- AI generation jobs: index on `(status, created_at)` for queue polling queries

## Build vs. Buy Evaluation Framework

When assessing whether to build a component or use an external vendor, apply these criteria in order:

1. **Core differentiator?** If yes, build it. Figurio's differentiator is the AI customization UX and order experience — not rendering pipelines or payment infrastructure.
2. **3D processing and model generation** — buy. Meshy/Tripo3D are external vendors. Integration cost is low; switching cost is manageable if the AI-pipeline service wraps the vendor behind a stable internal interface.
3. **Payments** — buy (Stripe). Never implement payment processing in-house.
4. **Production/print handoff to MCAE** — thin integration layer only. MCAE operates Stratasys J55 PolyJet hardware; Figurio's responsibility ends at delivering a validated STL file and order manifest.
5. **Auth/identity** — evaluate managed solutions before building. Figurio is a small team; a custom auth service is not worth the maintenance burden.

## Review Checklist

When reviewing a proposed architecture change, confirm:

- [ ] Service boundary is respected — no cross-domain direct DB access
- [ ] New endpoints follow `/api/v1/` naming and error response format
- [ ] Async operations (AI generation, MCAE handoff) are non-blocking
- [ ] Vendor integrations are wrapped behind an internal interface (not called directly from business logic)
- [ ] Schema changes include migration scripts and are backward compatible
- [ ] No synchronous calls from AI-pipeline to external vendor inside an HTTP request cycle
- [ ] Internal endpoints are excluded from Traefik public ingress rules

## Anti-patterns

- Calling the Meshy/Tripo3D API synchronously inside a FastAPI route handler — use a background task or job queue
- Sharing a PostgreSQL table between two service domains
- Storing Stripe payment method details in Figurio's own database (use Stripe customer/payment intent IDs only)
- Exposing internal service endpoints through the public Traefik ingress
- Hardcoding vendor-specific model generation parameters in order or catalog logic
