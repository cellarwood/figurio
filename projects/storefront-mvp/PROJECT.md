---
name: Storefront MVP
slug: storefront-mvp
status: active
---

# Storefront MVP

Build the Figurio web storefront -- the minimum viable product that allows customers to browse the catalog, view figurines in 3D, add to cart, pay via Stripe, and track their order.

## Scope

- Product catalog with categories, search, and filtering
- Product detail pages with interactive 3D model viewer
- Shopping cart with size tier selection
- Stripe checkout (cards, Apple Pay, Google Pay, SEPA)
- Customer accounts (registration, login, order history)
- Order tracking dashboard
- Responsive design (mobile-first)
- Admin interface for catalog management

## Tech Stack

- **Frontend:** React, TypeScript, shadcn-ui, Tailwind CSS, React Three Fiber (3D viewer)
- **Backend:** Python, FastAPI, PostgreSQL, SQLAlchemy, Alembic
- **Payments:** Stripe Elements, Stripe webhooks
- **Infra:** Docker, Kubernetes, Traefik

## Deliverables

1. Database schema (products, orders, customers, payments)
2. Backend API (catalog, orders, auth, webhooks)
3. Frontend storefront (all pages and components)
4. Stripe integration (checkout, webhooks, refunds)
5. Order tracking (status updates, email notifications)
6. Deployment to figurio-dev namespace
