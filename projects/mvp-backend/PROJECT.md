---
name: MVP Backend
description: Backend API with product catalog, order pipeline, Stripe payments, AI generation queue, and user accounts
slug: mvp-backend
owner: backend-engineer
---

## Scope

Build and deploy the Figurio backend API using Python/FastAPI. Covers product catalog CRUD, order state machine, Stripe checkout with two-stage payments for AI custom figurines, text-to-3D generation queue, and user authentication.

## Tech Stack

- Python 3.10+ with FastAPI and Uvicorn
- PostgreSQL for persistence
- Stripe for payments (checkout sessions, webhooks)
- uv for package management
- Docker for containerization

## Success Criteria

- All API endpoints tested and documented
- Stripe checkout and webhook integration working
- AI generation job queue processing text-to-3D requests
- Order state machine handling full lifecycle
- Deployed and accessible from the frontend
