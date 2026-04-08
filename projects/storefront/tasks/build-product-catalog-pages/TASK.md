---
name: Build Product Detail and Checkout Pages
assignee: frontend-engineer
project: storefront
---

Build the product detail page with Stripe checkout integration — the conversion funnel from browsing to purchase.

## Requirements

### Product Detail Page
- Large product image gallery with zoom capability
- 3D model viewer component (three.js or model-viewer) for interactive figurine preview
- Size tier selector (Small/Medium/Large) with dynamic pricing display
- Product description, materials info, estimated delivery time
- "Add to Cart" button with size tier selection required
- Related/recommended products section

### Checkout Flow
- Cart review page with all items, quantities, and total
- Stripe Elements or Stripe Checkout redirect integration
- Order confirmation page with order ID and estimated delivery
- Email confirmation trigger (via backend webhook)

## Tech Stack

- React/TypeScript with Stripe.js and @stripe/react-stripe-js
- three.js or @google/model-viewer for 3D preview
- shadcn-ui for form components

## Acceptance Criteria

- Product detail page renders all product information correctly
- 3D viewer loads and allows rotation/zoom of figurine model
- Size selection updates displayed price in real-time
- Checkout completes successfully with Stripe test cards
- Order confirmation displays after successful payment
