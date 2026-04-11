---
name: Figurio
description: Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines through a web platform offering curated catalog browsing and AI-prompted custom figurine generation
slug: figurio
schema: agentcompanies/v1
version: 1.0.0
goals:
  - Launch MVP e-commerce platform with catalog browsing, AI-prompted custom figurines, Stripe payments, and order management
  - Build a launch-ready catalog of 30+ print-ready figurine designs across trending, seasonal, and evergreen categories
  - Establish production and fulfillment pipeline with MCAE printing partner, branded packaging, and CZ/EU shipping
  - Build brand identity and acquire first 100 paying customers through social commerce and content marketing
---

# Figurio

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. The company operates through a web platform where customers can browse a curated catalog or generate custom figurines via AI text prompts.

## Product Lines

### Catalog Figurines ("Ready to Print")
A curated, rotating catalog of pre-designed 3D figurines — viral/meme designs, seasonal collections, event-driven designs, and evergreen collectibles. Models are sourced from licensed marketplaces, commissioned artists, and community partnerships.

### AI-Prompted Custom Figurines ("Prompt to Print")
Customers describe a figurine in natural language, the system generates a 3D model using AI (text-to-3D), an automated pipeline repairs the mesh, a technician reviews printability, and the customer approves a rendered preview before production begins.

## Production
All printing is outsourced to MCAE (mcae.cz) using the Stratasys J55 PolyJet printer — full-color, multi-material prints with fine detail resolution. Three size tiers: Small (~8cm), Medium (~15cm), Large (~25cm).

## Technology
- **Frontend:** React/TypeScript, shadcn-ui, Tailwind CSS
- **Backend:** Python/FastAPI, PostgreSQL
- **Infrastructure:** Docker, Kubernetes (microk8s), Traefik, GitHub Actions
- **Payments:** Stripe (checkout sessions, webhooks, two-stage for custom)
- **AI Pipeline:** Text-to-3D (Meshy/Tripo3D), automated mesh repair

## Key Operations
- All orders prepaid via Stripe — no production without payment
- Fulfillment: MCAE prints → branded packaging → Zásilkovna (CZ) / DHL (EU/world)
- IP-clean catalog: original commissions and verified commercial licenses only
