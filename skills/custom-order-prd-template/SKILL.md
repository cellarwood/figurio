---
name: custom-order-prd-template
description: "Write launch-ready PRDs for Figurio custom figurine work with Czech prepaid commerce, MCAE handoff, and support-risk constraints."
model: gpt-5
model_reasoning_effort: high
sandbox_mode: danger-full-access
developer_instructions: |
  Use this skill when the work concerns AI custom figurines rather than generic e-commerce features.
  Produce compact PRDs that engineering, operations, and leadership can execute without translation.
  Always cover the Czech customer journey, 100% prepaid checkout implications, MCAE production handoff data, admin review steps, exception handling, and customer communication rules.
  Make order states, dependencies, metrics, and acceptance criteria explicit.
  Treat IP, likeness misuse, unsafe prompts, refund friction, and manual-review bottlenecks as first-class product risks.
---

# Custom Order PRD Template

Use this template for any Figurio feature that changes the AI custom figurine funnel, review workflow, payment path, or production handoff.

## Required Sections

1. Problem
   State the launch or operations issue in Figurio terms, such as custom submission drop-off, bad intake data, slow manual review, or unclear prepaid trust signals.
2. Goal
   Define the business outcome with one primary metric and one guardrail metric.
3. Scope
   Split into `In scope`, `Out of scope`, and `Launch cut if needed`.
4. User Flow
   Describe the Czech-first flow from entry point to payment, review, production, and support outcome.
5. Data Capture
   List every structured field needed from the customer and every field required for MCAE handoff.
6. States And Rules
   Specify order states, review decisions, time limits, and who can change each state.
7. Edge Cases
   Cover rejected prompts, likeness/IP risk, unmanufacturable requests, payment failures, refund requests, and delayed production feedback.
8. Acceptance Criteria
   Write testable frontend, backend, admin, analytics, and support requirements.
9. Risks
   Call out trust, margin, legal/IP, and manual-operations risks.

## Default Acceptance Areas

- Storefront copy is clear in Czech and does not imply guarantees the team cannot keep.
- Checkout preserves 100% prepaid clarity before the customer pays.
- Backend stores enough structured data for MCAE without free-text dependency.
- Admin review can approve, reject, request revision, or pause with an audit trail.
- Customer notifications match the true order state.
- Funnel analytics show submission, payment, review outcome, production handoff, and refund events.

## Output Standard

Keep the PRD short. If a section cannot drive a ticket or a decision, remove it or rewrite it.
