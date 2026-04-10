---
name: architecture-review
description: >
  Technical architecture review for the Figurio platform — FastAPI backend,
  React/TypeScript frontend, 3D mesh processing pipeline, Stripe payment
  integration, microk8s/K8s infrastructure, and PostgreSQL schema decisions.
  Use when evaluating new services, reviewing pull requests with structural
  changes, or assessing whether a design fits Figurio's tech stack and
  pipeline constraints.
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

Invoke this skill when:
- A new service, endpoint group, or pipeline stage is being designed
- A PR introduces structural changes (new DB tables, new Celery task types, new API contracts)
- The team is evaluating whether to add a new dependency or external integration
- A post-incident review uncovers a structural failure mode

## Core Platform Components

### Backend — FastAPI + Celery + Redis

- All synchronous CRUD lives in FastAPI routers under `/api/v1/`
- All long-running or async work (AI generation, mesh repair, MCAE file dispatch, preview rendering) runs as **Celery tasks** backed by Redis
- Task results are stored in PostgreSQL via a `jobs` table, not in Redis — Redis is ephemeral
- Worker containers are separate Deployments from the API container; never run Celery inside the API pod

### Frontend — React + TypeScript

- React strict mode enabled; no `any` casts without a comment explaining why
- shadcn-ui / Radix UI primitives only — do not introduce a second component library
- State that spans the order funnel (cart, preview approval, deposit status) lives in a React context or Zustand store — not in component-local state
- No direct API calls inside components — all network requests go through a typed API client layer

### 3D Mesh Pipeline

The pipeline is the core product moat. Every stage must be:
- **Instrumented** — emit structured logs and metrics at entry/exit of each stage
- **Resumable** — a Celery task failure must not lose the original prompt or input mesh
- **Auditable** — store the input, output, and repair diff for every model in object storage (S3-compatible bucket), keyed by `order_id`

Pipeline stages and their ownership:
```
prompt → AI generation API (external) → raw mesh (OBJ/GLB)
      → mesh validation (automated, Python) → repair (NetFabb/Blender script)
      → human QA flag (optional) → rendered preview (PNG/GLTF)
      → customer approval → print file (STL/3MF) → MCAE dispatch
```

A design is acceptable if and only if each stage can fail independently without corrupting downstream stages.

### Stripe Integration

- Use Stripe's `PaymentIntent` flow — not legacy Charges API
- For AI custom orders: two `PaymentIntent` objects per order (50% deposit, 50% balance) linked by metadata `order_id`
- Webhook handler must be idempotent — duplicate events must not double-charge or double-dispatch
- Store `stripe_payment_intent_id` on the `orders` table; never store raw card data anywhere

### PostgreSQL Schema

- Every table has `id UUID PRIMARY KEY DEFAULT gen_random_uuid()`, `created_at`, `updated_at`
- No polymorphic FK columns (e.g., `resource_id` + `resource_type`) — use separate FK columns per related type
- Migrations via Alembic; every migration must be reversible (downgrade defined)
- JSON columns are permitted for model metadata and mesh repair reports, but not for fields that are queried or indexed

### Infrastructure — microk8s + Traefik

- Kubernetes context for local dev: `microk8s-local`; production targets GKE
- Traefik is the ingress; do not expose services directly via NodePort in production
- Each service has its own Namespace: `figurio-api`, `figurio-worker`, `figurio-frontend`
- Resource requests and limits are required on every container spec — no unbounded pods
- Secrets managed via Kubernetes Secrets, injected as env vars — never hardcoded in manifests or images

## Review Checklist

When reviewing a design or PR, check:

- [ ] No synchronous blocking I/O in FastAPI request handlers (offload to Celery)
- [ ] Celery tasks are idempotent — safe to retry on failure
- [ ] New DB tables follow schema conventions (UUID PK, timestamps, reversible migration)
- [ ] Stripe flows use PaymentIntent and webhook idempotency
- [ ] Pipeline stage stores input + output in object storage before marking success
- [ ] No secrets in code or Docker image layers
- [ ] New dependencies justified — package added via `uv add`, not `pip install`
- [ ] Container has resource requests/limits defined

## Anti-patterns

- Running mesh repair or AI generation synchronously inside an API request handler
- Storing Celery task state as the sole source of truth (Redis evicts data)
- Polymorphic FK columns in PostgreSQL
- Adding a second component library to the frontend
- Hardcoding environment-specific URLs or credentials in source code
- Defining a Kubernetes Deployment without resource limits
