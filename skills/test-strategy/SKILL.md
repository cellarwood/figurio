---
name: test-strategy
description: Plan and execute Figurio test strategy for checkout, Stripe payment, order-state transitions, preview approval, fulfillment handoff, and operator workflows.
---

# Test Strategy

Use this skill when deciding what to test, how deep to go, and what level of confidence is enough for a Figurio change.

## Objective

Protect release confidence for the flows that can lose revenue, confuse customers, or strand operations:

- Checkout completion and payment correctness.
- Canonical order-state transitions.
- Custom figurine preview and approval flows.
- Fulfillment handoff and operator visibility.
- Customer promise vs actual production or shipping capability.

## Default Strategy

1. Start with the highest-risk user journey, not the smallest code diff.
2. Test the shortest path that proves the behavior.
3. Verify the backend source of truth when status, money, or approval is involved.
4. Add one adjacent failure case and one recovery path when time allows.
5. Stop when the remaining risk is understood and acceptable, not when every permutation is covered.

## Figurio Risk Priorities

Test these first whenever a change touches them:

- Checkout initiation, payment intent creation, payment confirmation, and order creation.
- Duplicate Stripe events, retries, or delayed webhook delivery.
- Order states that move across frontend, API, admin, fulfillment, or job workers.
- Preview generation, preview replacement, approval, revision requests, and release gating.
- Manual operator actions such as refund, resend, rerun, override, or status correction.
- Shipping, handoff, and customer-facing status updates that can drift from reality.

## What To Verify

For every significant change, answer these questions:

- What is the canonical source of truth for the user-visible outcome?
- Can the same event be processed twice without duplicate orders or duplicate side effects?
- Does the state machine allow only valid transitions?
- Can support or operations recover without editing the database by hand?
- Does the UI match the backend state after refresh, retry, or delayed async work?
- Does the customer promise still match what fulfillment can actually do?

## Test Layers

Use the lightest layer that proves the risk, then expand only if needed:

- Unit tests for pure validation, state transition rules, and idempotency logic.
- Integration tests for checkout, webhooks, jobs, approvals, and persistence.
- End-to-end tests for customer-facing journeys and approval gates.
- Manual checks only for workflow edges that are not yet automated, and capture them as follow-up coverage.

## Must-Cover Scenarios

- Successful checkout from first click to confirmed order.
- Payment success followed by delayed or repeated webhook delivery.
- Payment failure, retry, and user recovery.
- Approved preview leading to production release.
- Revision request preserving prior preview and approval history.
- Preview regeneration after approval and the resulting state update.
- Order cancellation, refund, and terminal-state behavior.
- Admin correction, rerun, or manual handoff with auditability.
- Stuck or delayed job handling with a clear operator next step.

## Release Gate Rules

- Block release if checkout is broken, payment state is uncertain, or order-state transitions can become inconsistent.
- Block release if a customer can reach production release without the required approval or payment gate.
- Block release if support cannot explain a failed order from the available logs, state history, and UI.
- Block release if a change can create duplicate orders, double-charges, or orphaned fulfillment work.
- Allow minor UI polish to ship only when it cannot hide or misrepresent operational state.

## Evidence Standard

Keep evidence tied to the risk being tested:

- Record the exact steps used.
- Capture the order ID, preview ID, job ID, or payment reference when relevant.
- Note expected state, actual state, and where the mismatch appears.
- Include screenshots, logs, or API responses when the result is not obvious from the UI.
- Distinguish a real pass from a pass that depends on stale cache or a lucky timing window.

## Common Failure Patterns

- Frontend state advances before backend confirmation.
- Webhook replay creates duplicate work or backtracks an order.
- Preview approval is lost or invalidated without an explicit user action.
- Fulfillment sees a state that the customer UI does not show.
- A manual operator action works once but is not safe to repeat.
- Retry logic masks a real failure until the order is already stranded.

## Timebox Guidance

If time is limited, spend it in this order:

1. Payment and order creation correctness.
2. State transition integrity.
3. Preview approval and release gating.
4. Fulfillment handoff and operator recovery.
5. Cosmetic or low-impact regressions.

## Output Format

When you write up a test strategy or results, keep it compact and specific:

- Scope
- Highest-risk flows
- Tests run
- Gaps remaining
- Release recommendation

## Review Checklist

- Did I test the real customer journey first?
- Did I verify the backend state, not just the UI?
- Did I cover one failure and one recovery path?
- Did I check duplicate events, retries, or async lag where relevant?
- Did I confirm the approval and fulfillment gates still hold?
- Did I leave the team with a clear release answer?
