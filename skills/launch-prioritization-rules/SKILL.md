---
name: launch-prioritization-rules
description: "Prioritize Figurio launch work against Czech conversion, prepaid trust, MCAE operational reliability, and early unit-economics learning."
model: gpt-5
model_reasoning_effort: medium
sandbox_mode: danger-full-access
developer_instructions: |
  Use this skill when ranking launch backlog items, evaluating scope cuts, or resolving tradeoffs across product, engineering, operations, and marketing.
  Judge work by launch viability, not feature completeness.
  Favor changes that improve prepaid conversion confidence, production handoff reliability, support scalability, and legal/IP safety.
  Deprioritize work that adds visual polish or speculative AI novelty without measurable business value.
  Force an explicit decision of now, later, or no, with a short reason tied to Czech launch constraints.
---

# Launch Prioritization Rules

Apply these rules in order. If a lower rule conflicts with a higher rule, the higher rule wins.

## Priority Order

1. Revenue can be collected reliably.
   Payment, checkout clarity, Stripe webhooks, and order confirmation come before discovery or delight work.
2. MCAE can fulfill without expensive rework.
   Intake quality, admin review, manufacturability checks, and handoff structure beat feature breadth.
3. Czech customers understand what they are buying.
   Clear Czech copy, delivery expectations, pricing, and refund language beat marketing experiments.
4. Support load stays bounded.
   Anything that prevents ambiguous orders, status confusion, or manual chasing outranks cosmetic improvements.
5. IP and safety risk stay controlled.
   Catalog vetting and custom-request guardrails are mandatory, not nice-to-have.
6. The team can learn fast after launch.
   Instrumentation and reporting outrank optimizations that cannot be measured.

## Scoring Questions

- Does this reduce checkout abandonment or payment failure?
- Does this improve custom-order acceptance quality before MCAE sees it?
- Does this remove a manual step that would fail under real order volume?
- Does this reduce refund, complaint, or trust risk for Czech prepaid buyers?
- Does this create data the team needs for post-launch decisions?

## Default Decisions

- `Now`: payment integrity, custom intake quality, production handoff, state visibility, analytics, policy clarity.
- `Later`: advanced personalization, non-Czech expansion, complex merchandising tools, speculative AI upsells.
- `No`: anything that depends on hidden manual heroics, weak IP assumptions, or untestable AI promises.

## Output Format

For each item, return `Decision`, `Why now/later/no`, `Dependency`, and `Risk if deferred` in 1 to 3 lines.
