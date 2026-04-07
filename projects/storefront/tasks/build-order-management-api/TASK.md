---
name: Build order management API with status tracking
assignee: backend-engineer
project: storefront
---

Build the order management system for the full order lifecycle.

- Order model: id, user_id, items (figurine_id, size, quantity), total, status, stripe_payment_id, tracking_number, timestamps
- Order statuses: pending_payment → paid → preparing → sent_to_printer → printing → shipped → delivered
- REST endpoints: POST /orders (create), GET /orders/{id} (detail), GET /orders (list for user), PATCH /orders/{id}/status (admin)
- Status transition validation (enforce valid state machine)
- Customer notification triggers on status changes (email integration point)
- Admin endpoint for MCAE handoff (mark as sent_to_printer, attach tracking)
- Order history with pagination for user account page
- Filtering by status for admin dashboard
