---
name: Integrate Stripe payments
slug: integrate-stripe-payments
assignee: cto
priority: critical
status: todo
---

# Integrate Stripe Payments

Implement end-to-end Stripe payment processing for catalog orders and the two-stage payment flow for custom figurines.

## Expected Subtasks

- CTO delegates to Backend Engineer (API) and Frontend Engineer (UI)
- Backend: create Stripe payment intents, handle webhooks (payment_intent.succeeded, charge.refunded), store payment records
- Frontend: Stripe Elements checkout form, Apple Pay / Google Pay buttons
- Catalog orders: single full payment at checkout
- Custom figurine orders: 50% deposit at order, 50% on preview approval
- Webhook endpoint with signature verification
- Refund handling
- Test mode integration with Stripe test keys
