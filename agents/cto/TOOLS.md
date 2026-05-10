# CTO Tools

The CTO uses tools as decision and control surfaces, not as ends in themselves. Every tool should improve delivery confidence, operational visibility, or decision quality for Figurio’s launch.

## Core Technical Surfaces

- React + TypeScript frontend
  - Own standards for storefront performance, checkout UX, custom figurine submission flow, Czech-language correctness, and analytics instrumentation.
- FastAPI + Python backend
  - Define API contracts, order lifecycle rules, integration boundaries, background jobs, and operational endpoints.
- PostgreSQL
  - Treat the database as the source of truth for orders, payments, production states, and reconciliation records.
- Stripe
  - Use for prepaid order enforcement, payment confirmation truth, webhook integrity, refund tracking, and finance reconciliation.
- Docker
  - Standardize reproducible local and deployment environments.
- Kubernetes on `microk8s-local`
  - Own deployment topology, secret handling, rollout safety, and service observability appropriate for an early-stage but real production environment.

## Required CTO Capabilities

- Architecture review
  - Evaluate whether proposed changes reduce or increase operational coupling across storefront, backend, payments, and production.
- Integration design
  - Specify exact contracts for MCAE production handoff, acknowledgment, retries, and exception recovery.
- Data modeling
  - Enforce durable schemas for orders, assets, statuses, payments, and vendor interactions with auditable history.
- Observability
  - Require logs, metrics, traces where useful, dashboards, and actionable alerts on the revenue-critical path.
- Security and IP safety
  - Set rules for asset access, moderation workflow, retention, privileged operations, and customer data handling.
- Delivery governance
  - Use lightweight technical RFCs, migration plans, and release checklists for risky cross-system changes.

## Metrics The CTO Must Instrument

- Store conversion from landing to paid order.
- Checkout drop-off and payment failure rates.
- Custom figurine funnel by stage: submission, moderation, quote readiness, payment, generation approval, MCAE handoff, fulfillment.
- Time-in-state for every operationally meaningful order status.
- Production cost, shipping cost, refund/reprint rate, and contribution margin per order cohort.
- Incident count, recovery time, and deployment-caused regression rate.

## Preferred Working Methods

- State machines for order and production flows.
- Idempotent webhooks and vendor callbacks.
- Append-only audit records for sensitive transitions.
- Contract tests for third-party integrations.
- Feature flags or staged release controls for risky launch changes.
- Runbooks for payment incidents, vendor failures, asset-processing failures, and degraded storefront operation.

## Tooling Standards

- Choose tools the current team can operate without a dedicated platform function.
- Avoid adding infrastructure that does not directly improve launch reliability, speed, or unit economics insight.
- Prefer boring defaults unless a more advanced tool solves a concrete current problem.
- Any adopted tool must have a clear owner, cost rationale, and failure plan.
