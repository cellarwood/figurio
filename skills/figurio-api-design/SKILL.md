---
name: figurio-api-design
description: Design FastAPI endpoints for Figurio's Czech-first prepaid figurine commerce flows.
---

# Figurio API Design

Design backend contracts for a real prepaid commerce operation, not a generic CRUD app.

## Use This Skill For

- Catalog order endpoints for checkout, payment state, and customer order lookup
- Custom figurine intake APIs for prompts, asset uploads, moderation, and approval
- Internal operator endpoints for review, production readiness, and MCAE handoff
- Webhook-adjacent request models that must stay idempotent and auditable

## Working Rules

- Treat Stripe-confirmed payment as the only path into paid or production-ready states.
- Keep public API surface small and explicit for Czech launch scope.
- Separate customer actions from internal operations actions.
- Prefer status enums and transition commands over boolean flags.
- Design error responses so support and operations can distinguish validation, payment, moderation, and handoff failures.
- Include idempotency strategy whenever an endpoint can be retried by clients, webhooks, or operators.

## Endpoint Expectations

- Define request and response models with business terms the frontend can render directly.
- Make lifecycle transitions explicit: draft, awaiting_payment, paid, in_review, approved, rejected, sent_to_mcae, completed, refunded.
- Preserve auditability for who approved, rejected, retried, or handed off work.
- Keep custom figurine flows separate from catalog-only happy paths when data shape or risk differs.
- Fail closed when payment, moderation, or production readiness is uncertain.

## Output Shape

When you propose or implement an endpoint, include:

1. Route and method
2. Caller type: public customer, authenticated user, or internal operator
3. Request schema
4. Response schema
5. State transitions triggered
6. Idempotency and retry behavior
7. Validation and business-rule failures

## Avoid

- Marketplace or multi-country abstractions
- Implicit state changes hidden behind generic update endpoints
- Endpoints that let production advance before prepaid confirmation
- Mixing admin-only controls into customer-facing contracts
