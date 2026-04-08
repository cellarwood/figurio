---
name: Figurio
description: Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines via catalog, AI-prompted custom, and future scan-to-print services
slug: figurio
schema: agentcompanies/v1
version: 1.0.0
goals:
  - Launch the Figurio e-commerce storefront with catalog ordering and Stripe checkout
  - Build and validate the AI text-to-3D custom figurine pipeline end-to-end
  - Establish brand presence and acquire first 100 paying customers within 90 days of launch
  - Negotiate MCAE production terms and set up the full fulfillment pipeline
---

# Figurio

## Company Overview

Figurio is a direct-to-consumer e-commerce company based in the Czech Republic that designs, produces, and delivers high-quality full-color 3D-printed figurines. All production is outsourced to MCAE (mcae.cz), a professional 3D printing bureau operating Stratasys J55 PolyJet technology, which enables photorealistic full-color prints with fine detail and smooth surface finish.

## Product Lines

### Catalog - "Ready to Print"
Pre-designed figurine collection available for immediate ordering. Customers browse the catalog, select a design and size tier, and check out. Print files are already prepared and validated, enabling the fastest turnaround times.

### AI-Prompted Custom - "Prompt to Print"
Customers describe their desired figurine via text prompt. An AI text-to-3D generation pipeline produces a custom model, which goes through automated mesh repair for printability. Customers preview the result and approve before final payment and production.

### Scan-to-Print - "Scan Yourself" (Future)
A future product line allowing customers to upload 3D scans of themselves or objects to be turned into figurines. This service will combine photogrammetry processing with the existing mesh repair and production pipeline.

## Size Tiers

| Tier   | Approximate Height | Description                        |
|--------|--------------------|------------------------------------|
| Small  | ~8 cm              | Desk-friendly, collectible size    |
| Medium | ~15 cm             | Standard display figurine          |
| Large  | ~25 cm             | Premium showcase piece             |

## Production Partner

**MCAE** (mcae.cz) - Professional 3D printing and additive manufacturing bureau based in the Czech Republic. Figurio leverages their **Stratasys J55 PolyJet** printer, which delivers full-color, multi-material prints with over 500,000 color combinations and fine detail resolution suitable for consumer figurines.

## Payments

All payments are processed through **Stripe**. Orders are fully prepaid before production begins. The AI-Prompted Custom product line uses a 2-stage payment flow: an initial deposit to generate and preview the model, followed by full payment upon customer approval before production starts.

## Tech Stack

- **Frontend:** React with TypeScript
- **Backend:** Python with FastAPI
- **Infrastructure:** Docker containers orchestrated on Kubernetes (K8s)
- **Payments:** Stripe
- **CI/CD:** Automated deployment pipelines

## Team

Figurio operates with a team of 8 specialized agents:

| Role                | Slug                | Responsibility                                              |
|---------------------|---------------------|-------------------------------------------------------------|
| CEO                 | ceo                 | Company strategy, vision, and cross-functional coordination |
| CTO                 | cto                 | Technical architecture, AI pipeline, and engineering leadership |
| CMO                 | cmo                 | Marketing strategy, customer acquisition, and brand growth  |
| Head of Operations  | head-of-operations  | Production partner relations, fulfillment, and shipping     |
| Backend Engineer    | backend-engineer    | API development, payment integration, and mesh processing   |
| Frontend Engineer   | frontend-engineer   | Storefront UI, customer experience, and order tracking      |
| Content Creator     | content-creator     | Product photography, social media content, and brand visuals |
| DevOps Engineer     | devops-engineer     | Infrastructure, CI/CD, monitoring, and deployment           |
