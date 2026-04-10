---
schema: agentcompanies/v1
kind: company
name: Figurio
slug: figurio
description: Direct-to-consumer e-commerce company designing, producing, and delivering high-quality full-color 3D-printed figurines from Czech Republic
version: 1.0.0
license: MIT
authors:
  - name: Cellarwood
goals:
  - Launch MVP e-commerce platform with catalog browsing, ordering, and Stripe payments
  - Build AI custom figurine pipeline enabling Prompt to Print product line
  - Establish Figurio brand identity and acquire first customers
  - Establish production and fulfillment operations via MCAE partnership
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

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines.

## Product Lines

### Catalog Figurines ("Ready to Print")
A curated, rotating catalog of pre-designed 3D figurines — viral and meme-driven designs, seasonal figurines, event-driven designs, and evergreen collectibles. Models are sourced through commercially licensed marketplaces, commissioned original designs, and community partnerships. All models are pre-validated for printability.

### AI-Prompted Custom Figurines ("Prompt to Print")
Customers describe a figurine in natural language, and the system generates a 3D model using AI. The customer reviews a rendered preview, approves or requests adjustments, and upon approval the model enters the print queue. Uses a deposit-based payment model (50% at order, 50% on approval).

## Production

All printing is outsourced to **MCAE (mcae.cz)**, a Czech Republic-based Stratasys authorized partner, using the **Stratasys J55 PolyJet printer**. Full-color, multi-material prints with fine detail resolution.

### Size Tiers
- **Small** (~8 cm) — Desk figurines, keychains
- **Medium** (~15 cm) — Display, gifts
- **Large** (~25 cm) — Premium collectibles

## Tech Stack

- **Frontend:** React/TypeScript, shadcn-ui, Tailwind CSS, GSAP
- **Backend:** Python/FastAPI, PostgreSQL, uv package manager
- **AI Pipeline:** Meshy/Tripo3D APIs, Blender scripting for mesh repair, PyTorch
- **Infrastructure:** Docker, Kubernetes (microk8s-local), Traefik, GitHub Actions
- **Payments:** Stripe
- **Shipping:** Zasilkovna (CZ), DHL (EU)

## Org Chart

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   ├── ML/AI Engineer
│   └── DevOps Engineer
├── CMO
│   └── Content Creator
└── Head of Operations
```

## Infrastructure

- **GitHub:** cellarwood/figurio
- **Docker Hub:** lukekelle00
- **K8s Cluster:** microk8s-local
- **Domain:** cellarwood.org
- **GWS Domain:** cellarwood.org
- **Slack:** 00aiworkspace.slack.com
- **Stripe Account:** Cellarwood
