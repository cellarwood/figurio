---
name: Figurio
description: Direct-to-consumer e-commerce company designing, producing, and delivering high-quality full-color 3D-printed figurines from Czech Republic
slug: figurio
schema: agentcompanies/v1
version: 1.0.0
goals:
  - Launch the Figurio e-commerce platform with catalog browsing, AI-prompted custom figurines, and Stripe checkout
  - Establish the MCAE production pipeline with validated per-unit pricing across all three size tiers (8cm, 15cm, 25cm)
  - Build a content and social media engine that generates weekly product visuals and posts across Instagram and TikTok
  - Deploy production infrastructure on Kubernetes with CI/CD, automated testing, and monitoring
---

# Figurio

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. Customers can browse a curated catalog of pre-designed figurines or generate custom models via AI text prompts through the web platform.

## Product Lines

### Catalog Figurines ("Ready to Print")
A curated, rotating catalog of pre-designed 3D figurines — viral/meme-driven designs, seasonal figurines, event-driven designs, and evergreen collectibles. Models are sourced from commercially licensed marketplaces, commissioned original designs, and community/designer partnerships.

### AI-Prompted Custom Figurines ("Prompt to Print")
Customers describe a figurine in natural language, the system generates a 3D model using AI, the customer reviews a rendered preview, and upon approval the model enters the print queue. Two-stage payment: 50% deposit at order, 50% on preview approval.

## Production
All printing is outsourced to MCAE (mcae.cz), a Czech Republic-based Stratasys authorized partner, using the Stratasys J55 PolyJet printer. Three size tiers: Small (~8cm), Medium (~15cm), Large (~25cm). All orders are prepaid via Stripe.

## Technology
- **Frontend:** React, TypeScript, shadcn-ui, Tailwind CSS
- **Backend:** Python, FastAPI, Uvicorn
- **Infrastructure:** Docker, Kubernetes (microk8s), Traefik, Helm
- **AI Pipeline:** Text-to-3D (Meshy/Tripo3D), automated mesh repair
- **Payments:** Stripe (cards, Apple Pay, Google Pay, SEPA)
