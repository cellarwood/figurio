---
name: Implement two-stage payment for custom orders
assignee: backend-engineer
project: ai-pipeline
---

Implement the two-stage payment model for AI custom figurine orders.

- Stage 1 (deposit): capture 50% at prompt submission using Stripe PaymentIntent with capture_method=manual or separate charge
- Stage 2 (approval): capture remaining 50% when customer approves the preview
- Refund Stage 1 if customer rejects the preview (full deposit refund)
- Handle edge cases: customer abandons preview (auto-refund after X days), payment method expired between stages
- Stripe webhook handlers for both payment events
- Store payment state on the custom order model (deposit_paid, fully_paid, refunded)
- Admin visibility into two-stage payment status
- Test with Stripe test mode across all EU payment methods
