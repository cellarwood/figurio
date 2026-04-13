---
name: prd-template
description: "Write Figurio PRDs for catalog, custom approval, and fulfillment work with clear scope, launch gates, dependencies, and acceptance criteria."
---

# PRD Template

Use this skill when drafting or editing a PRD, decision note, launch brief, or implementation spec for Figurio.

## What A Good PRD Must Do

- Explain the customer problem and the business outcome in one paragraph.
- Make the launch sequence explicit: ready-to-print catalog first, then custom figurines only when the approval and supplier flows are ready.
- State what is in scope, what is out of scope, and what is blocked.
- Expose cross-functional dependencies on engineering, operations, support, suppliers, and finance.
- Turn edge cases into testable requirements, not footnotes.

## Figurio Context To Bake In

- Frontend is React/TypeScript.
- Backend is FastAPI.
- Checkout uses Stripe.
- Physical production is supplier-backed, including MCAE handoff assumptions.
- Core product flows include browse, buy, approve, produce, ship, and resolve exceptions.
- High-risk areas are stock constraints, personalization limits, approval delays, vendor handoffs, payment failures, refunds, and order visibility.

## Default PRD Structure

1. Title and owner
1. Summary
1. Problem statement
1. Goals and non-goals
1. User impact
1. Proposed solution
1. Requirements
1. User flows / state transitions
1. Dependencies
1. Risks and mitigations
1. Metrics and success criteria
1. Acceptance criteria
1. Rollout and launch gates
1. Open questions and decisions needed

## Writing Rules

- Write requirements as observable behavior.
- Use `must`, `should`, and `must not` intentionally.
- Put anything that changes order state, approval state, inventory state, or customer-visible promises in the requirements section.
- Include explicit owner names or teams for every dependency.
- Call out operational assumptions: supplier SLA, manual review time, reprint path, and support escalation path.
- If a feature touches trust, mention what the customer sees when something goes wrong.
- If a feature touches margin, mention the cost or margin mechanism, not just the revenue upside.

## Required Detail For Figurio Work

- For catalog work: item availability, variant rules, pricing, image/content requirements, and what happens when stock is low or missing.
- For custom figurine work: intake constraints, approval workflow, revision limits, SLA targets, and rejection handling.
- For fulfillment work: production trigger, supplier handoff payload, exception states, shipment confirmation, and customer notifications.
- For support work: internal tooling, order lookup, status explanations, refund or reprint decision paths, and escalation ownership.

## Acceptance Criteria Standard

- Each criterion should be testable by QA, engineering, or operations.
- Include happy path plus failure path when customer trust or money is involved.
- If acceptance depends on another team, state the dependency explicitly.
- Prefer concrete examples over vague statements like "works smoothly".

## Launch Gate Checklist

- Scope is frozen.
- Dependencies have owners and dates.
- Operational runbook exists for exception cases.
- Customer-facing copy matches actual system behavior.
- Success metrics and rollback conditions are defined.

## Output Style

- Keep the PRD concise enough to read in one sitting.
- Use short sections and bullets.
- Do not bury launch blockers in prose.
- End with the decision required, if any.
