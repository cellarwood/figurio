---
name: feature-prioritization
description: "Prioritize Figurio features using launch risk, margin impact, customer trust, dependency criticality, and readiness."
---

# Feature Prioritization

Use this skill when ranking features, sequencing launch work, choosing between competing requests, or deciding what must ship before Figurio expands beyond the ready-to-print catalog.

## Decision Frame

Favor work that:

- Reduces launch risk.
- Protects margin.
- Improves customer trust.
- Unblocks cross-functional delivery.
- Clarifies ownership or system behavior.

Deprioritize work that is:

- Nice to have but not launch-critical.
- High effort with unclear operational impact.
- Dependent on unresolved supplier, ops, or support decisions.
- Premature customization before catalog reliability is proven.

## Scoring Dimensions

Score each candidate from `1` to `5` on these dimensions:

- Launch risk reduction
- Margin impact
- Customer trust impact
- Dependency criticality
- Time sensitivity
- Effort / complexity

Use the scores as a decision aid, not a fake precision machine. If a feature blocks launch or customer fulfillment, it outranks most growth work regardless of score.

## Figurio-Specific Weights

Default weighting:

- Launch risk reduction: highest weight
- Customer trust impact: high weight
- Dependency criticality: high weight
- Margin impact: medium-high weight
- Time sensitivity: medium weight
- Effort / complexity: penalty, not a reason to ignore value

Adjust weights only when the company objective changes. For pre-launch work, risk and dependencies dominate. For post-launch growth, margin can move up if trust is not weakened.

## Hard Rules

- Anything that affects checkout, approval, fulfillment, refunding, or order visibility is priority work if it is currently brittle or undefined.
- Anything that increases margin but reduces trust needs an explicit mitigation.
- Anything with an unknown owner, unclear SLA, or missing supplier dependency is not ready for top priority unless that uncertainty is the work itself.
- Do not let custom figurine scope outrank catalog launch readiness unless the catalog path is already stable.
- Do not rank based on stakeholder urgency alone.

## Prioritization Process

1. State the decision being made.
1. List candidate features with a one-line description each.
1. Capture the company objective they support.
1. Score each candidate on the dimensions above.
1. Identify dependencies, blockers, and launch risks.
1. Apply the hard rules.
1. Rank the items.
1. Note what gets cut or delayed and why.

## Output Format

For each item, include:

- Priority rank
- Short rationale
- Main benefit
- Main risk
- Dependencies
- Decision needed, if any

## Tie Breakers

When scores are close, prefer the feature that:

- Reduces operational ambiguity.
- Protects the customer experience during failure.
- Removes a dependency for another team.
- Improves the economics of an order.
- Can be validated quickly with low rollback risk.

## Escalation Triggers

Escalate to leadership when:

- Two high-value items compete for the same critical dependency.
- A feature changes customer promises, pricing, refund exposure, or supplier commitments.
- The team is optimizing for growth before trust or fulfillment reliability is proven.

