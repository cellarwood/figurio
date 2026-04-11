---
schema: agentcompanies/v1
name: Figurio
slug: figurio
version: 1.0.0
description: Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines from a curated catalog and AI-generated custom models.
domain: cellarwood.org
github: https://github.com/cellarwood/figurio
goals:
  - Launch MVP e-commerce platform with catalog browsing, Stripe checkout, and order management
  - Build AI prompt-to-print pipeline for custom figurine generation with mesh repair and customer preview
  - Establish Figurio brand and acquire first 100 paying customers through social media, content, and SEO
  - Operationalize production and fulfillment with MCAE printing partnership and Zasilkovna/DHL shipping
---

# Figurio

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. The company operates through a web platform where customers can browse a curated catalog of pre-designed figurines or generate custom models via AI text prompts ("Prompt to Print").

## Business Model

All production is outsourced to MCAE (mcae.cz), a Czech Republic-based Stratasys authorized partner, using the Stratasys J55 PolyJet printer for full-color, multi-material prints. All orders are prepaid via Stripe, ensuring zero cash-flow risk from unfulfilled orders.

### Product Lines

1. **Catalog Figurines ("Ready to Print")** — Curated, rotating catalog of pre-designed 3D figurines: viral/meme designs, seasonal figurines, event-driven designs, and evergreen collectibles. Sourced from commercially licensed models, commissioned original designs, and designer partnerships.

2. **AI-Prompted Custom Figurines ("Prompt to Print")** — Customers describe a figurine in natural language, the system generates a 3D model via AI, automated mesh repair ensures printability, and a rendered preview is sent for customer approval before printing. Two-stage deposit payment (50/50).

3. **3D Scan-to-Print ("Scan Yourself")** — Phase 2 future product line for personalized figurines from body scans.

### Size Tiers

| Tier | Height | Use Case |
|------|--------|----------|
| Small | ~8 cm | Desk figurines, keychains |
| Medium | ~15 cm | Display, gifts |
| Large | ~25 cm | Premium collectibles |

## Tech Stack

- **Frontend:** React/TypeScript, shadcn-ui, Tailwind CSS, Vite
- **Backend:** Python/FastAPI, PostgreSQL, Alembic, uv
- **AI Pipeline:** PyTorch, Blender Python API, text-to-3D service API
- **Payments:** Stripe (cards, Apple Pay, Google Pay, SEPA)
- **Infrastructure:** Docker, Kubernetes (microk8s), Traefik, GitHub Actions, Terraform
- **Shipping:** Zasilkovna (Czech/EU), DHL (international)

## Org Chart

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   ├── ML Engineer (3D Pipeline)
│   └── DevOps Engineer
├── CMO
│   └── Content Creator
└── Head of Operations
```

## Key Partners

- **MCAE (mcae.cz)** — Stratasys J55 PolyJet printing partner
- **Zasilkovna** — Czech/EU parcel delivery
- **DHL** — International shipping
- **Stripe** — Payment processing
