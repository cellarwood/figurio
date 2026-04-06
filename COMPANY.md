---
name: Figurio
description: Direct-to-consumer e-commerce company designing, producing, and delivering high-quality full-color 3D-printed figurines
slug: figurio
schema: agentcompanies/v1
version: 1.0.0
license: MIT
authors:
  - name: Cellarwood
goals:
  - Launch figurio.cellarwood.org storefront with catalog browsing, cart, and Stripe checkout
  - Onboard first 20 catalog figurine models validated for printability
  - Process first 10 real customer orders end-to-end (order → MCAE print → ship → deliver)
  - Build content marketing engine with product photography, blog, and social media presence
  - Establish CI/CD pipeline deploying to microk8s-local with automated testing
---

# Figurio

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. The company operates through a web platform at figurio.cellarwood.org where customers browse a curated catalog of pre-designed figurines and order them for production.

## Product Lines

### Phase 1 — Catalog Figurines ("Ready to Print")
A curated, rotating catalog of pre-designed 3D figurines available for immediate order. Models are sourced from commercially licensed marketplaces (CGTrader, TurboSquid), commissioned original designs, and community/designer partnerships.

### Phase 2 — AI-Prompted Custom Figurines ("Prompt to Print")
Customers describe a figurine in natural language, AI generates a 3D model, and after preview approval it enters the print queue.

### Phase 3 — 3D Scan-to-Print ("Scan Yourself")
Mobile pop-up scanning at events, later a permanent retail studio.

## Production

All printing is outsourced to MCAE (mcae.cz), a Czech Republic-based Stratasys authorized partner using the Stratasys J55 PolyJet printer. Three size tiers: Small (~8cm), Medium (~15cm), Large (~25cm).

## Payments

All orders are prepaid via Stripe. No production begins until payment is captured.

## Tech Stack

- **Frontend:** React, TypeScript, shadcn-ui, Tailwind CSS
- **Backend:** Python, FastAPI, Uvicorn
- **Infrastructure:** Docker, Kubernetes (microk8s-local), Helm, Traefik
- **Domain:** cellarwood.org
