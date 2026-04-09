---
name: Figurio
description: Direct-to-consumer e-commerce company designing, producing, and delivering high-quality full-color 3D-printed figurines via a web platform with catalog browsing, AI-prompted custom models, and outsourced PolyJet production.
slug: figurio
schema: agentcompanies/v1
version: 1.0.0
goals:
  - Launch MVP e-commerce storefront with catalog browsing, Stripe checkout, and order management
  - Build AI text-to-3D figurine pipeline with automated mesh repair and customer preview approval
  - Establish Figurio brand identity and social media presence with initial content strategy
  - Formalize MCAE printing partnership with per-unit pricing, SLAs, and fulfillment workflow
---

# Figurio

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. The company operates through a web platform where customers browse a curated catalog, generate custom models via AI text prompts, or (in a later phase) have themselves 3D-scanned to create personalized miniatures.

All production is outsourced to MCAE (mcae.cz), a Czech Republic-based Stratasys authorized partner, using the Stratasys J55 PolyJet printer for smooth, full-color, detail-rich prints. All orders are prepaid via Stripe, ensuring zero cash-flow risk.

## Product Lines

1. **Catalog Figurines ("Ready to Print")** — curated, rotating catalog of pre-designed figurines: viral/meme designs, seasonal collections, event-driven designs, and evergreen collectibles.
2. **AI-Prompted Custom Figurines ("Prompt to Print")** — customers describe a figurine in natural language, AI generates a 3D model, automated mesh repair ensures printability, and the customer approves a rendered preview before printing.
3. **3D Scan-to-Print ("Scan Yourself")** — Phase 2: personalized figurines from photogrammetry scans at pop-up events and eventually a permanent studio.

## Size Tiers

| Tier | Height | Use Case |
|------|--------|----------|
| Small | ~8 cm | Desk figurines, keychains |
| Medium | ~15 cm | Display, gifts |
| Large | ~25 cm | Premium collectibles |

## Key Infrastructure

- **Domain:** cellarwood.org
- **GitHub:** github.com/cellarwood/figurio
- **Docker Hub:** lukekelle00
- **Slack:** 00aiworkspace.slack.com
- **Stripe:** Cellarwood account
- **K8s:** microk8s-local
- **Google Workspace:** info@cellarwood.org
