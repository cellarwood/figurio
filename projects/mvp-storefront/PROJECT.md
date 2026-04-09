---
name: MVP Storefront
description: Build and deploy the Figurio e-commerce storefront with product catalog, 3D viewer, Stripe checkout, order management, and initial AI pipeline integration.
slug: mvp-storefront
owner: cto
---

# MVP Storefront

The core engineering project for Figurio's launch. Delivers a working web storefront where customers can browse the figurine catalog, view interactive 3D previews, select size tiers, add to cart, pay via Stripe, and track their orders.

## Scope

- React/TypeScript frontend with shadcn-ui component library
- FastAPI backend with PostgreSQL database
- Stripe payment integration (checkout, webhooks, refunds)
- Interactive 3D model viewer (Three.js)
- Order lifecycle management
- Docker containers deployed to MicroK8s via Helm
- GitHub Actions CI/CD pipeline
- Initial AI text-to-3D pipeline integration (prompt → generate → mesh repair → preview)

## Success Criteria

- A customer can browse the catalog, add a figurine to cart, pay with Stripe, and receive an order confirmation
- The 3D viewer renders .glb models with smooth rotation and zoom
- Orders flow through the complete lifecycle: placed → paid → printing → shipped → delivered
- CI/CD pipeline deploys to production with zero downtime
