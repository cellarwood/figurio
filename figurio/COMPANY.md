---
name: Figurio
description: Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines from a curated catalog, AI-generated custom prompts, and (Phase 2) 3D body scans.
slug: figurio
schema: agentcompanies/v1
version: 1.0.0
goals:
  - Launch the Figurio web storefront with catalog browsing, cart, Stripe checkout, and order tracking
  - Build and validate the AI-prompted custom figurine pipeline (text-to-3D, mesh repair, preview, approval)
  - Establish production and fulfillment operations with MCAE, Zasilkovna, and DHL
  - Create brand identity and execute a launch campaign targeting Czech and EU markets
  - Achieve first 100 paid orders within 90 days of launch
---

# Figurio

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. The company operates through a web platform where customers can browse a curated catalog, generate custom models via AI text prompts, or (in a later phase) have themselves 3D-scanned to create personalized miniatures.

## Product Lines

### 1. Catalog Figurines ("Ready to Print")

A curated, rotating catalog of pre-designed 3D figurines available for immediate order. The catalog targets high-purchase-probability models: viral/meme-driven designs, seasonal figurines, event-driven designs, and evergreen collectibles. Models are sourced from commercially licensed marketplaces (CGTrader, TurboSquid), commissioned original designs from freelance 3D artists, and community/designer revenue-sharing partnerships. All models are pre-validated for printability.

### 2. AI-Prompted Custom Figurines ("Prompt to Print")

Customers describe a figurine in natural language, and the system generates a 3D model using AI (candidates: Meshy, Tripo3D, Luma Genie, CSM 3D). The pipeline includes automated mesh repair (NetFabb, Meshmixer, Blender scripting), human QA review, and rendered preview for customer approval. Two-stage payment: 50% deposit at order, 50% on preview approval. Turnaround: 10-15 business days.

### 3. 3D Scan-to-Print ("Scan Yourself") -- Phase 2

Mobile pop-up scanning operation using a portable photogrammetry rig at conventions, markets, and events. Target use cases: family portraits, cosplayers, wedding toppers, corporate gifts. Permanent retail studio as long-term goal once unit economics are validated.

## Production & Fulfillment

All printing is outsourced to MCAE (mcae.cz), a Czech-based Stratasys authorized partner, using the Stratasys J55 PolyJet printer. Three size tiers: Small (~8cm), Medium (~15cm), Large (~25cm). All orders are prepaid via Stripe. Shipping via Zasilkovna (Czech Republic) and DHL (international).

## Revenue Model

Direct product sales, all prepaid. Revenue levers include premium finish upsells, rush processing surcharges, gift wrapping add-ons, and volume discounts for B2B orders.

## Target Market

- Consumer: collectors, gift buyers, meme/internet culture enthusiasts, families, cosplayers
- B2B: corporate gifts, conference giveaways, branded mascots
- Geographic: Czech Republic first, EU expansion

## Key Risks

1. **IP infringement** -- mitigated by original/licensed-only catalog and AI prompt moderation
2. **AI model quality** -- mitigated by mesh repair pipeline and human QA
3. **Margin compression** -- mitigated by volume pricing with MCAE and future in-house printing
4. **Customer expectations** -- mitigated by 3D preview approval before printing
5. **Turnaround time** -- mitigated by artisanal framing and order tracking

## Tech Stack

- **Frontend:** React, TypeScript, shadcn-ui, Tailwind CSS, GSAP
- **Backend:** Python, FastAPI, Uvicorn
- **AI/ML:** PyTorch, Hugging Face, sentence-transformers
- **Payments:** Stripe
- **Infrastructure:** Docker, Kubernetes (GKE), Helm, Traefik, Terraform
- **Shipping:** Zasilkovna API, DHL API
- **Domain:** cellarwood.org
