---
name: Implement Stripe checkout with multi-currency and EU payment methods
assignee: backend-engineer
project: storefront
---

Integrate Stripe for payment processing across the storefront.

- Create Stripe Checkout Sessions for catalog purchases (full prepayment)
- Support payment methods: credit/debit cards, Apple Pay, Google Pay, SEPA Direct Debit, iDEAL, Bancontact
- Multi-currency support (EUR primary, CZK for Czech customers)
- Stripe webhook handler for payment events (payment_intent.succeeded, checkout.session.completed, etc.)
- Idempotent webhook processing with deduplication
- Order creation triggered on successful payment
- Stripe test mode configuration for dev/staging environments
- Proper error handling for failed payments, expired sessions, and declined cards
