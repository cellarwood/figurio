---
name: Platform Frontend
description: React/TypeScript storefront with catalog browsing, AI custom ordering, cart, Stripe checkout, and order tracking
slug: platform-frontend
owner: frontend-engineer
---

## Scope

Build the Figurio customer-facing storefront as a React/TypeScript single-page application.

### Core Features

- Catalog browsing with product grid, filtering by category/size, and search
- Product detail pages with image gallery and 3D preview
- AI custom order flow: prompt input, generation status, 3D preview viewer, approval/revision
- Shopping cart with size tier selection
- Stripe Elements checkout with Apple Pay / Google Pay
- Order tracking and history
- Responsive landing page with hero section and product highlights

### Tech Stack

- TypeScript with strict mode
- React with shadcn-ui and Radix UI
- Tailwind CSS for styling
- Three.js for 3D model preview rendering
- Stripe.js for payment elements

## Success Criteria

- Full purchase flow works end-to-end (browse → cart → pay → track)
- AI custom order flow works (prompt → preview → approve → pay)
- WCAG 2.1 AA accessible
- Mobile-responsive across all pages
- Component tests with React Testing Library
