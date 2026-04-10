---
schema: agentcompanies/v1
name: Figurio
slug: figurio
description: Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines from a curated catalog, AI-prompted custom designs, and 3D scan-to-print services.
version: 1.0.0
license: MIT
authors:
  - name: Cellarwood
goals:
  - Launch MVP e-commerce platform with catalog browsing, Stripe checkout, and order fulfillment
  - Launch AI prompt-to-print pipeline for custom figurine generation
  - Establish production and fulfillment operations with MCAE and EU shipping
  - Build Figurio brand and acquire first 100 paying customers
  - Research and plan scan-to-print service for Phase 2 launch
requirements:
  secrets:
    - STRIPE_SECRET_KEY
    - STRIPE_WEBHOOK_SECRET
    - GH_TOKEN
    - DOCKER_HUB_USERNAME
    - DOCKER_HUB_TOKEN
    - DATABASE_URL
    - GEMINI_API_KEY
    - ELEVENLABS_API_KEY
    - GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE
---

# Figurio

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. The company operates through a web platform where customers can browse a curated catalog, generate custom models via AI text prompts, or (in Phase 2) have themselves 3D-scanned to create personalized miniatures.

## Product Lines

### Catalog Figurines ("Ready to Print")
A curated, rotating catalog of pre-designed 3D figurines — viral/meme designs, seasonal figurines, event-driven designs, and evergreen collectibles. Models sourced from licensed marketplaces, commissioned original designs, and community partnerships.

### AI-Prompted Custom Figurines ("Prompt to Print")
Customers describe a figurine in natural language, and the system generates a 3D model using AI. Automated mesh repair, human QA, and customer preview approval before printing. Two-stage deposit payment (50/50).

### 3D Scan-to-Print Figurines ("Scan Yourself") — Phase 2
Mobile pop-up scanning at conventions, markets, and events using photogrammetry or structured-light scanners. Permanent retail studio as long-term goal.

## Production

All printing outsourced to **MCAE (mcae.cz)**, a Czech Republic-based Stratasys authorized partner, using the **Stratasys J55 PolyJet printer**. Three size tiers: Small (~8cm), Medium (~15cm), Large (~25cm).

## Tech Stack

- **Frontend:** React/TypeScript, shadcn-ui, Tailwind CSS, Three.js, GSAP
- **Backend:** Python/FastAPI, SQLAlchemy, Alembic, Celery, Redis
- **Infrastructure:** Docker, Kubernetes (microk8s), Traefik, GitHub Actions
- **Payments:** Stripe (cards, Apple Pay, Google Pay, EU methods)
- **AI Pipeline:** Text-to-3D (Meshy/Tripo3D), Blender mesh repair
- **Shipping:** Zasilkovna (CZ/SK), DHL (EU)

## Organization

| Agent | Role | Reports To |
|-------|------|-----------|
| CEO | Chief Executive Officer | — |
| CTO | Chief Technology Officer | CEO |
| CMO | Chief Marketing Officer | CEO |
| Head of Operations | Head of Operations | CEO |
| Backend Engineer | Backend Engineer | CTO |
| Frontend Engineer | Frontend Engineer | CTO |
| DevOps Engineer | Infrastructure Engineer | CTO |
| Content Creator | Content Creator | CMO |
