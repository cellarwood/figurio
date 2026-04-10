---
name: tech-decisions
description: >
  Framework for build-vs-buy decisions, tech stack evaluations, and vendor selection
  for Figurio — covering AI 3D generation APIs (Prompt to Print pipeline), print
  partners beyond MCAE, and infrastructure/tooling choices within the React/FastAPI/K8s stack.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - architecture
      - vendor
---

# Tech Decisions

## When to Use

Invoke this skill when evaluating:
- Whether to build a capability in-house or buy/integrate a third-party service
- New AI 3D generation APIs or model providers for the Prompt to Print pipeline
- Alternative or additional print partners (beyond MCAE)
- Infrastructure tooling (queues, observability, storage, CDN)
- Frontend or backend library additions

## Decision Framework

Every significant tech decision at Figurio follows this structure:

### 1. Define the Problem Scope

State precisely what is needed, not what solution is assumed. Example: "We need geometry validation for AI-generated models before sending to MCAE" — not "We need to evaluate Blender vs. Trimesh."

### 2. Build vs. Buy Criteria

| Factor | Build | Buy / Integrate |
|--------|-------|-----------------|
| Core IP | Logic that is our competitive differentiator | Generic infrastructure (auth, email, payments) |
| Maintenance cost | Team has deep domain expertise | Ongoing updates are low-value distraction |
| Time to market | Acceptable delay | Urgent launch requirement |
| Vendor lock-in risk | High risk to core pipeline | Swappable via adapter layer |
| Volume/cost | SaaS pricing exceeds build cost at our scale | Build cost exceeds SaaS at our scale |

**Figurio defaults to buy for**: payments (Stripe), shipping logistics (Zásilkovna), transactional email, observability (Datadog/Grafana), CDN.

**Figurio defaults to build for**: 3D model post-processing logic, order state machine, print job orchestration, customer-facing UI.

**Evaluate carefully (neither default)**: AI 3D generation APIs, new print partners, 3D preview rendering.

### 3. Evaluation Dimensions

For each candidate option, score on:

- **Quality of output** — does it meet the bar for Figurio figurine fidelity?
- **API maturity** — REST/gRPC with versioning, not beta-only
- **Pricing model** — per-generation vs. per-seat vs. volume tiers; model at 1k, 10k, 100k orders/month
- **Data residency** — EU data residency required (Czech Republic, GDPR)
- **SLA / uptime** — minimum 99.5% for anything in the checkout or print path
- **Integration effort** — estimate days to production-ready adapter, not just proof-of-concept
- **Exit cost** — how hard is it to swap this vendor if needed in 12 months?

### 4. Decision Record Format

Every decision with > 1 week implementation effort or > €500/month expected cost gets a written record:

```
## Decision: [short title]
Date: YYYY-MM-DD
Status: proposed | accepted | superseded

### Context
[Why are we making this decision now?]

### Options Considered
1. [Option A] — [one-line summary]
2. [Option B] — [one-line summary]

### Decision
[Which option, and the primary reason]

### Trade-offs Accepted
[What we are giving up with this choice]

### Review Trigger
[Condition that would prompt revisiting — e.g., "if monthly cost exceeds €2k" or "if MCAE SLA drops below 99%"]
```

Store decision records in `docs/decisions/` in the repo.

## AI 3D Generation API Evaluation

The Prompt to Print pipeline is core IP — the generation API is a dependency, not the differentiator.

### Mandatory Requirements

- REST or gRPC API (no browser-only SDKs)
- Returns standard 3D formats: GLB, OBJ, or STL — must be compatible with MCAE ingestion
- EU data processing option (user prompts may contain PII — names, likenesses)
- Per-generation pricing available (not seat-only)
- Geometry quality sufficient for MCAE MCAE full-color 3D printing (watertight meshes, manifold geometry)

### Evaluation Process

1. Run 20 standardized test prompts (figurine-style: character descriptions, poses, styles)
2. Validate output geometry with automated checks (manifold, vertex count, printability score)
3. Submit 5 outputs to MCAE for test prints — assess physical output quality
4. Benchmark latency: p50 and p99 generation time
5. Calculate total cost at 500 generations/month and 5,000 generations/month

### Current Integration: [to be filled per active vendor]

The adapter lives in `app/services/ai_generation/`. Swapping providers requires only replacing the adapter, not the order flow.

## Print Partner Evaluation

MCAE is the primary print partner. Any additional or alternative partner must meet:

- Full-color 3D printing (multi-material or powder-based color — no single-color FDM)
- API for job submission and status tracking (no email-based workflows)
- Production in Czech Republic or EU (shipping cost and lead time SLA)
- Turnaround: standard ≤ 5 business days, express ≤ 2 business days
- File format acceptance: STL or GLB
- Minimum order: compatible with D2C single-unit orders

## Infrastructure & Tooling Decisions

### Approved Stack (no re-evaluation needed)

| Category | Choice | Rationale |
|----------|--------|-----------|
| Payments | Stripe | Best-in-class DX, Czech CZK support, strong webhook reliability |
| Shipping | Zásilkovna | Dominant Czech parcel network, pickup point density |
| Container orchestration | Kubernetes | Already operational, team proficiency |
| DB | PostgreSQL | Relational model fits order/catalog domain well |
| Frontend component lib | shadcn/ui | Owned components, no vendor lock-in, Tailwind-compatible |

### Evaluate Before Adding

Before adding any new dependency (library, SaaS, managed service):

- Is there an existing approved tool that covers 80% of the need?
- Will this add a new runtime language or paradigm? (Requires CTO sign-off)
- Does it have an active maintainer and > 1k GitHub stars or commercial support?
- Is the license compatible with commercial use (no AGPL without review)?

## Anti-patterns

- Choosing a vendor based on a demo or prototype without running real figurine prompts through it
- Integrating an AI generation API without an adapter abstraction layer — direct calls in business logic lock us in
- Selecting infrastructure tools that lack EU region options
- Making a build-vs-buy call without estimating cost at realistic Figurio order volumes
- Adding a new Python dependency without checking for conflicts with existing FastAPI/Pydantic versions
