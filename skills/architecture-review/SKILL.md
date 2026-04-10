---
name: architecture-review
description: >
  Review system architecture decisions for the Figurio D2C figurine platform.
  Covers FastAPI backend structure, React/TS frontend boundaries, AI text-to-3D
  pipeline (Meshy/Tripo3D), Stripe prepay flow, and Docker/K8s deployment on microk8s.
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

Use this skill when evaluating a proposed system design, reviewing a PR that crosses service boundaries, or assessing whether a new component fits the existing Figurio platform.

## Platform Map

```
Browser (React/TS + shadcn-ui/Tailwind)
        │  REST + WebSocket
        ▼
FastAPI backend  ──── PostgreSQL
        │
        ├── Stripe webhook handler (prepay gate)
        ├── AI pipeline coordinator
        │       ├── Meshy API
        │       └── Tripo3D API
        └── MCAE production handoff (file delivery)

Infrastructure: microk8s, Traefik ingress, Terraform, GitHub Actions CI/CD
```

## Review Dimensions

### 1. Separation of Concerns

- FastAPI routes must not contain business logic. Logic lives in service modules (`services/`), routes call services.
- React components must not fetch data directly. All API calls go through a typed client layer (`src/api/`).
- The AI pipeline coordinator is the single point that decides which model (Meshy vs. Tripo3D) handles a request. No other service calls AI providers directly.

### 2. Vendor Coupling Risk

Figurio's AI provider landscape is unstable — both Meshy and Tripo3D are early-stage vendors. Any architecture that deeply couples to one provider's response schema is a liability.

Ask:
- Can the AI provider be swapped with one config change and a new adapter module?
- Are provider-specific response formats translated at the adapter boundary, not leaked into domain models?
- Is the mesh repair / post-processing step decoupled from the generation step?

Flag as a concern if: provider-specific field names appear outside of `integrations/` or `adapters/`.

### 3. Payment Flow Integrity

Figurio operates prepaid — no order is fulfilled without Stripe payment confirmed.

Review checklist for any change touching order flow:
- Stripe webhook signature verification is present and tested.
- Order status transitions are gated: `pending → paid → in_production → shipped`. No skips.
- Fulfillment (MCAE handoff) is only triggered from the `paid` state, never from the API request directly.
- Failed webhook delivery is handled with idempotency (Stripe event ID stored, duplicate webhooks ignored).

### 4. K8s Deployment Fit

Figurio runs microk8s on a small cluster. Proposals must fit this constraint.

Flag as a concern if:
- A component requires a StatefulSet with complex PVC management when a managed cloud service would cost less.
- A new service is added without a liveness/readiness probe.
- Resource requests/limits are missing — unset limits on a small cluster cascade to OOM kills.
- A new service bypasses Traefik ingress and exposes a port directly.

### 5. Operational Cost at Current Scale

At Figurio's current stage (pre-revenue, small team), operational complexity is a real cost.

Reject or flag for redesign if a proposal:
- Adds a new stateful component (Redis, RabbitMQ, etc.) when PostgreSQL + async FastAPI background tasks suffice.
- Requires a dedicated operator or custom controller on the K8s cluster.
- Introduces a second language runtime to the backend (Python is the constraint — not negotiable without CTO sign-off).

## Review Output Format

When completing an architecture review, write:

```
## Architecture Review: [component/PR/proposal name]

**Decision:** [Approve / Approve with conditions / Reject]

**Rationale:** [1-2 paragraphs — what fits, what doesn't, why]

**Conditions / Required changes:**
- [specific change 1]
- [specific change 2]

**Open questions:**
- [anything that needs more information before proceeding]
```

Keep it under one page. If you cannot summarize the issue in one page, the design is not clear enough to approve.

## Anti-patterns to Reject

- Business logic in FastAPI route handlers
- Direct AI provider calls from frontend or from non-coordinator backend services
- Order fulfillment triggered before Stripe `payment_intent.succeeded` webhook
- New services with no resource limits in K8s manifests
- Synchronous HTTP calls to Meshy/Tripo3D inside a request cycle (must be async/background)
