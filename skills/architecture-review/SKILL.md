---
name: architecture-review
description: Architecture review checklist for Figurio's e-commerce platform — API design, AI pipeline, database, and deployment architecture for 3D-printed figurine services.
---

# Architecture Review

## Purpose

Ensure every architectural change to the Figurio platform is reviewed against a consistent checklist. This covers the FastAPI backend, React/TS frontend, AI pipeline, and microk8s-local infrastructure.

## Review Checklist

### API Contract Consistency

- [ ] All new endpoints follow `/api/v1/{resource}` naming convention.
- [ ] Request/response schemas use Pydantic models with explicit field types.
- [ ] Pagination uses `page` and `per_page` query parameters consistently.
- [ ] Error responses follow the standard format: `{code, message, details}`.
- [ ] Breaking changes are versioned (new path prefix, not in-place modification).
- [ ] OpenAPI spec is auto-generated and accessible at `/docs`.
- [ ] Public endpoints (catalog, health) do not require authentication.
- [ ] Authenticated endpoints use JWT Bearer tokens.

### Database Schema

- [ ] Tables use snake_case naming, plural form (e.g., `products`, `order_items`).
- [ ] Primary keys are UUIDs, not auto-incrementing integers.
- [ ] Foreign keys have appropriate ON DELETE behavior (CASCADE vs SET NULL).
- [ ] Indexes exist for all columns used in WHERE clauses and JOINs.
- [ ] Enum types are used for fixed-value columns (order_status, size_tier).
- [ ] Migrations are created via Alembic and are reversible.
- [ ] No raw SQL in application code — use SQLAlchemy ORM or Core.
- [ ] Soft deletes for products (is_active flag, not DELETE).

### AI Pipeline Fault Tolerance

- [ ] Text-to-3D API calls have timeout limits (30s generation, 5min polling).
- [ ] Failed generation attempts are retried with exponential backoff (max 3 retries).
- [ ] Mesh repair pipeline has fallback: automated repair → manual queue.
- [ ] Generated 3D models are stored in object storage, not database BLOBs.
- [ ] Pipeline state is tracked per custom order (queued → generating → repairing → ready → approved).
- [ ] Partial failures do not block the entire order — each step is independently recoverable.

### Stripe Integration Security

- [ ] Stripe secret keys are stored in Kubernetes secrets, never in code or config files.
- [ ] Webhook signatures are verified using Stripe's signing secret.
- [ ] Payment intents are created server-side only — no client-side amount manipulation.
- [ ] Idempotency keys are used for all Stripe API calls that create resources.
- [ ] Refund logic handles partial refunds for multi-item orders.
- [ ] PCI compliance: no card numbers touch our servers (Stripe Elements only).

### 3D Model Storage Strategy

- [ ] Models stored as STL (for printing) and glTF/GLB (for web preview).
- [ ] Storage path: `/{product_type}/{product_id}/{variant}.{format}`.
- [ ] Maximum file size enforced (50MB for STL, 10MB for GLB).
- [ ] CDN caching for GLB files served to the 3D viewer.
- [ ] Cleanup job for orphaned files from failed/cancelled orders.

### Caching Strategy

- [ ] Product catalog responses cached with 5-minute TTL.
- [ ] Individual product pages cached with 1-minute TTL.
- [ ] Cart and checkout endpoints are never cached.
- [ ] Cache invalidation on product update/create/delete.
- [ ] 3D model preview URLs use content-hash-based cache keys.

## Architecture Decision Record (ADR) Format

Every significant architecture decision must be documented:

```markdown
# ADR-{NNN}: {Title}

## Status
Proposed | Accepted | Deprecated | Superseded by ADR-{NNN}

## Context
What situation or problem prompted this decision?

## Decision
What architectural choice was made?

## Consequences
### Positive
- Benefit 1
- Benefit 2

### Negative
- Tradeoff 1
- Tradeoff 2

### Neutral
- Side effect that is neither positive nor negative

## Alternatives Considered
1. Alternative A — rejected because...
2. Alternative B — rejected because...
```

## Build-vs-Buy Evaluation Template

Use this when deciding whether to build in-house or use an external service:

| Criterion             | Build In-House          | Buy / Use Service       |
|-----------------------|-------------------------|-------------------------|
| Time to production    | Weeks/months            | Days/weeks              |
| Ongoing maintenance   | Our team maintains      | Vendor maintains        |
| Customization         | Full control            | Limited to vendor API   |
| Cost (year 1)         | Engineering hours       | Subscription/API fees   |
| Cost (year 2+)        | Maintenance hours       | Subscription/API fees   |
| Vendor risk           | None                    | Dependency + lock-in    |
| Data ownership        | Full                    | Check vendor terms      |
| Scaling               | Our responsibility      | Vendor handles          |

**Decision rule:** Buy when the capability is not a core differentiator. Build when it directly affects figurine quality, customer experience, or competitive advantage.

## Review Process

1. Author submits architecture proposal or ADR.
2. CTO reviews against this checklist within 2 business days.
3. If the change touches payments: additional security review required.
4. If the change touches AI pipeline: performance benchmark required.
5. Approved changes are merged; ADR is stored in `/docs/adrs/`.
