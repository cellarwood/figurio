---
name: Build Cart and Checkout Flow
assignee: frontend-engineer
project: mvp-storefront
---

Build the shopping cart and Stripe checkout flow for catalog figurine purchases.

- Implement cart with add/remove/update quantity, size tier selection, and price calculation
- Persist cart state across sessions (localStorage + server sync)
- Build checkout page with shipping address form, order summary, and Stripe Elements payment form
- Integrate Stripe Checkout or Payment Elements for card, Apple Pay, Google Pay
- Handle payment success/failure states with appropriate UI feedback
- Build order confirmation page with order number and estimated delivery
- Implement SEPA Direct Debit and iDEAL for EU customers
