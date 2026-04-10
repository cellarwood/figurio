---
name: MVP Backend
description: FastAPI backend with product catalog, order management, Stripe payments, and AI figurine pipeline
slug: mvp-backend
owner: backend-engineer
---

## Scope

Build the core backend API for Figurio's e-commerce platform using Python/FastAPI.

### Key Systems
- Product catalog API with size tiers (small 8cm, medium 15cm, large 25cm)
- Order management with full lifecycle tracking
- Stripe payment integration (checkout, webhooks, refunds, deposits)
- Custom figurine workflow (prompt intake, AI generation trigger, preview delivery, approval)
- Text-to-3D API integration with automated mesh repair

### Tech Stack
- Python 3.10+ with FastAPI and Uvicorn
- PostgreSQL database
- Stripe SDK for payments
- Meshy/Tripo3D API for 3D generation
- Blender scripting for mesh repair
- uv for package management

## Success Criteria
- All API endpoints documented and tested
- Stripe payment flow working end-to-end
- AI pipeline producing printable 3D models
- Database migrations versioned and reproducible
