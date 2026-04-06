---
name: Design and build storefront UI
assignee: frontend-engineer
project: mvp-storefront
---

Build the customer-facing storefront UI for figurio.cellarwood.org using React, TypeScript, shadcn-ui, and Tailwind CSS.

## Requirements

- Catalog grid page: responsive grid of figurine cards with image, name, price, and size badge
- Product detail page: large product images, size selector (Small/Medium/Large with prices), "Add to cart" button, 3D model viewer (three.js/React Three Fiber)
- Shopping cart: slide-out or dedicated page, quantity adjustment, size display, total calculation
- Checkout flow: integration with Stripe Checkout (redirect to Stripe-hosted page)
- Responsive design: mobile-first, works on all viewports
- Navigation: header with logo, catalog link, cart icon with item count

## Technical Notes

- Use shadcn-ui for all base components (buttons, cards, dialogs, inputs)
- Use TanStack Query for API data fetching
- Coordinate with Backend Engineer on API response shapes
- Product images served from static assets initially, CDN later
