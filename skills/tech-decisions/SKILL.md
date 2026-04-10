---
name: tech-decisions
description: >
  Framework for build-vs-buy decisions, vendor selection, and tech stack choices
  specific to Figurio's figurine production pipeline. Covers AI model provider
  evaluation (Meshy vs. Tripo3D), mesh repair tooling, and infrastructure trade-offs
  for a small D2C team outsourcing production to MCAE.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - decisions
      - vendor
---

# Tech Decisions

Use this skill when evaluating a new tool, library, or vendor, or when a team member asks "should we build this or buy it?"

## Decision Principles

**Reversibility over perfection.** The AI provider market is moving fast. Default to thin integration layers that can be swapped in a sprint. A wrong bet on Meshy vs. Tripo3D should cost days, not months.

**Operational cost is a first-class constraint.** Figurio runs on a small team. Any tool that requires dedicated operational expertise (tuning, on-call runbooks, custom operators) has a hidden headcount cost. Factor it in.

**Pre-revenue economics apply.** Until Figurio reaches consistent order volume, avoid per-seat SaaS pricing that scales with team size and managed infrastructure that charges for idle capacity. Prefer usage-based pricing.

## Build vs. Buy

Default to **buy** when:
- The problem is not a source of competitive advantage (email delivery, auth, payments, observability).
- A vendor solution can be integrated in under a week and has a clear swap path.
- Operating the self-built version would require >20% of an engineer's ongoing time.

Default to **build** when:
- The component is core to the figurine production differentiator (3D pipeline orchestration, order state machine, MCAE handoff format).
- The vendor API would be called in the hot path and the vendor has no SLA that meets Figurio's latency requirements.
- The build cost is under one sprint and the operational cost is near zero (a pure function, a migration script).

## AI Model Provider Evaluation (Meshy / Tripo3D)

Figurio's text-to-3D pipeline currently supports both Meshy and Tripo3D as swappable providers. Evaluate providers on:

| Criterion | Why It Matters |
|-----------|---------------|
| Mesh quality for human figurines | MCAE prints full-color PLA — topology errors and thin walls fail in production |
| Color / texture fidelity | Figurines are the product; washed-out textures are a support issue |
| API reliability + uptime | Async pipeline — provider downtime queues orders, not blocks them, but SLA still matters |
| Pricing model | Per-generation cost must stay below ~15% of figurine COGS at target order volume |
| Output format | Must export GLB or OBJ/MTL without a conversion step; STL-only providers add a mesh repair hop |
| Retention / data policy | Customer likeness data — EU customers, Czech production — check GDPR data processing terms |

When a new provider is evaluated:
1. Run 10 test generations with representative prompts (human figure, pets, fantasy characters).
2. Inspect mesh in Meshy's viewer or Blender — check for non-manifold edges, inverted normals, thin walls under 0.8mm.
3. Price the per-generation cost at 100 orders/month and 1000 orders/month.
4. Read the data processing agreement — flag if training data rights are claimed on uploaded/generated content.
5. Write a one-paragraph evaluation note with a keep/drop recommendation.

## Mesh Repair Tooling

MCAE requires watertight, manifold meshes. If AI-generated output fails validation:

- **Prefer** automated repair via Manifold or Microsoft 3MF Toolkit (open source, no per-call cost, runs in-cluster).
- **Avoid** cloud repair APIs that charge per file — volume will make costs unpredictable.
- Repair should be a post-processing step in the pipeline, not a manual intervention. If >5% of generations require manual repair, escalate to AI provider quality review.

## Infrastructure Choices

### When to Add a New Service

Only add a new K8s service if:
- The workload has distinct scaling requirements from the FastAPI backend, OR
- The component must be operated by a different team or on a different release cycle.

Otherwise, add a module to the existing FastAPI backend.

### Managed vs. Self-hosted

| Component | Current choice | Change trigger |
|-----------|---------------|----------------|
| PostgreSQL | Self-hosted in microk8s | Move to managed (e.g., Supabase/CloudSQL) when DB admin time exceeds 2h/week |
| Object storage | Evaluate S3-compatible (MinIO in-cluster or Cloudflare R2) | R2 preferred for egress cost at scale |
| CI/CD | GitHub Actions | No change trigger — fits team size |
| Ingress | Traefik | No change trigger — already in place |

### Adding a New Language / Runtime

Python is the backend language. Adding a second runtime (Go, Node, Rust) is a CTO-level decision and requires:
- A documented reason why Python cannot meet the requirement.
- A named engineer who will own the runtime long-term.
- Agreement that the new runtime will not be used for general feature work.

## Decision Record Format

Log significant tech decisions as a short ADR in the repo at `docs/decisions/`:

```
# ADR-NNN: [Title]

**Date:** YYYY-MM-DD
**Status:** Accepted / Superseded by ADR-NNN

## Context
[What problem prompted this decision?]

## Decision
[What did we decide?]

## Rationale
[Why this option over alternatives? Include cost, reversibility, team capacity.]

## Consequences
[What changes as a result? What do we give up?]
```

Keep ADRs under 30 lines. If the reasoning takes longer, the decision was not clear enough.
