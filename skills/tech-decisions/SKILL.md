---
name: tech-decisions
description: >
  Technical decision records for Figurio's D2C 3D-figurine platform. Covers
  rationale behind stack choices (FastAPI, React/TS, microk8s), vendor selection
  criteria for AI model generation (Meshy vs Tripo3D), performance tradeoffs,
  and infrastructure decisions for the Czech Republic-based operation.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags:
      - engineering
      - architecture
      - decisions
---

# Technical Decision Records

Use this skill when making, documenting, or revisiting a technology or vendor
decision at Figurio. New decisions should follow the format below. Existing
records here capture the settled choices and their reasoning.

## Decision Record Format

When logging a new decision, capture:

```
## [Decision title]
- **Status**: Accepted | Superseded | Under review
- **Date**: YYYY-MM-DD
- **Context**: What problem required a decision?
- **Decision**: What was chosen?
- **Rationale**: Why this over the alternatives?
- **Tradeoffs**: What are we accepting as a downside?
- **Review trigger**: Under what conditions should this be revisited?
```

---

## Settled Decisions

### Backend: FastAPI (Python, uv)
- **Status**: Accepted
- **Context**: Need a backend framework for catalog, order, and AI-pipeline services. Team has Python fluency.
- **Decision**: FastAPI with `uv` for dependency and virtualenv management.
- **Rationale**: Native async support suits the AI-pipeline service's non-blocking generation jobs. Automatic OpenAPI docs reduce frontend integration friction. `uv` is significantly faster than pip/poetry for CI cold starts.
- **Tradeoffs**: Python is not ideal for CPU-bound work — 3D file validation and processing should be offloaded to external services or CLI tools, not Python loops.
- **Review trigger**: If the AI-pipeline service needs heavy in-process 3D mesh manipulation.

### Frontend: React + TypeScript + shadcn-ui + Tailwind
- **Status**: Accepted
- **Context**: D2C storefront needs a component-rich UI for catalog browsing, AI prompt flow, and order tracking.
- **Decision**: React/TS with shadcn-ui components and Tailwind utility classes.
- **Rationale**: shadcn-ui provides accessible, unstyled primitives that Tailwind can theme without fighting a design system. TypeScript catches contract mismatches with the FastAPI OpenAPI types early.
- **Tradeoffs**: Tailwind verbosity in JSX. Mitigate with consistent component encapsulation — style in the component, not at the call site.
- **Review trigger**: If the AI prompt UX requires a canvas or WebGL layer (evaluate dedicated 3D viewer libraries at that point).

### Database: PostgreSQL (single cluster, multi-schema)
- **Status**: Accepted
- **Context**: Need persistent storage for catalog, orders, and AI job state.
- **Decision**: Single PostgreSQL cluster with separate schemas per service domain (`catalog`, `orders`, `ai_pipeline`).
- **Rationale**: Operational simplicity for a small team. Multi-schema gives logical isolation without the overhead of separate clusters. Cross-schema joins are possible for analytics but prohibited in application code.
- **Tradeoffs**: All services share failure domain. Acceptable at current scale; revisit if traffic warrants read replicas or separate clusters.
- **Review trigger**: p99 query latency exceeds 200ms under production load, or team size grows to the point where schema coordination becomes a bottleneck.

### Infrastructure: microk8s (local K8s) + Traefik + Docker + GitHub Actions
- **Status**: Accepted
- **Context**: Need container orchestration that a small Czech team can operate without managed K8s costs (EKS/GKE).
- **Decision**: microk8s on self-managed nodes with Traefik as ingress controller; Docker for local dev; GitHub Actions for CI/CD.
- **Rationale**: microk8s is lightweight and operationally close to upstream K8s, preserving future migration paths. Traefik integrates cleanly with K8s ingress annotations and handles TLS termination. GitHub Actions is sufficient for the current deployment cadence and avoids a separate CI system.
- **Tradeoffs**: Self-managed K8s means the team owns node health and upgrades. No autoscaling unless cluster-autoscaler is configured manually. Acceptable while traffic is predictable.
- **Review trigger**: Node management overhead exceeds ~2 hrs/week, or traffic becomes spiky enough to require dynamic scaling.

### Payments: Stripe (prepaid only)
- **Status**: Accepted
- **Context**: Figurio collects full payment before handing off to MCAE production. No COD or net-terms.
- **Decision**: Stripe Payment Intents for upfront charge; no custom payment logic.
- **Rationale**: Figurio is based in Czech Republic — Stripe supports CZK and EUR, handles SCA/3DS compliance for EU customers, and has a mature FastAPI integration ecosystem.
- **Tradeoffs**: Platform fee. Non-negotiable given compliance requirements.
- **Review trigger**: If Stripe's CZK settlement costs become materially worse than alternatives (e.g., Comgate for Czech-only volume).

### AI Model Generation Vendor: Meshy vs Tripo3D
- **Status**: Under review — evaluate on generation quality, latency, and CZK pricing
- **Context**: "Prompt to Print" feature requires text-to-3D or image-to-3D generation producing print-ready or near-print-ready models for Stratasys J55 PolyJet (full-color PolyJet, 0.014mm layers).
- **Decision**: Wrap the vendor behind `ai_pipeline` service's internal interface regardless of which is chosen. This makes switching cost low.
- **Evaluation criteria** (in priority order):
  1. Output mesh quality suitable for PolyJet printing (watertight, manifold STL/OBJ)
  2. Generation latency (target: model ready within 3 minutes for UX)
  3. API reliability and uptime SLA
  4. Per-generation cost at expected volume
  5. EU data residency or at minimum GDPR-compatible DPA available
- **Rationale for deferring final choice**: Neither vendor has been benchmarked against MCAE's PolyJet print requirements. Decision blocked on physical test prints.
- **Review trigger**: After test print batch from both vendors is evaluated by ops/production team.

### Production Partner: MCAE (Stratasys J55 PolyJet)
- **Status**: Accepted (outsourced, not built)
- **Context**: Figurio does not own printing hardware. Production is outsourced.
- **Decision**: MCAE as sole production partner using Stratasys J55 PolyJet for full-color figurines. Integration via order manifest + STL file handoff.
- **Rationale**: J55 PolyJet produces the full-color, high-detail output that is Figurio's product differentiator. MCAE is an established Stratasys partner in Czech Republic.
- **Tradeoffs**: Single vendor dependency for production. No fallback printer. Accept this risk at current scale; document escalation path if MCAE capacity is constrained.
- **Review trigger**: MCAE lead times exceed stated SLA, or Figurio volume warrants negotiating a second print partner.

## Principles for Future Decisions

- Prefer managed/vendor solutions for non-differentiating infrastructure (auth, payments, email, SMS)
- Wrap every external vendor integration behind an internal service interface — never call third-party APIs from business logic directly
- Optimize for small-team operability over theoretical scalability
- Decisions affecting the AI-pipeline or print-handoff flow require a physical print validation before going to production
