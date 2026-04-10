---
schema: agentcompanies/v1
name: Figurio
slug: figurio
version: 1.0.0
goals:
  - Launch MVP e-commerce platform with catalog browsing, Stripe payments, and order tracking
  - Build AI-powered custom figurine pipeline (Prompt to Print)
  - Establish Figurio brand and acquire first 500 customers
  - Operationalize production and fulfillment with MCAE and shipping partners
  - Validate unit economics and establish path to profitability
---

# Figurio

Figurio is a direct-to-consumer e-commerce company headquartered in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines.

## Product Lines

### Catalog Figurines ("Ready to Print")
A curated, rotating catalog of pre-designed 3D figurines — viral/meme-driven designs, seasonal figurines, event-driven designs, and evergreen collectibles. Models sourced from commercially licensed marketplaces, commissioned original designs, and community partnerships.

### AI-Prompted Custom Figurines ("Prompt to Print")
Customers describe a figurine in natural language, the system generates a 3D model using AI (text-to-3D), the customer reviews a rendered preview, and upon approval the model enters the print queue. Two-stage payment: 50% deposit at order, 50% on preview approval.

### 3D Scan-to-Print ("Scan Yourself") — Phase 2
Mobile pop-up photogrammetry scanning at conventions, markets, and events. Personalized figurines from real people.

## Production

All printing outsourced to **MCAE** (mcae.cz), a Czech Stratasys authorized partner, using the **Stratasys J55 PolyJet** printer. Three size tiers: small (~8cm), medium (~15cm), large (~25cm). All orders are prepaid via Stripe.

## Tech Stack

- **Frontend:** React/TypeScript, shadcn-ui, Tailwind CSS, Vite
- **Backend:** Python/FastAPI, PostgreSQL, Stripe SDK, uv
- **Infrastructure:** Docker, Kubernetes (microk8s), Traefik, GitHub Actions, Sentry
- **AI:** Text-to-3D APIs (Meshy, Tripo3D), automated mesh repair

## Infrastructure

- **GitHub:** github.com/cellarwood/figurio
- **Docker Hub:** lukekelle00
- **Kubernetes:** microk8s-local
- **Payments:** Stripe
- **Slack:** 00aiworkspace.slack.com
- **Google Workspace:** cellarwood.org
