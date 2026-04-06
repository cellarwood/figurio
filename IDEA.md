# FIGURIO — Comprehensive Company Description

**Confidential Business Document | April 2026**

---

## Company Overview

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. The company operates through a web platform where customers can browse a curated catalog, generate custom models via AI text prompts, or (in a later phase) have themselves 3D-scanned to create personalized miniatures.

All production is outsourced to a professional printing partner using best 
3D printing machines, we prefer mainly resin printing (ex. Stratasys J55 PolyJet technology), which produces smooth, full-color, detail-rich prints suitable for display-grade figurines. All orders are prepaid, ensuring zero cash-flow risk from unfulfilled orders.

---

## Core Product Lines

### 1 — Catalog Figurines ("Ready to Print")

A curated, rotating catalog of pre-designed 3D figurines available for immediate order. The catalog is strategically built around models with high purchase probability:

- Viral and meme-driven designs reflecting internet culture moments and trending characters
- Seasonal figurines for Christmas, Halloween, Valentine's Day, Easter, and other holidays
- Event-driven designs tied to sports events, elections, and cultural moments
- Evergreen collectibles spanning fantasy, sci-fi, animals, and pop-culture archetypes designed to avoid IP infringement

Models are sourced through three channels:

- **Commercially licensed models** purchased from marketplaces such as CGTrader and TurboSquid, with verified licenses for physical resale.
- **Commissioned original designs** created by freelance 3D artists hired through platforms like ArtStation, Fiverr, or direct contracts, producing IP-clean figurines fully owned by Figurio.
- **Community and designer partnerships,** working with independent 3D artists through revenue-sharing arrangements where Figurio handles production, sales, and fulfillment.

All catalog models are pre-validated for printability — manifold geometry, minimum wall thickness, support-structure compatibility — before being listed.

### 2 — AI-Prompted Custom Figurines ("Prompt to Print")

Customers describe a figurine in natural language through the website (e.g., "a steampunk cat riding a tiny bicycle"), and the system generates a 3D model using AI. The customer reviews a rendered preview, approves or requests adjustments, and upon approval the model enters the print queue.

#### Technical Pipeline

1. AI generation using a text-to-3D service (candidates include Meshy, Tripo3D, Luma Genie, CSM 3D, or a self-hosted model depending on quality and cost benchmarks)
2. Automated mesh repair using tools such as NetFabb, Meshmixer, or Blender scripting to fix non-manifold geometry, thin walls, floating artifacts, and topology issues
3. Human QA review by a trained 3D technician to verify printability and aesthetic quality
4. Rendered preview sent to the customer for approval; only after approval does the model enter the print queue

This product line requires careful expectation management. Turnaround will be longer (10–15 business days) and pricing higher due to the labor-intensive pipeline. A deposit-based payment model is recommended: 50% at order, remaining 50% upon preview approval.

### 3 — 3D Scan-to-Print Figurines ("Scan Yourself") — Phase 2

In a later phase, Figurio will offer customers the ability to have their bodies 3D-scanned and turned into personalized figurines. Target use cases include:

- Families wanting miniature portraits
- Cosplayers at conventions wanting figurines of their costumes
- Couples wanting wedding cake toppers or anniversary gifts
- Theater and performance groups wanting cast figurines
- Corporate clients wanting executive gifts or mascot figurines

This service will initially launch as a mobile pop-up operation using a portable photogrammetry rig (an array of 30–60 synchronized cameras or a structured-light scanner such as the Artec Leo). The rig can be deployed at comic conventions, Christmas markets, corporate events, festivals, and trade shows — testing demand and building brand awareness before committing to a permanent retail location.

A permanent retail scanning studio is the long-term goal once unit economics and local demand are validated.

---

## Production & Fulfillment

All printing is outsourced to **MCAE (mcae.cz)**, a Czech Republic-based Stratasys authorized partner, using the **Stratasys J55 PolyJet printer**. This machine produces full-color, multi-material prints with fine detail resolution, suitable for consumer-grade display figurines.

The customer never sees or interacts with MCAE. From the customer's perspective, Figurio designs, prints, and delivers the product.

### Size Tiers

| Size Tier | Approximate Height | Use Case |
|-----------|-------------------|----------|
| Small | ~8 cm | Desk figurines, keychains |
| Medium | ~15 cm | Display, gifts |
| Large | ~25 cm | Premium collectibles |

### Fulfillment Flow

1. Order placed and payment captured via Stripe
2. Print file prepared and sent to MCAE
3. MCAE prints and ships the finished product to Figurio (or directly to the customer if drop-ship is negotiated)
4. Customer receives the figurine with branded packaging

A critical early-stage task is to negotiate exact per-unit pricing with MCAE across all size tiers to establish margins before setting customer-facing prices.

---

## Pricing & Payment

All orders are prepaid. No production begins until payment is captured. Stripe is the sole payment processor, supporting credit/debit cards, Apple Pay, Google Pay, and EU-specific methods such as Bancontact, iDEAL, and SEPA Direct Debit.

### Cost Components

- Raw material and print time (quoted per model from MCAE)
- Model preparation labor (automated plus human QA, estimated at 15–30 minutes per custom model)
- Stripe transaction fees (approximately 2.9% + fixed fee per transaction, higher for international cards)
- Shipping and packaging
- Platform overhead (hosting, tooling, AI API costs)

For the AI-prompted custom line, a two-stage payment is recommended — 50% deposit at order, 50% on preview approval — to reduce refund exposure and align customer expectations.

### Future Pricing Levers

- Premium finish or pedestal upsell
- Rush processing surcharge
- Gift wrapping and personalization add-on
- Volume discounts for B2B and event orders

---

## Key Risks & Mitigations

### 1. Intellectual Property Infringement

**Risk:** Selling figurines resembling copyrighted characters (from Disney, Nintendo, Marvel, anime studios, etc.) without licensing is illegal and enforceable.

**Mitigation:** Build the catalog from original commissioned designs and verified commercially licensed models only. For AI-prompted models, implement content moderation to reject prompts requesting recognizable copyrighted characters. Consult a Czech/EU IP attorney before launch.

### 2. AI Model Quality and Printability

**Risk:** Current text-to-3D tools produce models that frequently require manual repair before printing.

**Mitigation:** Budget for a 3D technician role from day one, invest in automated mesh-repair tooling, and set realistic customer timelines.

### 3. Margin Compression from Outsourced Printing

**Risk:** Stratasys PolyJet materials are proprietary and expensive, and MCAE's margin sits on top.

**Mitigation:** Negotiate volume-based pricing, consider offering a lower-cost print tier using FDM or standard SLA for price-sensitive customers, and evaluate bringing printing in-house once order volume justifies the capital expenditure.

### 4. Customer Expectations for Custom Models

**Risk:** Customers may be disappointed by AI-generated results or expect photorealistic quality.

**Mitigation:** Always show a 3D-rendered preview before printing, use the deposit model to reduce financial friction from rejections, and maintain a clear refund/revision policy.

### 5. Turnaround Time

**Risk:** Outsourced printing plus shipping creates a multi-week delivery window.

**Mitigation:** Frame the product as artisanal/custom (not fast commerce), provide an order tracker, and consider stocking popular catalog items in pre-printed inventory for faster shipping.

---

## Strategy Research Required

Before finalizing the go-to-market approach, a structured strategy research phase is required to determine the optimal path across several dimensions:

- Market positioning: premium artisan brand vs. accessible mass-market product vs. hybrid tiered approach
- Catalog strategy: breadth (many categories) vs. depth (few categories, many designs per category) vs. trend-chasing agility
- AI model sourcing: third-party API (faster launch, less control) vs. self-hosted model (higher upfront cost, better margins and quality long-term)
- Printing partner model: exclusive MCAE partnership vs. multi-vendor supply chain vs. timeline for in-house acquisition
- Geographic launch strategy: Czech Republic first with EU expansion vs. pan-EU launch from day one
- Customer acquisition: organic/social-first vs. paid acquisition vs. event/pop-up-first brand building
- IP strategy: fully original catalog only vs. licensing partnerships with select IP holders

This research should include competitive landscape analysis, customer interviews or surveys, pricing sensitivity testing, and financial modeling across scenarios before committing to a single strategy.

---

## Growth Opportunities

### Gift and Occasion Market

Figurines are inherently personal and giftable. Dedicated seasonal campaigns (Valentine's couples, Mother's Day family portraits, Christmas ornaments, wedding toppers) with themed packaging and engraving options could drive significant revenue spikes.

### B2B and Corporate Sales

Companies may order branded mascot figurines, executive gifts, conference giveaways, employee awards, or architectural/product models. This segment offers higher average order values, repeat ordering, and lower customer acquisition cost.

### Subscription and Limited Editions

A monthly or quarterly subscription box containing a limited-edition numbered figurine creates recurring revenue, community, and collector urgency. Themes rotate monthly.

### Social Commerce Loop

The product is inherently photogenic and shareable. A referral program, user-generated content incentives (discount for posting on Instagram/TikTok), and influencer seeding can drive organic growth at low cost.

### Event Pop-Ups and Partnerships

Comic-con booths, gaming expos, Christmas markets, and festival stands serve as both revenue channels and brand-building opportunities — especially for the scan-to-print service.

### In-House Printing

Once order volume reaches a threshold that justifies the capital investment, purchasing or leasing a Stratasys J55 (or comparable machine) would dramatically improve margins, turnaround time, and quality control. This is a natural Phase 3 milestone.

### International Expansion

The e-commerce model is geography-agnostic within the EU. Localized storefronts, multilingual support, and regional shipping partners can scale the business across Europe with minimal operational changes.

### Platform / Marketplace Evolution

Long-term, Figurio could evolve into a marketplace where independent 3D artists upload and sell their designs through Figurio's production and fulfillment pipeline — similar to how Redbubble or Society6 operate for 2D print-on-demand.

---

## Technology Stack

### Frontend & UI

**Language:** TypeScript with strict mode enabled

- Package Manager: `npm`
- Runtime: Node.js
- Framework: React
- UI Components: shadcn-ui (ui.shadcn.com), Radix UI primitives
- Charts: lightweight-charts (TradingView)
- Styling: Tailwind CSS
- Animation: GSAP (advanced) or CSS (simpler use cases)

### Backend

**Primary language:** Python

- **CRITICAL:** Use `uv` exclusively for package management — never `pip` directly
- Virtual Environment: `uv venv` followed by `source .venv/bin/activate`
- Dependency Management: `uv sync`
- API Framework: FastAPI with Uvicorn
- Type Hints: Python 3.10+ syntax consistently

**Secondary (Node.js):** Used only when justified; Express.js for API, esbuild for bundling.

**Tertiary (Go):** Used only for performance-critical services or system tools.

### AI & Machine Learning

- ML/DL Framework: PyTorch (primary; avoid TensorFlow)
- Model Hub: Hugging Face for pretrained models
- Embeddings: sentence-transformers
- Agent Development: Claude Agent SDK (preferred) or LangChain >= 1.0.0 + LangGraph >= 1.0.0 as alternative

### Infrastructure & DevOps

- **Containerization:** Docker with multi-stage builds for minimal image sizes
- **Orchestration:** Kubernetes via Google Kubernetes Engine (GKE), Helm for resource templating
- **Infrastructure as Code:** Terraform for cloud resources, version-controlled, modular
- **Networking:** Traefik as ingress/reverse proxy

### Scripting & Automation

- Default: Python for all scripts
- Avoid: Bash/Shell scripts (unless trivial one-liners), PowerShell
- All scripts should be simple, documented, and testable

### Operating System

- Primary: Linux (Ubuntu LTS preferred)
- Containers: Alpine or distroless for production images
- Windows only when specifically required

---

## Summary

Figurio is a consumer 3D-printing company that combines trend-driven curation, AI-powered customization, and premium PolyJet production to deliver a product category that is emotionally resonant, highly giftable, and inherently shareable.

The prepaid model eliminates cash-flow risk, the outsourced production model keeps capital requirements low at launch, and the phased roadmap — catalog → AI custom → scan-to-print → in-house production → marketplace — provides a clear growth trajectory from lean startup to scaled platform.

A structured strategy research phase will precede final go-to-market decisions, ensuring that positioning, pricing, sourcing, and geographic expansion are data-driven rather than assumption-based.