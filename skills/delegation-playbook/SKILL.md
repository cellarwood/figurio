---
name: delegation-playbook
description: >
  Rules for Figurio's CEO agent when delegating tasks to CTO, CMO, COO, and
  Product Manager. Covers when to delegate vs. handle personally, how to frame
  assignments, escalation criteria, and follow-up cadence across the 9-agent
  e-commerce team.
metadata:
  paperclip:
    tags:
      - leadership
      - delegation
      - operations
---

# Delegation Playbook

## When to Use

Use this skill any time the CEO needs to assign work, respond to an escalation,
or decide whether to handle something directly or route it to a functional lead.

## Delegation Targets

Figurio has four primary delegation targets for the CEO:

| Agent | Domain | Owns |
|-------|--------|------|
| **CTO** | Engineering | Backend, frontend, DevOps, AI pipeline, infra |
| **CMO** | Marketing | Brand, campaigns, content, acquisition, social |
| **COO** | Operations | Fulfillment, suppliers, SLAs, cost tracking |
| **Product Manager** | Product | Feature roadmap, sprint planning, backlog |

Each of these agents can further delegate to their sub-agents (e.g., CTO →
Backend Engineer or DevOps Engineer).

## Delegate vs. Handle Personally

### Delegate when:
- The work falls squarely within one functional domain (engineering, marketing,
  operations, or product).
- The decision does not set company strategy or affect more than one domain.
- The task is repeatable or process-driven (reporting, content scheduling,
  infra provisioning, supplier follow-up).
- The CEO's involvement would create a bottleneck without adding unique value.

### Handle personally when:
- The decision crosses two or more domains and requires trade-offs only the CEO
  can make (e.g., delay launch to fix fulfillment vs. launch with manual
  workaround).
- The task involves external parties at a company-representation level
  (investor updates, key partner negotiations).
- A goal-level reprioritization is needed (see `strategy-review` skill).
- Two agents are in conflict over resources or priorities.

## How to Frame a Delegation

Every delegated task must include:

1. **What** — clear description of the output or action required.
2. **Why** — which of the 5 company goals it serves (be explicit).
3. **By when** — deadline or expected check-in point.
4. **Success criteria** — how you'll know it's done correctly.
5. **Constraints** — budget limits, technical constraints, dependencies to be
   aware of.

Example delegation to CMO:
> "Run a paid social test targeting custom figurine gift buyers on Instagram.
> Goal: acquire first 50 customers toward the 500-customer target. Budget: $500.
> By end of week. Success: at least 10 conversions at CAC ≤ $50. Constraint:
> use only approved brand assets from the `/brand` drive folder."

## Escalation Criteria

An agent should escalate to the CEO (and the CEO should expect it) when:

| Trigger | Example |
|---------|---------|
| Blocker that will slip a goal milestone | Stripe integration broken 3 days before launch |
| Decision requires budget above agent's authority | CMO wants to double ad spend beyond approved ceiling |
| Cross-agent dependency is unresolved | PM needs backend API that CTO says is 2 weeks out |
| External risk with company-wide impact | Supplier can't fulfill orders for 2 weeks |
| Two agents disagree on priority | CTO and PM disagree on whether to fix tech debt or ship feature |

When an escalation arrives, the CEO must respond with a decision — not a
question back to the agent — within the same working cycle.

## Follow-up Cadence

| Delegation type | Check-in frequency |
|-----------------|-------------------|
| Strategic initiative (multi-week) | Weekly, at strategy review |
| Sprint-level task | Mid-sprint and end of sprint |
| Urgent / time-boxed task (< 3 days) | At deadline only, unless blocker raised |
| Recurring process (reports, campaigns) | Review output; follow up only if quality issue |

Do not micromanage agents between check-ins. If an agent has not raised a
blocker, assume work is proceeding. Intervene only when a deadline is missed or
a risk is surfaced.

## Anti-patterns

- Delegating without success criteria — agents will deliver something, but it
  may not be what was needed.
- Delegating cross-domain decisions — "figure it out between yourselves" without
  CEO resolution leads to deadlock.
- Skipping the "why" — agents make better decisions when they understand which
  company goal the task serves.
- Re-delegating an escalation back to the agent who escalated it — if they
  escalated, they need a CEO decision, not a referral.
- Over-following-up on routine tasks — it signals distrust and consumes agent
  cycles that should go toward execution.
