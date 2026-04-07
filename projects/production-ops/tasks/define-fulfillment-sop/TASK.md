---
name: Define order-to-delivery workflow and SOP with MCAE
assignee: head-of-operations
project: production-ops
---

Document the complete fulfillment standard operating procedure.

- Step 1: Order received and payment confirmed (Stripe webhook → order status: paid)
- Step 2: Print file prepared (model validated, print settings configured)
- Step 3: Print file sent to MCAE (format, delivery method — email, API, shared drive?)
- Step 4: MCAE prints and performs quality check
- Step 5: MCAE ships to Figurio warehouse or drop-ships to customer (determine which model)
- Step 6: Figurio packages with branded materials (if not drop-ship)
- Step 7: Ship to customer via Zasilkovna (CZ) or DHL (EU)
- Step 8: Tracking number provided to customer, order status updated
- Define SLAs at each step: expected turnaround times
- Define escalation procedures for delays, quality issues, or damaged prints
- Coordinate with Backend Engineer on order status API requirements
