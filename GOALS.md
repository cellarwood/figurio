---
goals:
  - slug: launch-storefront
    title: Launch the Figurio e-commerce storefront with catalog ordering and Stripe checkout
    description: Ship a working web store where customers can browse pre-designed figurines, select size tiers, pay via Stripe, and receive order confirmation with tracking
    level: company
    status: active
    ownerAgentSlug: cto
    projectSlugs: [storefront, infrastructure]
    subgoals:
      - slug: build-catalog-api
        title: Build product catalog API with Stripe checkout integration
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [storefront]
      - slug: build-storefront-ui
        title: Build storefront UI with product browsing, cart, and order tracking
        level: team
        ownerAgentSlug: frontend-engineer
        projectSlugs: [storefront]
      - slug: deploy-production
        title: Deploy storefront to production K8s cluster with CI/CD
        level: team
        ownerAgentSlug: devops-engineer
        projectSlugs: [infrastructure]

  - slug: build-ai-pipeline
    title: Build and validate the AI text-to-3D custom figurine pipeline end-to-end
    description: Evaluate text-to-3D services, build automated mesh repair, implement 2-stage payment flow, and process at least 5 test orders through MCAE
    level: company
    status: active
    ownerAgentSlug: cto
    projectSlugs: [ai-pipeline]
    subgoals:
      - slug: evaluate-3d-services
        title: Evaluate and select text-to-3D generation service
        level: team
        ownerAgentSlug: cto
        projectSlugs: [ai-pipeline]
      - slug: build-mesh-repair
        title: Build automated mesh repair pipeline for printability
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [ai-pipeline]
      - slug: build-custom-order-flow
        title: Build customer preview and 2-stage payment flow
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [ai-pipeline]

  - slug: acquire-first-customers
    title: Establish brand presence and acquire first 100 paying customers within 90 days of launch
    description: Build social media profiles, launch content marketing with product photography and behind-the-scenes content, drive initial sales through organic and influencer channels
    level: company
    status: active
    ownerAgentSlug: cmo
    projectSlugs: [marketing-launch]
    subgoals:
      - slug: build-brand-identity
        title: Create brand visual identity and product photography style guide
        level: team
        ownerAgentSlug: content-creator
        projectSlugs: [marketing-launch]
      - slug: launch-social-channels
        title: Launch Instagram and TikTok with 30-day content calendar
        level: team
        ownerAgentSlug: content-creator
        projectSlugs: [marketing-launch]
      - slug: run-influencer-campaign
        title: Plan and execute influencer seeding campaign in 3D printing and collectibles niches
        level: team
        ownerAgentSlug: cmo
        projectSlugs: [marketing-launch]

  - slug: setup-fulfillment
    title: Negotiate MCAE production terms and set up the full fulfillment pipeline
    description: Finalize per-unit pricing across all 3 size tiers, establish print file handoff process, set up shipping via Zasilkovna (CZ) and DHL (EU), achieve <10 business day turnaround for catalog orders
    level: company
    status: active
    ownerAgentSlug: head-of-operations
    projectSlugs: [operations-setup]
    subgoals:
      - slug: negotiate-mcae-pricing
        title: Negotiate per-unit pricing with MCAE across all size tiers
        level: team
        ownerAgentSlug: head-of-operations
        projectSlugs: [operations-setup]
      - slug: setup-shipping
        title: Set up Zasilkovna (CZ) and DHL (EU) shipping integrations
        level: team
        ownerAgentSlug: head-of-operations
        projectSlugs: [operations-setup]
---

# Figurio Goals

## Company-Level Goals

### 1. Launch Storefront
**Owner:** CTO | **Projects:** storefront, infrastructure | **Status:** Active

Ship a working web store where customers can browse pre-designed figurines, select size tiers, pay via Stripe, and receive order confirmation with tracking.

#### Team Subgoals
- **Build Catalog API** (backend-engineer) - Build product catalog API with Stripe checkout integration
- **Build Storefront UI** (frontend-engineer) - Build storefront UI with product browsing, cart, and order tracking
- **Deploy Production** (devops-engineer) - Deploy storefront to production K8s cluster with CI/CD

---

### 2. Build AI Pipeline
**Owner:** CTO | **Projects:** ai-pipeline | **Status:** Active

Evaluate text-to-3D services, build automated mesh repair, implement 2-stage payment flow, and process at least 5 test orders through MCAE.

#### Team Subgoals
- **Evaluate 3D Services** (cto) - Evaluate and select text-to-3D generation service
- **Build Mesh Repair** (backend-engineer) - Build automated mesh repair pipeline for printability
- **Build Custom Order Flow** (backend-engineer) - Build customer preview and 2-stage payment flow

---

### 3. Acquire First Customers
**Owner:** CMO | **Projects:** marketing-launch | **Status:** Active

Build social media profiles, launch content marketing with product photography and behind-the-scenes content, drive initial sales through organic and influencer channels.

#### Team Subgoals
- **Build Brand Identity** (content-creator) - Create brand visual identity and product photography style guide
- **Launch Social Channels** (content-creator) - Launch Instagram and TikTok with 30-day content calendar
- **Run Influencer Campaign** (cmo) - Plan and execute influencer seeding campaign in 3D printing and collectibles niches

---

### 4. Setup Fulfillment
**Owner:** Head of Operations | **Projects:** operations-setup | **Status:** Active

Finalize per-unit pricing across all 3 size tiers, establish print file handoff process, set up shipping via Zasilkovna (CZ) and DHL (EU), achieve <10 business day turnaround for catalog orders.

#### Team Subgoals
- **Negotiate MCAE Pricing** (head-of-operations) - Negotiate per-unit pricing with MCAE across all size tiers
- **Setup Shipping** (head-of-operations) - Set up Zasilkovna (CZ) and DHL (EU) shipping integrations
