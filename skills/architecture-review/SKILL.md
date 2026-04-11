---
name: architecture-review
description: >
  Review technical designs for Figurio's services — FastAPI backend API contracts,
  PostgreSQL database schema, text-to-3D pipeline architecture, React/TS frontend
  structure, and K8s deployment topology on microk8s with Traefik ingress.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags:
      - engineering
      - review
      - architecture
---

# Architecture Review

Use this skill when evaluating a proposed technical design, PR, or RFC for any
Figurio service before implementation begins or merges.

## When to Use

- A backend engineer proposes a new FastAPI endpoint or changes an existing contract
- A schema migration (Alembic) is proposed that touches orders, products, renders, or users
- The text-to-3D pipeline gains a new stage (upload → generation → mesh repair → preview → delivery)
- A frontend engineer proposes a new React component tree or routing change
- A DevOps change touches K8s manifests, Helm values, or Traefik routing rules

## Review Dimensions

### 1. API Contracts (FastAPI)

- Endpoints follow `/api/v{n}/{resource}` naming; current version is `v1`
- Request/response models are Pydantic v2 — no raw `dict` returns
- All mutations (POST/PUT/PATCH/DELETE) require explicit Stripe idempotency keys where payment side-effects are possible
- Async handlers (`async def`) are required for any DB or external I/O call
- Background tasks (mesh repair, render job dispatch) use FastAPI `BackgroundTasks` or are enqueued — never blocking a request handler
- Errors follow the standard envelope: `{"error": {"code": "...", "message": "..."}}`

### 2. PostgreSQL Schema (Alembic)

- Every migration has a matching downgrade path unless the change is purely additive and explicitly noted
- Foreign keys to `orders` and `products` must use `ON DELETE RESTRICT` by default; only override with justification
- Indexes on columns used in WHERE filters for catalog queries (`product_id`, `sku`, `status`, `created_at`)
- UUIDs as primary keys for all new tables (not serial integers)
- JSON/JSONB columns are acceptable for mesh metadata and AI generation parameters — document expected shape in a comment
- No business logic in triggers or stored procedures; keep logic in the Python service layer

### 3. Text-to-3D Pipeline Architecture

The pipeline stages are: **prompt → external generation API → mesh download → mesh repair → format conversion → preview render → CDN upload → order linked**

Review checklist for pipeline changes:
- Is each stage idempotent? Re-running a failed stage must not duplicate records or charges
- Generation API calls (Meshy, Tripo3D, etc.) are wrapped in a retry-with-backoff layer; webhook callbacks are preferred over polling where the provider supports them
- Mesh repair (e.g., manifold checks, watertight validation) runs before any preview is shown to the customer
- PyTorch inference (custom model paths) is isolated in a separate worker process — not in the FastAPI process
- File artifacts are stored in object storage (not local disk); filenames include job UUID and stage suffix (e.g., `{job_id}_repaired.stl`)
- MCAE print-readiness constraints: PolyJet, Stratasys J55 — flag designs that exceed build volume (342 × 228 × 200 mm) or minimum wall thickness (1 mm)

### 4. React/TS Frontend Structure

- Components live under `src/components/`; pages under `src/pages/`
- shadcn-ui primitives are extended, not forked — no copy-paste of shadcn source into the repo
- All API calls go through a typed client generated from the FastAPI OpenAPI spec; no raw `fetch` in components
- Tailwind utility classes only — no inline styles, no custom CSS files except `globals.css`
- 3D preview uses a dedicated `<ModelViewer>` component (Three.js / React Three Fiber); it must lazy-load and not block the catalog page
- Stripe.js is loaded once at the app root and injected via context — not imported in individual checkout components

### 5. K8s Deployment Topology (microk8s + Traefik + Helm)

- Each service (api, worker, frontend, ml-worker) has its own Deployment + Service; no multi-container pods except for sidecar log shippers
- Traefik IngressRoute rules: `/api/` → api service; `/` → frontend service; no wildcard catch-alls on the api prefix
- Resource requests and limits are required on every container spec; flag any container without them
- ML worker (PyTorch) and mesh repair worker run as separate Deployments with GPU node affinity if applicable; they must not share pods with the FastAPI service
- Secrets (Stripe keys, DB passwords, external API keys) are stored in K8s Secrets, referenced as env vars — never hardcoded in Helm values files committed to the repo
- Health checks: `livenessProbe` and `readinessProbe` required on api and worker deployments

## Verdict Format

After reviewing, summarize with:

```
## Architecture Review: <component or PR title>

**Verdict:** Approve / Approve with changes / Request changes / Block

### Issues
- [BLOCKING] ...
- [MAJOR] ...
- [MINOR] ...

### Recommendations
- ...

### Open Questions
- ...
```

Use **BLOCKING** for issues that would cause data loss, payment inconsistency, or pipeline corruption. Use **MAJOR** for correctness or maintainability problems. Use **MINOR** for style or preference deviations.
