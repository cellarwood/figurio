---
name: MVP Backend API
description: FastAPI backend with product catalog, Stripe payments, order management, user auth, and admin endpoints
slug: mvp-backend
owner: backend-engineer
---

## Scope

Build the complete backend API for Figurio's e-commerce platform using Python/FastAPI with PostgreSQL.

## Key Deliverables

- User authentication (registration, login, JWT sessions)
- Product catalog API (figurines, categories, size tiers)
- Shopping cart and Stripe checkout integration
- Order lifecycle management (placed → printing → shipped → delivered)
- Admin API for catalog and order management
- MCAE print file handoff integration

## Tech Stack

- Python 3.10+ with FastAPI and Uvicorn
- PostgreSQL with Alembic migrations
- Stripe SDK for payments and webhooks
- Docker multi-stage builds
- uv for package management

## Success Criteria

- All API endpoints tested with pytest
- Stripe checkout and webhook flow working end-to-end
- API deployed and accessible via Traefik ingress
