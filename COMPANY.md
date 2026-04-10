---
schema: agentcompanies/v1
kind: company
name: Figurio
slug: figurio
version: 1.0.0
description: Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines from a curated catalog and AI-generated custom designs.
license: MIT
authors:
  - name: Cellarwood
goals:
  - Launch the Figurio e-commerce platform with product catalog, cart, Stripe checkout, and order tracking
  - Launch AI custom figurine pipeline enabling text-prompt-to-3D-print workflow with customer preview and approval
  - Build brand presence across Instagram and TikTok and acquire first paying customers in Czech Republic
  - Establish reliable end-to-end fulfillment operations via MCAE printing and Zásilkovna shipping
metadata:
  domain: cellarwood.org
  region: Czech Republic
  industry: e-commerce, 3D printing, consumer goods
sources:
  - type: github
    url: https://github.com/cellarwood/figurio
---

# Figurio

Figurio is a direct-to-consumer e-commerce company based in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. The company operates through a web platform offering two product lines:

**Catalog Figurines ("Ready to Print")** — A curated, rotating catalog of pre-designed 3D figurines built around viral/meme-driven designs, seasonal themes (Christmas, Halloween, Valentine's Day), event-driven designs, and evergreen collectibles. Models are sourced through commercial licenses, commissioned original designs, and designer partnerships.

**AI-Prompted Custom Figurines ("Prompt to Print")** — Customers describe a figurine in natural language, the system generates a 3D model using AI, the customer reviews a rendered preview, and upon approval the model enters the print queue. Two-stage payment: 50% deposit at order, 50% on preview approval.

## Production

All printing is outsourced to **MCAE** (mcae.cz), a Czech Stratasys authorized partner, using the **Stratasys J55 PolyJet** printer for full-color, multi-material prints. Three size tiers: Small (~8cm), Medium (~15cm), Large (~25cm). All orders are prepaid via Stripe. Shipping via Zásilkovna.

## Tech Stack

- **Frontend:** React/TypeScript, shadcn-ui, Tailwind CSS, GSAP
- **Backend:** Python/FastAPI, PostgreSQL, Stripe SDK, Zásilkovna API
- **AI Pipeline:** PyTorch, text-to-3D APIs (Meshy/Tripo3D/Luma), Blender scripting for mesh repair
- **Infrastructure:** Docker, Kubernetes (microk8s/GKE), Helm, Terraform, Traefik, GitHub Actions

## Team

| Agent | Role | Reports To |
|-------|------|------------|
| CEO | Chief Executive Officer | — |
| CTO | Chief Technology Officer | CEO |
| Backend Engineer | Backend Engineer | CTO |
| Frontend Engineer | Frontend Engineer | CTO |
| ML/AI Engineer | ML/AI Engineer | CTO |
| DevOps Engineer | DevOps Engineer | CTO |
| CMO | Chief Marketing Officer | CEO |
| Content Creator | Content Creator | CMO |
| Head of Operations | Head of Operations | CEO |
