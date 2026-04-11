---
name: tech-decisions
description: >
  Framework for build-vs-buy and vendor-selection decisions at Figurio —
  text-to-3D service selection (Meshy vs Tripo3D vs others), mesh repair tooling,
  3D preview rendering approach, and infrastructure choices for the K8s/FastAPI/React stack.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - architecture
      - decisions
---

# Tech Decisions

Use this skill when evaluating whether to build a capability in-house or adopt a
third-party tool, API, or library for any part of the Figurio platform.

## When to Use

- Selecting or switching a text-to-3D generation provider
- Evaluating mesh repair or validation libraries
- Choosing a 3D preview/rendering approach for the storefront
- Picking infrastructure components (ingress, object storage, job queue, observability)
- Assessing a new Python library or npm package for a core pipeline stage

## Decision Framework

### Step 1 — Define the Constraint Set

Before evaluating options, establish hard constraints for Figurio:

| Constraint | Detail |
|---|---|
| Print target | Stratasys J55 PolyJet via MCAE; output must be J55-compatible (build volume 342 × 228 × 200 mm, full-color, watertight mesh) |
| Latency budget | Custom figurine generation must complete within 5 minutes end-to-end for a good customer experience |
| Cost ceiling | Per-unit generation cost must remain below the margin floor (currently ~€4 per figurine at catalog prices) |
| Data residency | No hard EU data residency requirement today, but prefer EU or US providers; avoid providers with training-on-input clauses for customer uploads |
| Ops complexity | Team is small; prefer managed services over self-hosted where ops burden is the primary differentiator |

### Step 2 — Score Against Figurio-Specific Criteria

Rate each option (1–5) on:

1. **Output quality** — Does the mesh produce acceptable full-color PolyJet prints? Request test prints if possible.
2. **Mesh quality** — Watertight, manifold, within J55 tolerances without heavy post-processing?
3. **API maturity** — Webhook support, stable versioning, clear SLA, idempotency keys?
4. **Cost per generation** — At expected volume (catalog + custom orders)?
5. **Latency** — P95 generation time within the 5-minute budget?
6. **Vendor risk** — Funding stage, contractual lock-in, data ownership clauses?
7. **Integration effort** — Days to wire into the existing FastAPI pipeline?

### Step 3 — Document the Decision

Record the outcome in the repo at `docs/decisions/<YYYY-MM-DD>-<slug>.md` using the ADR format below.

---

## Domain-Specific Guidance

### Text-to-3D Generation (Meshy vs Tripo3D vs others)

**Current baseline:** Meshy API (text-to-3D and image-to-3D endpoints).

When evaluating alternatives or re-evaluating Meshy:

- **Must have:** OBJ/GLB/STL output with per-vertex or texture color; no post-processing should be needed to get color into the PolyJet workflow
- **Must have:** Async job model with webhook callbacks (polling is a fallback, not preferred)
- **Watch out for:** Providers that output single-color or uncolored meshes — full-color is non-negotiable for Figurio's product
- **Tripo3D:** Strong mesh quality, competitive latency; evaluate texture resolution and API rate limits at Figurio's projected order volume
- **Shap-E / custom PyTorch:** Building in-house is only justified if no commercial provider meets quality or cost targets at scale; ops burden is high
- **Decision trigger:** Re-evaluate providers when cost per generation exceeds €2 or P95 latency exceeds 4 minutes

### Mesh Repair Tooling

**Current approach:** Pipeline stage after generation, before preview.

Options and tradeoffs:

| Tool | Type | Strengths | Weaknesses |
|---|---|---|---|
| Manifold (C++/Python bindings) | Library | Fast, robust boolean ops, good for PolyJet | No color/texture repair |
| pymeshfix | Library | Simple API, good watertight repair | Slow on large meshes |
| Meshmixer (CLI) | Desktop app | Full-featured | Not headless-friendly |
| Microsoft 3D Builder API | Cloud | Managed | Vendor lock-in, not production API |

**Recommendation:** Use `manifold` for geometry repair + `trimesh` for validation checks; only escalate to heavier tools if manifold cannot resolve the mesh.

Build vs buy: **buy** (use open-source libraries). Building a mesh repair pipeline from scratch is not justified.

### 3D Preview Rendering (Storefront)

Options:

- **React Three Fiber + Three.js (current direction):** In-browser WebGL; no server cost, good interactivity. Use for catalog and custom order confirmation preview.
- **Model Viewer (`<model-viewer>` web component):** Lower complexity, good mobile support; acceptable for catalog cards where interactivity is limited.
- **Server-side rendering (Blender headless):** Only justified for high-fidelity marketing images, not real-time preview.

**Decision rule:** Use `<model-viewer>` for catalog thumbnails (performance), React Three Fiber for the full-screen configurator and order confirmation view.

### Infrastructure Choices

**Job queue:** Use a simple PostgreSQL-backed queue (e.g., `pgqueue` pattern) before introducing Redis/Celery. Add Redis only when job throughput exceeds what PG can handle (benchmark threshold: >50 concurrent generation jobs).

**Object storage:** S3-compatible (MinIO on-cluster for dev, Backblaze B2 or Cloudflare R2 for production). Avoid AWS S3 unless the team is already paying for AWS — cost at Figurio's scale doesn't justify the complexity.

**Observability:** OpenTelemetry traces exported to a managed backend (Grafana Cloud or similar). Do not build a custom logging pipeline.

**Build vs buy default:** Prefer managed/hosted for anything outside the core product (auth, email, payments, observability). Build only for the text-to-3D pipeline, mesh processing, and the React configurator — these are Figurio's differentiators.

---

## ADR Template

```markdown
# ADR: <title>

Date: YYYY-MM-DD
Status: Accepted | Superseded by ADR-XXX

## Context
<What problem are we solving? What constraints apply?>

## Options Considered
| Option | Score | Notes |
|---|---|---|
| ... | ... | ... |

## Decision
<What we chose and why.>

## Consequences
<Trade-offs accepted. What becomes easier, what becomes harder.>

## Review Trigger
<Condition that should prompt revisiting this decision.>
```
