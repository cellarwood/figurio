---
name: Implement order tracking
assignee: backend-engineer
project: mvp-storefront
---

Build customer-facing order tracking and email notifications for order status changes.

## Requirements

### Order Tracking Page
- Customer can view order status by entering order ID + email (no account required initially)
- Display: order items, size tiers, total paid, current status, tracking number (when available)
- Status timeline: paid → printing → shipped → delivered with timestamps

### Email Notifications
- Order confirmation email on successful payment
- Status update email when order moves to "shipped" (include tracking number and carrier link)
- Delivery confirmation email

## Technical Notes

- Order tracking endpoint: `GET /api/orders/{id}/status?email={email}` (email as simple auth)
- Email sending: use a transactional email service (SendGrid, Mailgun, or SMTP)
- Email templates in HTML with plain-text fallback
- Include Figurio branding in all emails
- Rate limit the tracking endpoint to prevent enumeration
