---
name: Integrate Stripe payments with checkout sessions and webhooks
assignee: backend-engineer
project: platform-backend
---

Integrate Stripe for payment processing:

- Checkout session creation with line items (product + size tier)
- Webhook handler for checkout.session.completed, payment_intent.succeeded, charge.refunded
- Support for Apple Pay, Google Pay, and EU methods (iDEAL, Bancontact, SEPA)
- Two-stage payment for custom orders: 50% deposit session, 50% approval session
- Refund handling
- Stripe customer creation for order history
- Webhook signature verification with STRIPE_WEBHOOK_SECRET
