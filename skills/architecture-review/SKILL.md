---
name: architecture-review
description: >
  Review system architecture decisions for Figurio — a D2C e-commerce platform
  for 3D-printed figurines. Covers the FastAPI backend, React/TS frontend,
  text-to-3D AI pipeline (Meshy/Tripo3D), Stripe payments, PostgreSQL data
  model, and Docker/K8s (microk8s) deployment topology.
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

Use this skill when evaluating proposed or existing architecture changes across
the Figurio platform — new services, integration patterns, data model changes,
AI pipeline adjustments, or infrastructure topology shifts.

## When to Use

- A new feature requires a decision that spans multiple layers (frontend, API,
  DB, AI pipeline, infra)
- A service boundary is being added, split, or merged
- An external API or vendor is being introduced or replaced
- Performance, reliability, or cost concerns require structural changes
- A PR introduces architectural drift from established patterns

## System Map

```
Browser (React/TS + shadcn)
  │
  ▼
Traefik (ingress, TLS termination)
  │
  ├─▶ FastAPI (Python, uv) — REST API + background tasks
  │       │
  │       ├─▶ PostgreSQL  (primary datastore)
  │       ├─▶ Stripe      (payments, webhooks)
  │       └─▶ AI Pipeline (text-to-3D)
  │               ├─▶ Meshy API   (primary)
  │               └─▶ Tripo3D API (fallback / comparison)
  │                       │
  │                       └─▶ Mesh Repair (post-process)
  │
microk8s cluster — Docker containers, GitHub Actions CI/CD
Sentry — error monitoring (frontend + backend)
```

## Review Dimensions

### 1. Layering and Service Boundaries

- FastAPI is the single backend — avoid introducing a second Python service
  unless the workload is clearly separate (e.g., a long-running mesh repair
  worker).
- React/TS is the single frontend — no micro-frontends.
- Background tasks (AI job polling, mesh repair) belong in FastAPI background
  tasks or a dedicated worker pod, not in request handlers.

### 2. Data Model (PostgreSQL)

- Migrations must be versioned (Alembic). No schema changes outside migrations.
- Orders, figurines, mesh assets, and Stripe objects are the core entities.
  New entities must justify foreign key relationships to these four.
- Avoid storing raw mesh binary in PostgreSQL — use object storage; store only
  the reference URL.

### 3. AI Pipeline

- Text-to-3D requests are async — never block the HTTP response waiting for
  Meshy/Tripo3D to complete.
- The pipeline must handle provider failure gracefully: queue the job, expose
  status polling, and support retry.
- Mesh repair runs after generation; failures here should not fail the order —
  flag for manual review instead.
- New providers must implement the same job-status interface before being
  merged into the pipeline.

### 4. Payments (Stripe)

- All Stripe state changes are driven by webhooks, not by API response alone.
- Idempotency keys are required on all Stripe API calls.
- Order fulfillment (triggering the AI pipeline) only starts after a
  `payment_intent.succeeded` webhook is confirmed.

### 5. Deployment (microk8s)

- Every service ships as a Docker image built by GitHub Actions.
- Config and secrets are injected via Kubernetes Secrets/ConfigMaps — never
  baked into images.
- Traefik handles routing; do not expose new ports directly — add Ingress rules.
- New workloads must include resource requests/limits and a liveness probe.

### 6. Observability

- Sentry is the error sink for both React (frontend SDK) and FastAPI
  (Sentry Python SDK). New services must initialise Sentry on startup.
- Structured logging (JSON) to stdout — no custom log aggregators.

## Review Checklist

When evaluating a proposal, work through these questions:

- [ ] Does this fit within the existing service boundary, or does it require a
      new service? If new, is the justification clear?
- [ ] What is the failure mode? Is it recoverable without human intervention?
- [ ] Does it introduce a new external dependency? What is the fallback?
- [ ] Are database changes backwards-compatible during a rolling deploy?
- [ ] Does the AI pipeline change preserve the async/status-poll contract?
- [ ] Are secrets managed via Kubernetes Secrets?
- [ ] Is Sentry instrumented for new error paths?
- [ ] Are there resource implications (DB connections, memory for mesh files)?

## Common Anti-patterns

- Synchronous waits on Meshy/Tripo3D in an HTTP handler — pipeline jobs take
  10–120 seconds.
- Direct Stripe charge on frontend — all payment intent creation must go
  through the FastAPI backend.
- Storing 3D mesh files (`.glb`, `.obj`) in PostgreSQL as bytea.
- Hardcoded provider choice (Meshy-only) — the pipeline must remain
  provider-agnostic at the interface level.
- Skipping Alembic for "quick" schema additions.
