---
name: order-lifecycle-patterns
description: Figurio order state machine patterns for catalog orders, custom figurine workflows, approval gates, generation jobs, payment completion, and production release.
---

# Figurio Order Lifecycle Patterns

Use this skill when changing order state machines, approval rules, generation-job handling, payment gates, production release logic, or status surfaces for Figurio's catalog and custom figurine flows.

## Core Rule

An order is a controlled workflow, not a bag of flags. Represent the lifecycle as explicit states with validated transitions, durable history, and clear release gates.

## Lifecycle Principles

- Treat order state as the backend source of truth.
- Separate payment, generation, approval, and fulfillment concerns.
- Make every transition explicit, testable, and audit-friendly.
- Preserve previous states in history so support and operations can reconstruct what happened.
- Never let a frontend-only action bypass approval, payment, or webhook confirmation.

## Canonical Workflow Boundaries

- Catalog orders: product selection -> payment confirmation -> production handoff -> fulfillment.
- Custom figurine orders: prompt intake -> deposit or payment confirmation -> generation -> preview -> approval or revision -> balance collection if applicable -> production release -> fulfillment.
- If the implementation uses different names, keep these boundaries intact.
- Do not collapse approval and release into one state unless the business truly cannot distinguish them.

## State Design

- Use a finite enum or equivalent explicit state model.
- Prefer one active state plus optional derived flags over many overlapping booleans.
- Keep terminal states obvious: `fulfilled`, `cancelled`, `refunded`, `failed`, or equivalent.
- Add a new state only when an existing one cannot safely express the lifecycle.
- Document every allowed transition in code or tests, not just in prose.

## Transition Rules

- Only the backend should advance workflow states.
- Every transition should validate the current state before writing the next one.
- Backward transitions should be rare and deliberate.
- Cancellation, refund, and failure paths must be first-class, not afterthoughts.
- Revision requests should preserve prior approval history and preview artifacts.

## Figurio-Specific Gates

- Do not release custom production work until the required approval step has completed.
- Do not mark payment complete based on a client redirect or local UI event.
- If custom orders use staged payments, keep deposit completion and balance completion separate.
- Generation retries should not duplicate orders or erase prior job attempts.
- A preview update should not silently invalidate approval without an explicit new review step.

## Idempotency And Replays

- Expect duplicate webhook deliveries, retried jobs, and repeated operator actions.
- Use idempotency keys or event IDs for state-changing operations that can be replayed.
- Make repeated processing a no-op when the workflow already reached the target state.
- Record enough metadata to explain why a state changed: actor, source, timestamp, and related event or job ID.

## Observability

- Log every meaningful state transition with old state, new state, order ID, and causation.
- Emit clear job and webhook failure signals for stuck generation, missing preview, or payment mismatch cases.
- Make it easy for support or operations to answer: what happened, when, and what is the next safe action.

## Testing Expectations

- Test every allowed transition and every disallowed transition.
- Cover duplicate Stripe events, repeated job execution, and concurrent approval attempts.
- Assert that production release cannot happen before the required payment and approval gates.
- Verify terminal states stay terminal.
- If a transition affects customer-visible status text, test that mapping too.

## Review Checklist

- Is the workflow represented as a real state machine?
- Are payment, preview, approval, and production gates enforced independently?
- Can retries or webhook replays create duplicates or skip a gate?
- Does support have enough state history to explain the order's current status?
- Would this change still be safe if the same event arrived twice?
