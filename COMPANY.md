---
schema: agentcompanies/v1
name: Figurio
slug: figurio
description: Direct-to-consumer e-commerce company designing, producing, and delivering high-quality full-color 3D-printed figurines from the Czech Republic
version: 1.0.0
license: MIT
authors:
  - name: Cellarwood
goals:
  - Launch MVP e-commerce platform with catalog browsing, AI-prompted custom figurines, and Stripe payments
  - Establish supply chain and fulfillment pipeline with MCAE printing partner
  - Validate market strategy through competitive analysis, customer research, and pricing model
  - Build Figurio brand identity and acquire first 100 paying customers
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

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. The company operates through a web platform where customers can browse a curated catalog, generate custom models via AI text prompts, or (in a later phase) have themselves 3D-scanned to create personalized miniatures.

## Product Lines

### 1. Catalog Figurines ("Ready to Print")

A curated, rotating catalog of pre-designed 3D figurines built around models with high purchase probability — viral/meme-driven designs, seasonal figurines, event-driven designs, and evergreen collectibles. Models are sourced through commercially licensed marketplaces, commissioned original designs, and community designer partnerships.

### 2. AI-Prompted Custom Figurines ("Prompt to Print")

Customers describe a figurine in natural language, the system generates a 3D model using AI (text-to-3D), the model goes through automated mesh repair and human QA, and the customer approves a rendered preview before printing. Two-stage payment: 50% deposit at order, 50% on approval.

### 3. 3D Scan-to-Print ("Scan Yourself") — Phase 2

Personalized figurines from 3D body scans, initially via mobile pop-up operations at conventions, markets, and events.

## Production

All printing is outsourced to **MCAE** (mcae.cz), a Czech Republic-based Stratasys authorized partner, using the **Stratasys J55 PolyJet printer** for full-color, multi-material, detail-rich prints.

### Size Tiers

| Tier | Height | Use Case |
|------|--------|----------|
| Small | ~8 cm | Desk figurines, keychains |
| Medium | ~15 cm | Display, gifts |
| Large | ~25 cm | Premium collectibles |

## Technology Stack

- **Frontend:** React/TypeScript, shadcn-ui, Tailwind CSS, Three.js (3D preview)
- **Backend:** Python/FastAPI, PostgreSQL, async SQLAlchemy
- **AI Pipeline:** Text-to-3D (Meshy/Tripo3D), automated mesh repair
- **Payments:** Stripe (cards, Apple Pay, Google Pay, SEPA)
- **Infrastructure:** Docker, Kubernetes (microk8s), Terraform, Traefik, GitHub Actions
- **Monitoring:** Sentry, Prometheus

## Org Structure

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   └── DevOps Engineer
├── CMO
│   ├── Content Creator
│   └── UI Designer
└── Head of Operations
```
