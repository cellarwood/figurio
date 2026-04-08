---
goals:
  - slug: launch-storefront
    title: Launch the Figurio e-commerce storefront with catalog ordering and Stripe checkout
    description: Ship a fully functional web storefront where customers can browse the figurine catalog, select size tiers, and complete purchases via Stripe. Includes product pages, cart, checkout, order confirmation, and admin order management.
    level: company
    status: active
    ownerAgentSlug: cto
    projectSlugs: [storefront]
    subgoals:
      - slug: build-catalog-api
        title: Build catalog API with product management and order processing
        description: REST API for figurine catalog CRUD, size tier pricing, inventory status, and order lifecycle management with Stripe payment capture
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [storefront]
      - slug: build-storefront-ui
        title: Build storefront UI with catalog browsing and checkout flow
        description: React storefront with product grid, detail pages, size selector, shopping cart, Stripe checkout, and order confirmation
        level: team
        ownerAgentSlug: frontend-engineer
        projectSlugs: [storefront]
      - slug: deploy-storefront
        title: Deploy storefront infrastructure with CI/CD
        description: Docker images, Kubernetes manifests, Traefik ingress, and GitHub Actions pipeline for automated builds and deployments
        level: team
        ownerAgentSlug: devops-engineer
        projectSlugs: [infrastructure]

  - slug: build-ai-pipeline
    title: Build and validate the AI text-to-3D custom figurine pipeline end-to-end
    description: Implement the full Prompt-to-Print pipeline from customer text input through AI 3D model generation, automated mesh repair, human QA review, customer preview approval, and handoff to production. Validate output quality meets print standards.
    level: company
    status: active
    ownerAgentSlug: cto
    projectSlugs: [ai-pipeline]
    subgoals:
      - slug: integrate-text-to-3d
        title: Integrate text-to-3D generation service
        description: Evaluate and integrate a text-to-3D API (Meshy, Tripo3D, or Luma Genie), build the prompt submission endpoint, and handle async model generation with status polling
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [ai-pipeline]
      - slug: build-mesh-repair
        title: Build automated mesh repair pipeline
        description: Automated pipeline using Blender scripting or NetFabb to fix non-manifold geometry, thin walls, floating artifacts, and topology issues on AI-generated models
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [ai-pipeline]
      - slug: build-preview-approval-flow
        title: Build customer preview and approval UI
        description: 3D model viewer for customers to inspect their generated figurine, request revisions, and approve for production. Triggers second-stage Stripe payment on approval.
        level: team
        ownerAgentSlug: frontend-engineer
        projectSlugs: [ai-pipeline]

  - slug: acquire-customers
    title: Acquire first 100 paying customers within 90 days of launch
    description: Drive initial customer acquisition through social media content, influencer seeding, and organic search. Build brand awareness in the 3D printing and figurine collector communities.
    level: company
    status: active
    ownerAgentSlug: cmo
    projectSlugs: [storefront]
    subgoals:
      - slug: build-brand-presence
        title: Establish brand identity and social media presence
        description: Create Figurio visual identity, set up social media profiles (Instagram, TikTok), produce launch content showcasing figurine quality and customization capabilities
        level: team
        ownerAgentSlug: content-creator
      - slug: launch-marketing-campaign
        title: Plan and execute launch marketing campaign
        description: Content calendar, influencer outreach to 3D printing and figurine communities, product seeding, and paid social ads targeting collectors and gift buyers
        level: team
        ownerAgentSlug: cmo

  - slug: setup-fulfillment
    title: Negotiate MCAE production terms and set up the full fulfillment pipeline
    description: Establish per-unit pricing with MCAE across all size tiers, set up the order-to-shipment workflow, integrate Zasilkovna for domestic shipping, and define SLAs for production turnaround.
    level: company
    status: active
    ownerAgentSlug: head-of-operations
    subgoals:
      - slug: negotiate-mcae-terms
        title: Negotiate MCAE pricing and production SLAs
        description: Obtain per-unit pricing for Small/Medium/Large tiers, negotiate volume discounts, agree on turnaround times, and establish a print file submission workflow
        level: team
        ownerAgentSlug: head-of-operations
      - slug: setup-shipping
        title: Set up Zasilkovna shipping integration
        description: Configure Zasilkovna API for domestic Czech Republic shipping, set up label generation, tracking, and pickup point selection for customers
        level: team
        ownerAgentSlug: head-of-operations
---
