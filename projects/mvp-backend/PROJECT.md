---
name: MVP Backend
slug: mvp-backend
description: FastAPI backend with product catalog, Stripe payments, order management, user accounts, and admin APIs
owner: backend-engineer
---

## Scope

Build and deploy the Figurio backend API using Python/FastAPI with PostgreSQL. Handles product catalog management, Stripe payment processing, order lifecycle, user authentication, and admin operations.

## Tech Stack

- Python 3.10+ with FastAPI and Uvicorn
- PostgreSQL for persistent storage
- Stripe SDK for payment processing
- uv for package management
- Docker for containerization

## Success Criteria

- All CRUD endpoints for products, orders, and users are functional
- Stripe checkout and webhook handling works end-to-end
- Order lifecycle state machine handles all transitions correctly
- API deployed and accessible via Traefik ingress
- Integration tests pass for all critical paths
