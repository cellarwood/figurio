---
name: bug-report-format
description: Write Figurio bug reports that capture checkout, payment, order-state, preview approval, fulfillment, and operator-impacting defects with enough detail to act immediately.
---

# Bug Report Format

Use this skill when filing or refining a bug report so Figurio engineers, QA, support, and operations can triage it quickly.

## Goal

A good bug report should make three things obvious:

- What is broken.
- How to reproduce it reliably.
- Why it matters to revenue, customer trust, or operations.

## Required Structure

Use this order unless the issue is so small that a shorter note is clearly enough:

1. Title
2. Severity
3. Summary
4. Environment
5. Preconditions
6. Steps to reproduce
7. Expected result
8. Actual result
9. Impact
10. Evidence
11. Suspected area
12. Workaround
13. Open questions

## Title Rules

- Start with the broken behavior, not the symptom.
- Mention the affected flow when useful, such as checkout, order state, preview approval, or fulfillment.
- Keep it short and specific.

Examples:

- Checkout succeeds but order is not created
- Approved preview can be regenerated without re-approval
- Admin refund updates UI but not canonical order state

## Severity Guidance

Use severity based on business risk, not annoyance:

- Critical: blocks checkout, payment correctness, approval gating, or fulfillment release.
- High: corrupts order state, hides a real failure, or requires manual recovery for many orders.
- Medium: breaks a major workflow without immediate money or fulfillment loss.
- Low: cosmetic, wording, or isolated workflow polish.

## Summary Rules

The summary should answer the question “what is wrong in one sentence?” without diagnosis drift.

- State the observed failure.
- Mention the affected user or operator journey.
- Avoid speculation in the summary.

## Environment

Include the minimum context needed to reproduce:

- App surface or role.
- Build, branch, or deployment identifier if known.
- Browser or device if relevant.
- Environment such as local, staging, or production.
- Time of occurrence if timing matters.

## Preconditions

List only the setup that is required to reproduce:

- Specific product, order, or preview state.
- Existing payment, approval, or admin status.
- Feature flag or test account requirements.
- Any seeded data or job condition.

## Steps To Reproduce

Write steps that another person can follow exactly:

- Use numbered steps in order.
- Keep each step atomic.
- Include the input values, IDs, or selections that matter.
- Avoid “do the normal thing” or any step that relies on guesswork.
- If the issue is timing-sensitive, say what to wait for and for how long.

## Expected vs Actual

Make the mismatch direct and concrete:

- Expected result: what the system should do according to Figurio behavior and business rules.
- Actual result: what happened instead, including state labels, UI text, or backend mismatch if known.

If the issue affects a state transition, name both the starting state and the wrong ending state.

## Impact

Explain the consequence in business terms:

- Lost checkout conversion.
- Incorrect charge or refund risk.
- Wrong order-state visibility.
- Preview approval bypass or invalidation.
- Fulfillment delay or operator intervention.
- Customer confusion or support load.

## Evidence

Attach or reference the strongest proof available:

- Screenshot or screen recording.
- Console error, server log, or API response.
- Order ID, payment intent ID, preview ID, job ID, or admin record.
- Timestamp and user or actor when relevant.
- Link to the exact page or request if the issue depends on a specific call.

## Suspected Area

Include a best guess only if it helps triage:

- Checkout frontend.
- Stripe webhook or payment orchestration.
- Order-state transition logic.
- Preview generation or approval workflow.
- Fulfillment handoff.
- Admin tooling or operator workflow.

Do not turn this into a long root-cause theory unless you have evidence.

## Workaround

State whether there is a safe workaround:

- No workaround.
- Temporary workaround with risk.
- Operator-only workaround.
- Customer-visible workaround.

If the workaround changes money, approval, or fulfillment behavior, say so plainly.

## Open Questions

Use this section to capture what still needs confirmation:

- Does the issue reproduce in another environment?
- Is the backend state also wrong, or only the UI?
- Does it happen only on retry, refresh, or duplicate event delivery?
- Is the problem isolated to one order or systematic?

## Quality Bar

A good Figurio bug report lets someone act without a follow-up meeting.

- One issue per report.
- No mixed symptoms unless they are clearly the same root cause.
- No vague severity.
- No missing reproduction path for a reproducible issue.
- No guesswork about customer impact when order state or payment is involved.

## Fast Triage Rule

If the bug touches any of these, flag it immediately:

- Checkout or payment correctness.
- Canonical order state.
- Approval or release gating.
- Customer-facing status that can drift from actual fulfillment.
- Manual admin actions that can create irreversible side effects.

