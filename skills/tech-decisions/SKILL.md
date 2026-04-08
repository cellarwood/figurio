---
name: tech-decisions
description: Framework for making and documenting technical decisions using Architecture Decision Records (ADRs) at Figurio
---

# Tech Decisions

Use this skill when making build-vs-buy decisions, selecting technologies, or documenting architectural choices.

## ADR Format

```markdown
# ADR-{number}: {Title}

**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-{n}
**Date:** {YYYY-MM-DD}
**Decision maker:** CTO

## Context
{What is the problem or decision we need to make?}

## Options Considered
1. **{Option A}** — {brief description}
   - Pros: {list}
   - Cons: {list}
   - Cost: {estimate}

2. **{Option B}** — {brief description}
   - Pros: {list}
   - Cons: {list}
   - Cost: {estimate}

## Decision
{Which option was chosen and why}

## Consequences
- {What changes as a result}
- {What new constraints this creates}
```

## Decision Criteria for Figurio

When evaluating technology choices, weigh these factors:

1. **Output quality** — for AI/3D services, actual output quality trumps feature lists
2. **Operational simplicity** — fewer moving parts for a team of 8
3. **Cost at scale** — model per-unit cost at 100, 1000, 10000 orders/month
4. **Reversibility** — prefer decisions that can be changed later
5. **Community and support** — active maintenance, good documentation

## Key Decisions to Track

- Text-to-3D service selection (Meshy vs. Tripo3D vs. Luma vs. self-hosted)
- Mesh repair tooling (Blender scripting vs. trimesh vs. NetFabb)
- 3D model storage (local PV vs. S3-compatible object storage)
- Frontend 3D viewer (three.js vs. model-viewer vs. Babylon.js)
- Database choice (PostgreSQL is default — document why if changing)
