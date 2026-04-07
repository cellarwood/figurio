---
name: Figurio
description: Direct-to-consumer e-commerce company designing, producing, and delivering high-quality full-color 3D-printed figurines from a curated catalog and AI-powered custom prompts
slug: figurio
schema: agentcompanies/v1
version: 1.0.0
goals:
  - Launch the Figurio e-commerce storefront with catalog browsing, size selection, Stripe checkout, and order tracking
  - Build the AI Prompt-to-Print pipeline integrating text-to-3D generation, mesh repair, QA preview, and customer approval
  - Establish the MCAE production partnership with negotiated per-unit pricing and a validated order-to-delivery workflow
  - Build a content marketing engine producing product photography, social media content, and SEO blog posts
  - Deploy CI/CD infrastructure with automated testing, Docker builds, and Kubernetes deployment to microk8s-local
---

# Figurio

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. Customers can browse a curated catalog of pre-designed figurines or generate custom models via AI text prompts through the "Prompt to Print" feature.

All production is outsourced to MCAE (mcae.cz), a Czech Stratasys authorized partner using the Stratasys J55 PolyJet printer for smooth, full-color, detail-rich prints. All orders are prepaid via Stripe, ensuring zero cash-flow risk.

## Product Lines

### Catalog Figurines ("Ready to Print")
A curated, rotating catalog of pre-designed 3D figurines — viral/meme designs, seasonal figurines, event-driven designs, and evergreen collectibles. Models sourced from commercial licenses, commissioned originals, and designer partnerships.

### AI-Prompted Custom Figurines ("Prompt to Print")
Customers describe a figurine in natural language, the system generates a 3D model via AI, automated mesh repair prepares it for print, a human QA review validates quality, and the customer approves a rendered preview before production begins. Two-stage payment: 50% deposit, 50% on approval.

## Size Tiers

| Tier | Height | Use Case |
|------|--------|----------|
| Small | ~8 cm | Desk figurines, keychains |
| Medium | ~15 cm | Display, gifts |
| Large | ~25 cm | Premium collectibles |

## Domain

figurio.cellarwood.org
