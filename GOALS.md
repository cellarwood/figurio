---
schema: agentcompanies/v1
---

goals:
  - slug: launch-storefront
    title: Launch the Figurio e-commerce storefront with catalog browsing, size selection, Stripe checkout, and order tracking
    description: Ship a production-ready web storefront where customers can browse the figurine catalog, select sizes, pay via Stripe (cards, Apple Pay, Google Pay, SEPA), and track their orders from placement to delivery.
    level: company
    status: active
    ownerAgentSlug: cto
    projectSlugs: [storefront]
    subgoals:
      - slug: build-catalog-frontend
        title: Build catalog browsing UI with filtering, search, and 3D model viewer
        level: team
        ownerAgentSlug: frontend-engineer
        projectSlugs: [storefront]
      - slug: build-checkout-api
        title: Implement Stripe checkout with multi-currency and EU payment methods
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [storefront]
      - slug: build-order-management
        title: Build order management API with status tracking and customer notifications
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [storefront]

  - slug: build-ai-pipeline
    title: Build the AI Prompt-to-Print pipeline integrating text-to-3D generation, mesh repair, QA preview, and customer approval
    description: Deliver an end-to-end pipeline where customers enter a text prompt, an AI generates a 3D model, automated tooling repairs the mesh for printability, a QA technician validates quality, and the customer approves a rendered preview before the model enters the print queue. Two-stage payment (50% deposit, 50% on approval).
    level: company
    status: active
    ownerAgentSlug: cto
    projectSlugs: [ai-pipeline]
    subgoals:
      - slug: integrate-text-to-3d
        title: Integrate text-to-3D API (Meshy/Tripo3D) with prompt intake and model generation
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [ai-pipeline]
      - slug: build-mesh-repair
        title: Build automated mesh repair pipeline using Blender scripting
        level: team
        ownerAgentSlug: backend-engineer
        projectSlugs: [ai-pipeline]
      - slug: build-preview-flow
        title: Create customer preview and approval flow with 3D render viewer
        level: team
        ownerAgentSlug: frontend-engineer
        projectSlugs: [ai-pipeline]

  - slug: establish-mcae-partnership
    title: Establish the MCAE production partnership with negotiated per-unit pricing and a validated order-to-delivery workflow
    description: Negotiate pricing with MCAE across all three size tiers, define the order-to-delivery SOP, specify branded packaging requirements, and integrate shipping via Zasilkovna and DHL.
    level: company
    status: active
    ownerAgentSlug: head-of-operations
    projectSlugs: [production-ops]
    subgoals:
      - slug: negotiate-pricing
        title: Negotiate per-unit pricing with MCAE across Small, Medium, and Large tiers
        level: team
        ownerAgentSlug: head-of-operations
        projectSlugs: [production-ops]
      - slug: define-fulfillment-sop
        title: Define end-to-end order-to-delivery workflow and shipping integration
        level: team
        ownerAgentSlug: head-of-operations
        projectSlugs: [production-ops]

  - slug: build-content-engine
    title: Build a content marketing engine producing product photography, social media content, and SEO blog posts
    description: Establish Figurio's brand identity, create a content pipeline for Instagram/TikTok, produce SEO-optimized blog content, and build product photography workflows — all before and through launch.
    level: company
    status: active
    ownerAgentSlug: cmo
    projectSlugs: [marketing-launch]
    subgoals:
      - slug: establish-brand-identity
        title: Create brand identity guidelines and visual language for Figurio
        level: team
        ownerAgentSlug: content-creator
        projectSlugs: [marketing-launch]
      - slug: launch-content-pipeline
        title: Launch social media profiles, content calendar, and 5 seed blog posts
        level: team
        ownerAgentSlug: content-creator
        projectSlugs: [marketing-launch]

  - slug: deploy-infrastructure
    title: Deploy CI/CD infrastructure with automated testing, Docker builds, and Kubernetes deployment to microk8s-local
    description: Set up the monorepo, Docker multi-stage builds, Helm charts for microk8s-local, and GitHub Actions pipelines for continuous integration and deployment with zero-downtime deploys.
    level: company
    status: active
    ownerAgentSlug: devops-engineer
    projectSlugs: [infrastructure]
    subgoals:
      - slug: setup-monorepo-docker
        title: Set up monorepo structure with Docker multi-stage builds for all services
        level: team
        ownerAgentSlug: devops-engineer
        projectSlugs: [infrastructure]
      - slug: setup-k8s-cicd
        title: Configure Kubernetes namespaces, Helm charts, and GitHub Actions CI/CD
        level: team
        ownerAgentSlug: devops-engineer
        projectSlugs: [infrastructure]
