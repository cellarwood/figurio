---
name: Build Order Tracking UI
assignee: frontend-engineer
project: storefront
---

Build the order tracking interface so customers can follow their figurine from payment to delivery.

## Requirements

- Order status page accessible via order ID or email lookup
- Status timeline visualization: Paid → In Production → Shipped → Delivered
- Estimated delivery date display
- Zasilkovna tracking link integration when available
- Order details: items, sizes, total paid, shipping address
- Mobile-friendly layout

## Status States

1. **Confirmed** — payment captured, order created
2. **In Production** — print file sent to MCAE
3. **Quality Check** — printed, being inspected
4. **Shipped** — handed to Zasilkovna, tracking available
5. **Delivered** — confirmed delivery

## Acceptance Criteria

- Customers can look up orders by ID or email
- Status timeline updates correctly as order progresses
- Tracking link opens Zasilkovna tracking page
- Works well on mobile devices
