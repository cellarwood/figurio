---
name: architecture-review
description: Review Figurio architecture for commerce flows, custom generation, order state design, admin tooling, Stripe and vendor integrations, deployment readiness, and launch risk.
---

# Architecture Review

Use this skill when evaluating Figurio system design, proposed changes, or production risk.

## Default Approach

1. Inspect the real repository state before judging.
2. Trace the full user and operator flow end to end.
3. Prefer concrete failure modes over abstract style comments.
4. Separate launch blockers from later hardening items.
5. Recommend the simplest design that is safe enough for the phase.

## What To Review

Focus on these areas whenever they are relevant:

- Storefront purchase flow: product discovery, customization, cart, checkout, payment, confirmation.
- Stripe flow: intent creation, webhook handling, idempotency, retries, refunds, dispute handling, reconciliation.
- Order lifecycle: creation, payment pending, paid, queued, generating, review, ready for fulfillment, handed off, shipped, completed, canceled, refunded, failed.
- Custom figurine pipeline: prompt or intake validation, asset generation, human review, preview artifacts, production handoff, exception recovery.
- Admin tooling: order lookup, manual state changes, refund controls, resubmission, vendor reruns, audit history.
- Integrations: outsourced fulfillment partner, 3D-print tooling, shipping, email, logging, analytics, and any external APIs.
- Runtime: Docker, Kubernetes, Terraform, secrets, rollout strategy, observability, alerts, and rollback paths.

## Review Checklist

For each significant change, answer these questions:

- Does the flow have a single source of truth for order state?
- Are state transitions explicit, validated, and auditable?
- Are retries and webhook replays safe?
- Can operators recover from partial failures without editing the database by hand?
- Are custom-generation and fulfillment steps isolated from customer-facing latency?
- Is any irreversible action protected by a clear confirmation or idempotency key?
- Can the system survive partner downtime, delayed jobs, duplicate messages, and stale UI state?
- Are admin actions logged with actor, timestamp, reason, and before/after values?
- Does the design preserve a clear customer promise for delivery time and status updates?
- Is the launch path safe if one dependency is slow, missing, or returns malformed data?

## Decision Rules

- Prefer explicit state machines over ad hoc status strings.
- Prefer durable job orchestration over synchronous chains for vendor and generation steps.
- Prefer append-only audit trails for financial and operational state changes.
- Prefer narrow, typed interfaces between frontend, backend, and external services.
- Prefer operator-safe tools over hidden background behavior.
- Treat vendor APIs, model outputs, and fulfillment updates as untrusted inputs.

## Common Red Flags

- Checkout and fulfillment sharing a brittle code path.
- Order states that can move backward without a deliberate recovery action.
- Webhooks that can create duplicate orders or double-charge customers.
- Custom generation that blocks checkout or payment confirmation.
- Admin tools that allow silent edits without audit history.
- Manual fulfillment steps with no retry or visibility path.
- Production readiness depending on perfect vendor uptime.
- A design that works in tests but cannot be operated during an incident.

## Launch Gates

Call out a launch blocker when any of these are true:

- Payment success or refund correctness is uncertain.
- Order state can become inconsistent across systems.
- A vendor failure can strand an order without operator recovery.
- Customer-visible status can drift from actual fulfillment state.
- Missing observability would make incident triage guesswork.
- Secrets, environment config, or deployment state cannot be reproduced safely.

## Output Format

When you review architecture, write the result in this order:

1. Recommendation: approve, approve with conditions, or block.
2. Key risks: the top 3 to 5 issues, ranked by customer, revenue, or operational impact.
3. Evidence: specific files, code paths, data models, or API boundaries.
4. Required changes: what must change before launch or merge.
5. Residual risk: what remains acceptable after the fixes.

## Review Style

- Be direct about tradeoffs.
- Distinguish “can ship” from “should harden later.”
- If a proposal adds complexity, require a concrete operational payoff.
- If the architecture depends on human intervention, specify exactly who does what and when.
- If a choice affects launch timing, say so plainly.

