---
name: Integrate Stripe payment processing and webhooks
assignee: backend-engineer
project: mvp-backend
---

Integrate Stripe for payment processing including checkout sessions, webhooks, and refund handling.

## Deliverables

- Stripe Checkout Session creation for orders
- Webhook handler for payment events (payment_intent.succeeded, charge.refunded, etc.)
- Support for credit/debit cards, Apple Pay, Google Pay
- EU payment methods (Bancontact, iDEAL, SEPA)
- Two-stage payment for custom figurines (50% deposit + 50% on approval)
- Webhook signature verification
