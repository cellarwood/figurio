---
name: Build order lifecycle management with webhook handling
assignee: backend-engineer
project: mvp-backend
---

Implement order pipeline:
- Order creation on successful payment
- Status transitions: placed → preparing → printing → shipped → delivered
- Stripe webhook handling (payment_intent.succeeded, refunds)
- Order history and detail endpoints
- Email notification triggers (order confirmed, shipped, delivered)
