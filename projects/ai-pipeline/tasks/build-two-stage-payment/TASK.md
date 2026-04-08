---
name: Build customer preview approval flow with 2-stage payment
assignee: backend-engineer
project: ai-pipeline
---

# Build customer preview approval flow with 2-stage payment

Implement 2-stage payment for custom figurines:

1. 50% deposit at order via Stripe
2. Hold remaining 50%
3. After AI generation + mesh repair + QA, send rendered preview to customer
4. On approval, capture remaining 50%
5. On rejection, offer revision or refund deposit

Use Stripe PaymentIntents with manual capture.
