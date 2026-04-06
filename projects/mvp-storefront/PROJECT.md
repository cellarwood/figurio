---
name: MVP Storefront
description: Build and launch the Figurio catalog storefront with product browsing, cart, Stripe checkout, and order management
slug: mvp-storefront
owner: cto
---

## Scope

Build the initial e-commerce storefront at figurio.cellarwood.org with these capabilities:

- Product catalog with browsing, search, and filtering by category and size tier
- Product detail pages with images, size selector (S/M/L), and 3D model viewer
- Shopping cart and Stripe checkout integration
- Customer order tracking with status updates
- Admin panel for managing products and viewing/updating orders
- PostgreSQL database for products, orders, customers, and shipping status

## Success Criteria

- Storefront deployed and accessible at figurio.cellarwood.org
- End-to-end flow working: browse → add to cart → pay via Stripe → order created
- Admin can add/edit products and update order status
- Customer can track their order status
- Automated test suite covering payment flow and order state transitions

## Workspace

This project targets the Figurio monorepo at `github.com/cellarwood/figurio`.
