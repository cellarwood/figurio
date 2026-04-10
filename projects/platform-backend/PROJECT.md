---
name: Platform Backend
description: FastAPI backend with product catalog, order pipeline, Stripe payments, and AI figurine generation pipeline
slug: platform-backend
owner: backend-engineer
---

## Scope

Build and deploy the Figurio backend API service using Python/FastAPI.

### Core Features

- Product catalog with CRUD, image serving, size tiers, and pricing
- Order pipeline with state machine (placed → paid → printing → shipped → delivered)
- Stripe integration: checkout sessions, webhooks, refunds, two-stage deposits for custom orders
- AI prompt-to-print pipeline: text-to-3D API integration, job queue, mesh repair automation
- Admin API for catalog and order management

### Tech Stack

- Python 3.10+ with FastAPI and Uvicorn
- PostgreSQL with Alembic migrations
- uv for package management
- Celery + Redis for async job processing (AI generation, mesh repair)
- Stripe SDK for payments

## Success Criteria

- All API endpoints tested with pytest (unit + integration)
- Stripe webhook handling verified end-to-end
- AI generation pipeline processes prompts and returns previews
- Mesh repair automation catches common printability issues
- API deployed and serving traffic behind Traefik
