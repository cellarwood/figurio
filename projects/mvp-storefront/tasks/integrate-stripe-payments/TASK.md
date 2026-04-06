---
name: Integrate Stripe payments
assignee: backend-engineer
project: mvp-storefront
---

Implement Stripe payment integration for the checkout flow. All orders are prepaid — no production until payment is captured.

## Requirements

- Create Stripe Checkout Session when customer initiates checkout
- Include line items with product name, size tier, price, and quantity
- Support payment methods: credit/debit cards, Apple Pay, Google Pay
- Handle Stripe webhooks: `checkout.session.completed`, `payment_intent.succeeded`, `payment_intent.payment_failed`
- On successful payment: create order record with status "paid"
- On failed payment: notify customer, no order created
- Stripe webhook signature verification on all incoming webhooks

## Technical Notes

- Use Stripe Python SDK (`stripe` package)
- Store Stripe session ID and payment intent ID on the order record
- Test with Stripe CLI (`stripe listen --forward-to`) and test mode keys
- Stripe fee calculation: ~2.9% + €0.25 per transaction (varies by card type)
- Never log or store full card numbers or Stripe secret keys
