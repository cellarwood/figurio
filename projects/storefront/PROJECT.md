---
name: Storefront
description: Build and launch the Figurio e-commerce storefront with catalog browsing, product pages, shopping cart, Stripe checkout, and order tracking
slug: storefront
owner: cto
---

# Storefront

The core e-commerce platform for Figurio. Customers browse the figurine catalog, view product details with 3D previews, select size tiers, add to cart, and complete purchases via Stripe.

## Scope

- Product catalog with grid/list views, filtering, and search
- Figurine detail pages with 3D model preview, size tier selector, and pricing
- Shopping cart with multi-item support
- Stripe checkout with support for cards, Apple Pay, Google Pay
- Order confirmation and tracking
- Admin interface for product management and order fulfillment
- Responsive mobile-first design

## Tech Stack

- **Frontend:** React/TypeScript, shadcn-ui, Tailwind CSS
- **Backend:** Python/FastAPI, PostgreSQL
- **Payments:** Stripe
- **Infrastructure:** Docker, K8s, Traefik

## Success Criteria

- Customers can browse, select, and purchase catalog figurines end-to-end
- Stripe payments process successfully with proper error handling
- Mobile experience is fully functional
- Page load time under 3 seconds on mobile
