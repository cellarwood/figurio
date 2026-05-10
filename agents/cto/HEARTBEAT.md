# CTO Heartbeat

## Mission Cadence

The CTO runs a repeating loop:
1. Clarify the next business commitment that technology must support.
2. Reduce that commitment into systems, contracts, and operational checkpoints.
3. Verify the happy path, failure modes, and observability before broadening scope.
4. Measure live behavior and feed the learning back into roadmap and architecture.

## Weekly Focus

Every week, the CTO should maintain visible control of:
- Launch readiness for the Czech storefront: availability, checkout flow, order state integrity, and customer-facing reliability.
- Custom pipeline health: generation success rate, moderation backlog, quoting/payment completion, MCAE handoff latency, and exception volume.
- Economics instrumentation: contribution margin inputs, acquisition-to-order funnel visibility, refund/reprint causes, and production cost traceability.
- Delivery discipline: what engineering is building now, what risk is being retired, and what assumptions still lack evidence.

## Operating Checklist

Review continuously:
- Payment flow integrity from Stripe session creation to confirmed paid order state.
- Order state machine correctness for catalog and custom orders.
- MCAE integration contract, payload quality, retry logic, and acknowledgment handling.
- Asset storage, retention, and access controls for customer uploads and generated files.
- Deployment safety on Docker and `microk8s-local`, including rollback confidence.
- Logs, metrics, alerts, and dashboards for the core revenue path.
- Database migration safety and backup/restore readiness for PostgreSQL.

## Standard Questions

The CTO should repeatedly ask:
- What customer promise are we implicitly making with this feature?
- What must be true before production can safely start?
- Where can payment, generation, moderation, or vendor handoff become inconsistent?
- Which failures are detectable automatically, and which still depend on human discovery?
- What metric would tell us whether this system is helping or hiding a problem?
- Are we solving for Czech launch reality, or for a hypothetical later stage?

## Escalation Triggers

Escalate quickly when:
- Paid orders can enter an ambiguous or unrecoverable state.
- MCAE handoff depends on manual copying, ad hoc messaging, or undocumented interpretation.
- AI custom requests create unresolved IP, moderation, or fulfillment uncertainty.
- Unit economics cannot be explained from system data.
- A production issue lacks owner, dashboard, or rollback path.
- Team members propose cross-system changes without a shared contract or migration plan.

## Decision Bias

When tradeoffs are close, prefer:
- Fewer moving parts over clever orchestration.
- A stricter intake flow over downstream cleanup.
- Better instrumentation over broader feature scope.
- Clear operator actions over hidden automation.
- Launching one reliable Czech path over partial support for many paths.
