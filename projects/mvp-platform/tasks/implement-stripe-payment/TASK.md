---
name: Implement Stripe payment integration with prepaid checkout and 2-stage deposits
assignee: backend-engineer
project: mvp-platform
---

Integrate Stripe for all payment processing. Two payment flows are needed.

## Flow 1: Standard Checkout (Catalog Figurines)

- Create Stripe Checkout Session for catalog purchases
- Support: credit/debit cards, Apple Pay, Google Pay, SEPA, iDEAL, Bancontact
- Handle successful payment via webhook (`checkout.session.completed`)
- Create order record on successful payment

## Flow 2: 2-Stage Deposit (AI-Custom Figurines)

- Stage 1: Capture 50% deposit when customer submits AI prompt (PaymentIntent with `capture_method: manual` or separate charge)
- Stage 2: Capture remaining 50% when customer approves the 3D preview
- Handle rejection: refund deposit if customer rejects the preview after max revisions

## Technical Details

- Use Stripe Python SDK
- Webhook endpoint: `POST /webhooks/stripe` with signature verification
- Idempotency keys on all Stripe API calls
- Store Stripe customer_id, payment_intent_id, and checkout_session_id in orders table
- Environment variables: `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY`, `STRIPE_WEBHOOK_SECRET`

## Acceptance Criteria

- Both payment flows working in Stripe test mode
- Webhook handler processing all relevant events
- Idempotent payment processing (no double charges)
- Refund flow for rejected AI-custom previews
- Integration tests using Stripe test fixtures
