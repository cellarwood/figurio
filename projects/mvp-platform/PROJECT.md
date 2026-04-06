---
name: MVP Platform
description: Build the core Figurio e-commerce platform with catalog browsing, AI-custom figurines, Stripe checkout, and order management
slug: mvp-platform
owner: cto
---

## Scope

Build and deploy the Figurio web platform with two product flows:

1. **Catalog figurines** — browse, filter, select size, add to cart, checkout via Stripe
2. **AI-custom figurines** — enter text prompt, generate 3D model, preview, approve, pay 50% deposit + 50% on approval

Supporting systems:
- Product catalog API and database
- Stripe payment integration (standard checkout + 2-stage deposits)
- AI text-to-3D pipeline (API integration, mesh repair, preview rendering)
- Customer accounts (registration, login, order history)
- Order management (status tracking, MCAE print-file delivery)

## Success Criteria

- Both product flows working end-to-end (browse → pay → order confirmed)
- AI-custom flow producing viewable 3D previews from text prompts
- Stripe handling standard and deposit-based payments with webhook processing
- Customer can track order status from account page
- API documented with OpenAPI spec

## Workspace

This project targets the main application repository at `github.com/cellarwood/figurio`.
