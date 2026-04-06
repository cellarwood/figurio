---
name: Build admin panel
assignee: frontend-engineer
project: mvp-storefront
---

Build an internal admin panel for managing the Figurio product catalog and orders.

## Requirements

- Product management: list all products, create new product, edit existing product, change status (draft/published/archived)
- Product form: name, description, category, prices per size tier, image upload, 3D model URL
- Order management: list all orders with filtering by status, view order detail
- Order detail: customer info, line items, payment status, shipping status, tracking number
- Order status update: ability to change status (paid → printing → shipped → delivered)
- Dashboard: total orders, revenue, orders by status (simple counts)

## Technical Notes

- Separate route group (e.g., `/admin/*`) with basic auth or API key protection initially
- Reuse shadcn-ui components: data tables, forms, dialogs
- Use TanStack Query for data fetching with optimistic updates on status changes
- Mobile-responsive but desktop-optimized (admin usage is primarily desktop)
