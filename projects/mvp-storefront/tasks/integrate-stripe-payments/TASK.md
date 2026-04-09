---
name: Integrate Stripe Payments
assignee: backend-engineer
project: mvp-storefront
---

Integrate Stripe for payment processing with webhook handling.

- Implement Stripe Checkout Session creation for catalog orders
- Configure webhook endpoint for payment events (payment_intent.succeeded, payment_intent.payment_failed, charge.refunded)
- Implement idempotent webhook handler (handle duplicate deliveries)
- Support payment methods: cards, Apple Pay, Google Pay, SEPA Direct Debit, iDEAL
- Implement refund API endpoint for Head of Operations
- Build two-stage payment for custom AI figurines: 50% deposit at order, 50% on preview approval
- Store Stripe payment IDs in the orders table for reconciliation
- Use test mode keys during development (sk_test_*)
- Write integration tests with Stripe test fixtures
