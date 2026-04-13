---
name: api-design
description: REST and HTTP API conventions for Figurio's catalog, checkout, Stripe, order, and custom-generation backend endpoints.
---

# Figurio API Design

Use this skill when adding or changing backend HTTP APIs for Figurio's catalog products, checkout, orders, custom generation jobs, preview approval, Stripe webhooks, refunds, or operator-facing endpoints.

## Defaults

- Prefer resource-oriented REST over ad hoc RPC.
- Preserve existing request and response shapes unless a breaking change is explicitly approved.
- Model workflow changes as explicit state transitions, not hidden side effects.
- Keep client-triggered APIs separate from webhook-driven or background-job-driven APIs.
- Return the canonical persisted resource after every successful write.

## Resource Rules

- Use plural nouns for collections and stable IDs for resources.
- Keep one primary aggregate per endpoint group: `products`, `orders`, `generation-jobs`, `previews`, `payments`.
- Use subresources for workflow artifacts that belong to a single aggregate, such as `orders/{id}/preview` or `orders/{id}/events`.
- Expose workflow actions only when a pure CRUD shape would hide an important business transition.
- Do not expose internal database joins, vendor payloads, or queue details directly to clients.

## Request And Response Shape

- Match the repo's existing JSON casing and naming; do not mix styles in one API.
- Include stable identifiers, status fields, and timestamps on every persisted resource that clients need to reason about.
- Make write endpoints return the updated resource or a small envelope that includes it.
- Keep list responses explicit about pagination, sorting, and filters.
- Accept only documented query params; reject silent, ambiguous filtering behavior.

## Validation Rules

- Validate ownership, payment state, and order state before applying a mutation.
- Fail fast on invalid transitions instead of silently normalizing them.
- Distinguish user-facing validation errors from internal consistency errors.
- Treat duplicate submissions as a normal case when retries, refreshes, or webhook replays can happen.
- Require idempotency keys for writes that can create charges, orders, jobs, or state transitions more than once.

## Error Handling

- Use standard HTTP semantics: `400/422` for invalid input, `401/403` for access problems, `404` for missing resources, `409` for state conflicts, `5xx` for server failures.
- Use `409 Conflict` for stale updates, duplicate Stripe events, and disallowed state transitions.
- Keep error payloads short, actionable, and safe to expose.
- Never leak raw stack traces, vendor payload dumps, or secrets in API errors.

## Stripe And Webhooks

- Treat Stripe webhooks as the source of truth for payment lifecycle changes.
- Verify webhook signatures before processing.
- Persist the external event ID before or as part of processing so replays stay idempotent.
- Reconcile amounts, currency, and order identity before marking payment complete.
- Never assume a client redirect, success page, or frontend callback means payment succeeded.

## Figurio-Specific Patterns

- Catalog APIs should expose product availability, size tiers, and purchase constraints without revealing fulfillment internals.
- Checkout APIs should create or confirm orders, not finalize production directly.
- Custom workflow APIs should separate prompt intake, generation status, preview delivery, approval, revision requests, and production release.
- Operator-facing endpoints may be more explicit than customer-facing ones, but they still need stable contracts and predictable state.
- If a workflow needs a new state or endpoint, prefer a deliberate addition over overloading an existing meaning.

## Testing Expectations

- Add contract tests for every API shape that changes.
- Test validation failures, idempotency behavior, forbidden transitions, and pagination edge cases.
- For Stripe-facing APIs, test signature verification, duplicate delivery, and event-order anomalies.
- For stateful endpoints, assert the exact fields returned before and after each write.
- Prefer focused API and service tests over broad end-to-end tests unless the change crosses multiple systems.

## Review Checklist

- Does the endpoint name describe a resource or workflow step clearly?
- Is the mutation idempotent if the user retries it?
- Does the response reveal enough state for the next client action?
- Are payment, approval, and fulfillment boundaries preserved?
- Would a replayed webhook, stale tab, or concurrent operator action stay safe?
