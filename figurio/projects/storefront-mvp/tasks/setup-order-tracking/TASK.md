---
name: Set up order tracking
slug: setup-order-tracking
assignee: cto
priority: high
status: todo
---

# Set Up Order Tracking

Implement order status tracking so customers can follow their figurine from payment to delivery.

## Expected Subtasks

- CTO delegates to Backend Engineer (API) and Frontend Engineer (UI)
- Backend: order status API, status transition logic, email notifications on status changes
- Frontend: order tracking page with visual timeline (pending -> in production -> shipped -> delivered)
- Shipping tracking number integration (Zasilkovna tracking URL, DHL tracking URL)
- Admin endpoint to update order status (used by Head of Operations)
