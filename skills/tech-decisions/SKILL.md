---
name: tech-decisions
description: >
  Framework for making and documenting technical decisions at Figurio —
  ADR format, build-vs-buy evaluation, and technology selection criteria
  for the e-commerce platform and AI pipeline.
---

# Tech Decisions

## ADR (Architecture Decision Record) Format

Use this format for significant technical decisions:

```
# ADR-{number}: {Title}

## Status: Proposed / Accepted / Superseded

## Context
What is the problem or situation that requires a decision?

## Options Considered
| Option | Pros | Cons | Cost |
|--------|------|------|------|
| A | ... | ... | ... |
| B | ... | ... | ... |

## Decision
Which option was chosen and why.

## Consequences
What changes as a result of this decision. Both positive and negative.
```

## Build vs Buy Criteria

For Figurio, prefer buying/using existing solutions when:
- The capability is not a core differentiator (payments, email, hosting)
- A mature, well-documented option exists (Stripe, PostgreSQL, Docker)
- The team's time is better spent on product-specific work

Build when:
- The capability IS the product (AI figurine pipeline, mesh repair)
- No existing solution meets quality requirements
- The long-term cost of external dependency exceeds build cost

## Key Decisions to Track

- Text-to-3D API provider selection (Meshy vs Tripo3D vs self-hosted)
- Mesh repair tooling (Blender scripting vs NetFabb vs trimesh)
- 3D model format and storage strategy
- Frontend 3D viewer library (Three.js vs alternative)
- Task queue technology (Celery+Redis vs alternatives)
