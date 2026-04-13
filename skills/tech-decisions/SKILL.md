---
name: tech-decisions
description: Make Figurio technical decisions for commerce, custom generation, order states, admin workflows, integrations, infra, and launch risk with explicit tradeoffs and implementation guidance.
---

# Technical Decisions

Use this skill when choosing between design options, defining a standard, or recording a decision that others will implement.

## Decision Standard

A good Figurio technical decision must be:

- Safe for commerce and fulfillment.
- Clear enough for engineering to implement without guessing.
- Robust against external failures and duplicate events.
- Easy for operators to understand and recover.
- Small enough to launch on time.

## Start With The Real Constraint

Before choosing, identify which constraint matters most:

- Revenue correctness.
- Customer trust.
- Production throughput.
- Operator workload.
- Launch speed.
- Maintenance burden.
- Vendor lock-in.

Then optimize for that constraint first. Do not hide the tradeoff.

## Figurio Decision Domains

Use these domain rules when the decision touches one of the core systems:

- Commerce flow: keep cart, checkout, payment, and confirmation simple and linear.
- Stripe: make payment intent and webhook handling idempotent; never rely on one webhook arriving once.
- Orders: maintain one canonical order state model across frontend, backend, admin, and fulfillment.
- Custom generation: isolate slow, failure-prone, or human-reviewed steps behind durable jobs.
- Admin tooling: make manual correction possible, logged, and reversible when feasible.
- Integrations: assume the fulfillment partner, shipping, and creative tooling will be late, partial, or inconsistent.
- Infra: prefer repeatable deployment and rollback over clever runtime behavior.

## Required Decision Questions

Answer these before finalizing a decision:

- What problem is being solved, and what is out of scope?
- What is the simplest safe option?
- What failure modes does each option introduce?
- How will the system recover from partial completion?
- What is the operator fallback when automation fails?
- What changes in the frontend, backend, database, jobs, and integrations?
- What must be true before launch, and what can wait?

## Preferred Patterns

- Use explicit state machines for order and fulfillment progress.
- Use durable queues or jobs for generation, vendor handoff, and retryable work.
- Use idempotency keys for customer-initiated payments and backend side effects.
- Use audit logs for manual admin edits, refunds, reruns, and override actions.
- Use typed contracts between services instead of implicit JSON shapes.
- Use feature flags or staged rollout when a change affects checkout, payment, or production handoff.

## When To Choose Simplicity

Prefer the simpler option when:

- The feature is needed for launch but not yet differentiated by complexity.
- The user-facing benefit does not depend on a more abstract architecture.
- The operational benefit of the complex option is unproven.
- The failure cost of the complex option is higher than the performance gain.

Do not add workflows, services, or state when a single table, queue, or API boundary is enough.

## When To Slow Down

Require a stronger justification before approving complexity in these cases:

- Anything that can double-charge, mis-ship, or lose an order.
- Anything that changes money movement, refunds, or tax-relevant records.
- Anything that affects production handoff to the fulfillment partner.
- Anything that changes the canonical meaning of an order status.
- Anything that makes support and admin recovery harder.

## Decision Writeup Template

Record the decision in this shape:

1. Decision: what we are choosing.
2. Context: the constraint or problem.
3. Options: the viable alternatives.
4. Tradeoffs: why the selected option wins now.
5. Risks: what can still go wrong.
6. Mitigations: how we reduce those risks.
7. Follow-ups: what to revisit after launch.

## Launch-Risk Lens

For each decision, state whether it:

- Blocks checkout.
- Changes payment correctness.
- Alters order state transitions.
- Depends on vendor uptime.
- Requires new operator training.
- Adds on-call or support burden.

If any answer is yes, document the recovery path and owner explicitly.

## Output Style

- Be concrete, not generic.
- Name the exact subsystem affected.
- Prefer numbers, thresholds, and state names over vague language.
- Make the recommendation actionable for the engineer who has to implement it.
- If the right answer is “not yet,” say what would need to change to revisit it.

