---
name: Integrate Stripe payments (checkout, webhooks, refunds)
assignee: backend-engineer
project: mvp-backend
---

Integrate Stripe as the payment processor.

## Requirements
- Stripe Checkout Session creation for catalog orders
- Webhook handler for payment events (succeeded, failed, refunded)
- Support for credit/debit cards, Apple Pay, Google Pay
- EU payment methods: Bancontact, iDEAL, SEPA Direct Debit
- Two-stage payment for custom figurines (50% deposit, 50% on approval)
- Refund handling
- Stripe webhook signature verification
