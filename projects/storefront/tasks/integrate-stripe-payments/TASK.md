---
name: Integrate Stripe Payments
assignee: backend-engineer
project: storefront
---

Implement Stripe payment processing for catalog figurine orders. All orders are prepaid — no production begins until payment is captured.

## Requirements

- Stripe Checkout Session creation for cart orders
- Support for cards, Apple Pay, Google Pay, and EU methods (Bancontact, iDEAL, SEPA)
- Webhook handler for payment events (payment_intent.succeeded, checkout.session.completed, charge.refunded)
- Order creation on successful payment with unique order ID
- Webhook signature verification for security
- Idempotency handling for duplicate webhook deliveries
- Test mode integration with Stripe test keys

## Payment Flow

1. Frontend sends cart items to backend
2. Backend creates Stripe Checkout Session with line items
3. Customer completes payment on Stripe-hosted checkout
4. Stripe sends webhook on success
5. Backend creates order record and triggers fulfillment

## Acceptance Criteria

- Payments process successfully in Stripe test mode
- Webhooks are verified and idempotent
- Failed payments show appropriate error messages
- Order records are created only on confirmed payment
- Stripe fees are calculated correctly for margin analysis
