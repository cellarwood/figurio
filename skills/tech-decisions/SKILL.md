---
name: tech-decisions
description: >
  Framework for build-vs-buy and vendor selection decisions at Figurio.
  Covers text-to-3D API evaluation (Meshy vs. Tripo3D), mesh repair tooling
  choices, infrastructure decisions under microk8s, and the ADR format used
  to record decisions.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags:
      - engineering
      - architecture
      - decisions
---

# Tech Decisions

Use this skill when Figurio needs to choose between vendors, libraries, or
build-vs-buy options. It defines the evaluation criteria, the current
decisions already made, and the ADR format for recording new ones.

## When to Use

- Evaluating a new text-to-3D API provider
- Choosing between mesh repair approaches (open-source vs. hosted)
- Adding or replacing infrastructure components (ingress, monitoring, queue)
- Deciding whether to build a capability in-house or adopt a third-party tool
- Revisiting an existing vendor decision due to cost, quality, or reliability

## Current Standing Decisions

| Domain | Decision | Rationale |
|---|---|---|
| Text-to-3D (primary) | Meshy API | Faster turnaround, higher quality figurines in testing |
| Text-to-3D (fallback) | Tripo3D API | Redundancy; used when Meshy fails or is degraded |
| Mesh repair | In-pipeline post-process step | Keeps the repair logic versioned alongside the pipeline |
| Frontend | React + TypeScript + shadcn | DX consistency; shadcn gives unstyled composable primitives |
| Backend | Python + FastAPI + uv | Async-native, fast iteration, uv for reproducible envs |
| Database | PostgreSQL | Single reliable datastore; avoids operational complexity of polyglot |
| Payments | Stripe | PCI compliance, webhook reliability, D2C track record |
| Container runtime | microk8s | Self-hosted K8s on existing hardware; avoids managed K8s cost at current scale |
| Ingress | Traefik | Native K8s CRD support, automatic TLS, lightweight |
| Error monitoring | Sentry | Covers both React and FastAPI with one vendor |
| CI/CD | GitHub Actions | Co-located with source; no separate CI infrastructure |

## Build vs. Buy Criteria

When evaluating a new capability, score it against these axes:

### Buy (use a vendor or open-source library) when:
- The problem is not core to Figurio's competitive differentiation (3D
  generation and the ordering experience are core; email delivery is not).
- Maintaining the capability in-house would cost more engineering time than
  the vendor cost.
- Regulatory or compliance requirements are involved (payments, PCI, GDPR).
- Time-to-market pressure is high and the vendor integration is well-documented.

### Build when:
- The capability is tightly coupled to Figurio's AI pipeline or 3D asset
  format specifics (e.g., custom mesh repair heuristics for figurine geometry).
- No vendor offers the required quality level (evaluate at least two providers).
- The vendor's pricing model becomes prohibitive beyond current scale
  projections (model out 12-month volume).

## Text-to-3D Provider Evaluation

When assessing a new or replacement text-to-3D provider, test against these
criteria using a fixed set of 20 figurine prompts:

| Criterion | Target |
|---|---|
| Mesh quality (manifold, watertight) | > 85% of outputs pass mesh repair without manual touch |
| Generation latency (p50) | < 60 s |
| Generation latency (p99) | < 180 s |
| API reliability (30-day uptime) | > 99% |
| Cost per generation | Compare at 1k, 10k, 100k volume |
| Format support | `.glb` required; `.obj` preferred as fallback |
| Webhook / polling support | Must support async status polling |

Document results in `references/provider-eval-<provider>-<YYYY-MM>.md` before
raising an ADR.

## Mesh Repair Tooling

Current approach: custom post-process step in the AI pipeline using open-source
geometry processing. When evaluating alternatives:

- Must handle the specific failure modes of Meshy/Tripo3D output (non-manifold
  edges, inverted normals, disconnected shells).
- Hosted repair services are acceptable only if they do not retain mesh data
  (IP/privacy concern for customer-submitted designs).
- Benchmark repair success rate and latency against the current step before
  switching.

## ADR Format

Every significant tech decision gets an ADR (Architecture Decision Record)
stored at `docs/adr/NNNN-<slug>.md`.

```markdown
# NNNN — Title of the Decision

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Deprecated | Superseded by [NNNN]

## Context

What is the problem or opportunity? What constraints apply (cost, timeline,
team size, existing stack)?

## Options Considered

### Option A — <name>
- Pros: ...
- Cons: ...

### Option B — <name>
- Pros: ...
- Cons: ...

## Decision

Which option was chosen and why.

## Consequences

What becomes easier and what becomes harder as a result of this decision.
Include known trade-offs.
```

### ADR Numbering

- ADRs are numbered sequentially starting from `0001`.
- Once accepted, an ADR is never deleted — mark it Deprecated or Superseded.
- Link the superseding ADR number when deprecating.

## Decision Review Triggers

Revisit a standing decision when any of the following occur:

- A vendor raises pricing by > 30% or changes reliability SLA materially.
- A new provider scores > 15% better than the current primary on the
  figurine prompt benchmark.
- The current solution requires > 1 week of unplanned engineering per quarter
  to maintain.
- The team size or order volume crosses a 10x threshold from when the original
  decision was made.
