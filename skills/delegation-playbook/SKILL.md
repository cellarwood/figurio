---
name: delegation-playbook
description: CEO delegation routing rules for Figurio — which agent handles what, escalation paths, and task formatting for the 8-agent org.
---

# Delegation Playbook

## Purpose

Define clear routing rules for the Figurio CEO to delegate tasks to the correct agent. Every task must reach the right owner on the first assignment — no bouncing between agents.

## Org Structure

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   └── DevOps Engineer
├── CMO
│   └── Content Creator
└── Head of Operations
```

## Routing Table

### CTO — Engineering & Architecture

**Direct responsibilities:**
- System architecture decisions and ADRs.
- Technology selection and evaluation.
- Engineering standards and code review policies.
- AI pipeline architecture (text-to-3D, mesh repair).
- Security reviews and compliance.

**Delegates to sub-agents:**
- Backend Engineer: API development, database, payment integration.
- Frontend Engineer: Storefront UI, 3D viewer, checkout flow.
- DevOps Engineer: Infrastructure, CI/CD, deployments.

**Route to CTO when:** The task involves technical decisions, cross-cutting engineering concerns, or coordination between engineering sub-agents.

### CMO — Marketing & Brand

**Direct responsibilities:**
- Marketing strategy and campaign planning.
- Brand positioning and voice guidelines.
- Channel strategy (Instagram, TikTok, SEO, email).
- Analytics and conversion optimization.
- Influencer partnerships and outreach strategy.

**Delegates to sub-agents:**
- Content Creator: Blog posts, social media content, product descriptions, email copy.

**Route to CMO when:** The task involves marketing strategy, brand decisions, audience targeting, or campaign coordination.

### Head of Operations — Vendors & Fulfillment

**Direct responsibilities:**
- MCAE vendor relationship and print ordering.
- Shipping provider management (Zasilkovna, DHL).
- Order fulfillment pipeline oversight.
- Quality assurance processes for received prints.
- Packaging and unboxing experience.
- Inventory planning and seasonal demand preparation.
- Supplier negotiations and cost optimization.

**Route to Head of Operations when:** The task involves physical goods, vendors, shipping, packaging, fulfillment, or supply chain.

### Backend Engineer (via CTO)

- FastAPI endpoint development and maintenance.
- PostgreSQL database schema and migrations.
- Stripe payment integration and webhook handling.
- Order processing logic and state machines.
- AI pipeline API integration (text-to-3D service calls).
- Authentication and authorization.

### Frontend Engineer (via CTO)

- React/TypeScript storefront development.
- Three.js / React Three Fiber 3D model viewer.
- Product catalog UI and filtering.
- Checkout flow and cart management.
- Responsive design and mobile optimization.
- shadcn-ui component library customization.

### DevOps Engineer (via CTO)

- Docker image builds and Docker Hub pushes.
- Helm chart management for microk8s-local cluster.
- CI/CD pipeline configuration.
- Monitoring, logging, and alerting.
- SSL certificates and domain management.
- Environment management (dev/staging/prod).

### Content Creator (via CMO)

- Blog post writing and SEO optimization.
- Social media content creation (Instagram, TikTok).
- Product description copywriting.
- Email newsletter content.
- Photography direction for figurine shots.

## Task Format Requirements

Every delegated task must include:

```
## Task: [Clear action-oriented title]

**Owner:** [Agent name]
**Priority:** P1 (urgent) | P2 (this sprint) | P3 (backlog)
**Due:** [Date or sprint]

### Context
Why this task matters and what triggered it.

### Requirements
- [ ] Specific deliverable 1
- [ ] Specific deliverable 2
- [ ] Acceptance criteria

### Dependencies
List any blockers or inputs needed from other agents.

### Definition of Done
What "complete" looks like for this task.
```

## Escalation Paths

### From sub-agent to direct report
- Backend/Frontend/DevOps Engineer escalates to CTO.
- Content Creator escalates to CMO.

### From direct report to CEO
- CTO escalates: cross-functional conflicts, budget requests > planned, security incidents.
- CMO escalates: brand-damaging situations, budget reallocation, partnership approvals.
- Head of Operations escalates: vendor failures, fulfillment delays > 5 days, quality crises.

### Automatic CEO involvement
- Any decision affecting pricing or revenue model.
- Vendor contracts or commitments > 3 months.
- Customer complaints that reach social media.
- System outages lasting > 1 hour.
- Any legal or compliance concern.

## When NOT to Delegate

The CEO handles directly:
- Strategic planning and company direction.
- Cross-functional prioritization conflicts.
- Budget allocation between departments.
- External partnerships and investor relations.
- Final approval on pricing changes.
- Hiring decisions for new agent roles.
