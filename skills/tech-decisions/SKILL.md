---
name: tech-decisions
description: >
  Build-vs-buy decision framework for Figurio — evaluating text-to-3D services
  (Meshy, Tripo3D, Luma), mesh repair tooling, hosting options, and
  infrastructure choices against cost, quality, and speed tradeoffs specific
  to a D2C 3D-print business in the Czech Republic.
metadata:
  paperclip:
    tags:
      - engineering
      - architecture
      - strategy
---

# Tech Decisions

## When to Use

Apply this skill when evaluating:
- A new external SaaS or API to add to the Figurio stack
- Whether to build an internal tool or adopt an existing library/service
- Hosting and infrastructure changes (cloud, on-prem, managed services)
- AI provider selection or switching for the text-to-3D pipeline

## Decision Framework

Every significant build-vs-buy decision at Figurio is evaluated across four axes:

| Axis | Key Question |
|------|-------------|
| **Cost** | What is the total cost at Figurio's current and projected order volume? |
| **Quality** | Does the output meet print-ready mesh standards (manifold, full-color, correct scale)? |
| **Speed** | What is the end-to-end latency from customer input to print-ready file? |
| **Lock-in** | Can we swap this out in < 2 weeks if the vendor fails or pricing changes? |

Default to **buy** for non-core infrastructure (email, payments, DNS). Default to **build** when the capability is core to Figurio's product differentiation (mesh quality pipeline, custom figurine UX).

## Text-to-3D Provider Evaluation

Figurio's current providers: **Meshy** and **Tripo3D**. Luma AI is a candidate.

### Evaluation Criteria (in priority order)

1. **Print-ready mesh quality** — output must be manifold, watertight, and carry full vertex/texture color. Assess polygon count vs. print resolution requirements (typical target: 50k–200k polys for figurine scale).
2. **Generation latency** — customer-facing flow requires < 3 min from prompt to preview mesh. Background high-res generation can be up to 15 min.
3. **API reliability and SLA** — check uptime history; a provider outage blocks all custom orders. Prefer providers with a stated SLA or status page.
4. **Pricing per generation** — calculate at 100, 500, and 2000 custom orders/month. Factor in retries for failed generations (assume 10–15% failure rate).
5. **Data residency** — customer-submitted images and generated meshes must not be retained by the provider for training without opt-in. Confirm in provider DPA (important for Czech/EU compliance).
6. **Swap cost** — the internal adapter layer must abstract all provider-specific parameters. Score how much adapter code changes if we switch.

### Current Provider Notes

| Provider | Strengths | Weaknesses |
|----------|-----------|------------|
| Meshy | Good texture color fidelity, active API development | Mesh manifold quality inconsistent on complex poses |
| Tripo3D | Fast generation, good topology | Color/texture less detailed than Meshy |
| Luma AI | High realism | Primarily NeRF/video-oriented; mesh export quality for print not validated |

### Decision Rule

Run A/B print tests on a sample of 20+ figurines per candidate provider before committing. Evaluate against print-reject rate, not just visual preview quality.

## Mesh Repair Tooling

Figurio requires a mesh repair step before any mesh enters the print queue.

| Option | Approach | Notes |
|--------|----------|-------|
| **Manifold** (open source) | Self-hosted, local binary | Fast, no API cost, requires K8s job; current preference |
| **Microsoft 3MF Toolkit** | Library | Good for format conversion alongside repair |
| **Netfabb (Autodesk cloud)** | Managed API | High quality but per-call cost and vendor lock-in |
| **Build custom** | Python + open3d | Only if Manifold fails on Figurio-specific mesh patterns |

Default: use **Manifold** as the self-hosted repair step. Escalate to Netfabb only for meshes that Manifold cannot repair after two retries.

## Hosting & Infrastructure

Figurio currently runs on **microk8s** (self-managed, single-node). Evaluate cloud migration only when:
- Monthly infra cost of managed K8s (GKE, AKS) is competitive with current hardware + ops burden, OR
- Single-node reliability is causing customer-visible downtime > 0.5% monthly

### Cloud Provider Shortlist (if migration warranted)

- **Hetzner Cloud (CX series)** — preferred for EU data residency, lowest cost, good Prague/Frankfurt latency
- **Google GKE Autopilot** — simpler ops, higher cost; viable if AI pipeline GPU workloads are needed
- Avoid AWS/Azure as primary unless a specific managed service (e.g., RDS, managed Redis) justifies the overhead

## Payments

Stripe is the fixed choice for Figurio. Do not re-evaluate unless:
- A Czech payment method (SEPA, GoPay, Comgate) requires a local gateway with no Stripe support
- Stripe pricing becomes uncompetitive at > 5000 orders/month

## Build-vs-Buy Scorecard Template

Use this when writing up a decision:

```
## Option: <name>

- Cost (monthly at 500 orders): 
- Quality score (1–5, print-reject rate): 
- Latency (p50 / p95): 
- Lock-in risk (low / medium / high): 
- EU data residency compliant: yes / no
- Swap effort (days): 

Recommendation: Build | Buy | Defer
Rationale: <2–3 sentences>
```
