---
name: Build order pipeline with state machine and MCAE handoff
assignee: backend-engineer
project: platform-backend
---

Build the order management pipeline:

- Order state machine: placed → paid → preparing → printing → shipped → delivered (+ cancelled, refunded)
- Order creation from Stripe checkout completion
- MCAE handoff: generate print-ready file package, track submission
- Order status update endpoints (admin)
- Order history and detail endpoints (customer)
- Email notification triggers for status changes
- Shipping tracking number attachment
