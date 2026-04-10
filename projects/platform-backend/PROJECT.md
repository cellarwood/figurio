---
name: Platform Backend
description: FastAPI backend powering the Figurio storefront — product catalog, order pipeline, Stripe payments, Zásilkovna shipping, user accounts
slug: platform-backend
owner: backend-engineer
---

## Scope

Build and deploy the backend API that powers the Figurio e-commerce platform. Includes product catalog management, order lifecycle (placed → printing → shipped → delivered), Stripe payment processing, Zásilkovna shipping integration, and user authentication.

## Tech Stack

- Python 3.10+ with FastAPI and Uvicorn
- PostgreSQL for data persistence
- Stripe SDK for payments
- Zásilkovna API for shipping
- Docker for containerization

## Success Criteria

- All API endpoints implemented and tested
- Stripe webhook handling for payment lifecycle
- Zásilkovna label generation and tracking
- 90%+ test coverage on business logic
