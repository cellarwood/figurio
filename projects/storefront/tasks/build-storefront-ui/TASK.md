---
name: Build Storefront UI
assignee: frontend-engineer
project: storefront
---

Build the main storefront interface — the customer's first impression of Figurio. This must be visually compelling (figurines are a visual product) and mobile-first.

## Requirements

- Product catalog page with grid/list view toggle
- Filtering sidebar (category, size tier, price range) with URL-based filter state
- Product card component with image, name, price range, and quick-add
- Figurine detail page with image gallery, 3D model viewer (if available), size tier selector with pricing, and add-to-cart
- Shopping cart with quantity controls, size tier display, and order summary
- Responsive design — mobile-first, works on phones, tablets, and desktop
- Loading states, empty states, and error handling throughout

## Tech Stack

- React with TypeScript (strict mode)
- shadcn-ui components, Radix UI primitives
- Tailwind CSS for styling
- GSAP for product image animations and transitions

## Acceptance Criteria

- Catalog loads and displays products from the API
- Filtering and sorting work without full page reload
- Cart persists across page navigation (local state or localStorage)
- Mobile layout is usable and visually appealing
- Page load time under 3 seconds on mobile (Lighthouse score 90+)
