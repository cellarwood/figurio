---
name: architecture-review
description: >
  Review system design decisions for the Figurio platform — FastAPI backend,
  React/TS frontend, PostgreSQL, text-to-3D AI pipeline (Meshy/Tripo3D),
  Stripe payments, and K8s deployment on microk8s. Use when evaluating new
  services, integration patterns, data models, or infrastructure changes.
metadata:
  paperclip:
    tags:
      - engineering
      - architecture
      - review
---

# Architecture Review

## When to Use

Apply this skill when:
- A new service, integration, or infrastructure component is proposed
- An existing subsystem needs significant refactoring
- A cross-cutting concern (auth, caching, observability) needs a design decision
- A new AI pipeline stage (generation, repair, validation) is being scoped

## Platform Overview

Figurio runs a D2C e-commerce platform for full-color 3D-printed figurines with two product lines:
1. **Catalog products** — predefined figurine SKUs, standard order flow
2. **AI custom products** — customer uploads or describes a figurine; text-to-3D pipeline produces the mesh, which is printed

| Layer | Technology |
|-------|-----------|
| Frontend | React + TypeScript, shadcn-ui, Tailwind CSS |
| Backend API | Python / FastAPI |
| Database | PostgreSQL |
| AI pipeline | Meshy or Tripo3D (external API), internal mesh repair/validation |
| Payments | Stripe (checkout + webhooks) |
| Container orchestration | Kubernetes via microk8s |
| Ingress | Traefik |
| Deployment | Docker images, K8s manifests |

## Review Checklist

### API & Service Boundaries
- Does the proposed service have a single, well-scoped responsibility?
- Are endpoints RESTful and consistent with existing Figurio conventions (`/api/v1/{resource}`)?
- Is the service stateless? State must live in PostgreSQL, not in-process.
- Are long-running tasks (AI mesh generation, print job processing) handled asynchronously via a task queue — not blocking the API response?

### Data Model
- Are new tables normalized and consistent with existing PostgreSQL schema conventions?
- Are foreign keys and indexes defined for all join paths used by the application?
- Are soft deletes used for customer-facing records (orders, custom designs) to preserve audit trail?
- Is sensitive data (PII, payment tokens) kept out of application logs and avoided in custom columns?

### AI Pipeline (text-to-3D)
- Is the external AI provider call (Meshy / Tripo3D) isolated behind an internal adapter so the provider can be swapped?
- Is mesh quality validation (polygon count, manifold check, color fidelity) a separate, mandatory step before the mesh reaches the print queue?
- Are generation failures surfaced to the customer with actionable messaging, not raw API errors?
- Is the generated mesh stored in object storage (not PostgreSQL) with only the reference URL in the DB?

### Payments (Stripe)
- Are payment intents created server-side only — never from the frontend?
- Is Stripe webhook signature verification enforced for all `/webhooks/stripe` endpoints?
- Is the idempotency key pattern used for all Stripe API calls to prevent double-charges on retries?
- Are order state transitions driven by Stripe webhook events, not by client-side callbacks?

### Kubernetes / microk8s
- Does the new workload have defined CPU/memory `requests` and `limits`?
- Are secrets stored in K8s Secrets (or an external secret store), not in ConfigMaps or environment variables baked into images?
- Does the service expose a `/healthz` liveness probe and `/readyz` readiness probe?
- Are AI pipeline workers deployed as a separate Deployment (not co-located with the API) so they can scale independently?

### Security
- Are all backend endpoints protected by authentication middleware unless explicitly exempted?
- Is CORS restricted to the Figurio frontend origin in production?
- Are file uploads (customer reference images) validated for MIME type and size before storage?

## Common Anti-Patterns

- Calling Meshy/Tripo3D synchronously from the API request path — use a task queue
- Storing mesh files in PostgreSQL as BLOBs — use object storage
- Triggering order fulfillment from a frontend success redirect — always use Stripe webhooks
- Running microk8s workloads without resource limits — leads to noisy-neighbour failures on the single-node cluster
- Hardcoding AI provider credentials in Dockerfiles or K8s manifests

## Output Format for Reviews

When documenting a review decision, write:

```
## Decision: <title>

**Status:** Proposed | Accepted | Rejected | Superseded

**Context:** <what problem this solves in Figurio terms>

**Decision:** <what we are doing>

**Consequences:** <trade-offs, follow-up tasks, risks>
```
