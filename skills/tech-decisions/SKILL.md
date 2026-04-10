---
name: tech-decisions
description: >
  Build-vs-buy decision framework for Figurio — covers AI text-to-3D model
  hosting (Meshy, Tripo3D, Luma Genie vs. self-hosted), mesh repair tooling
  (NetFabb, Meshmixer, Blender scripting), printing partner model (MCAE
  exclusivity vs. multi-vendor vs. in-house), and framework/service choices
  aligned to the Figurio tech stack. Use when evaluating new vendors, tooling
  options, or whether to build a capability internally.
metadata:
  paperclip:
    tags:
      - engineering
      - strategy
      - decisions
---

# Tech Decisions

## When to Use

Use this skill when:
- Evaluating a new external API, SaaS tool, or open-source library for Figurio
- Deciding whether to build a capability in-house or integrate a third-party service
- Reassessing an existing vendor relationship as volume or requirements change
- Writing a decision record (ADR) for the engineering or CEO team

## Decision Framework

Figurio is pre-revenue. Default to **buy/API-first** unless the capability is on the core moat list below. Optimize for reversibility: design the integration behind an abstraction layer so the vendor can be swapped without rewriting the rest of the pipeline.

### Core Moat — Always Own

These are the capabilities that differentiate Figurio. Never fully delegate to a single vendor with no fallback:

1. **Mesh validation and repair logic** — the rules for what makes a model printable on the Stratasys J55 are Figurio-specific. Wrap any tool (NetFabb, Blender) behind a `MeshRepairService` interface
2. **Order and pipeline state** — `orders`, `jobs`, `previews` live in Figurio's PostgreSQL, never in a vendor's database
3. **Customer-facing preview rendering** — Figurio controls the preview UX; the renderer (Three.js, model-viewer, or a server-side render job) is an internal concern

### Commodity — Buy First

- Payments: **Stripe** (decided). Do not build payment processing.
- Email/transactional notifications: **SendGrid or Resend** — integrate via simple HTTP, wrap in a `NotificationService`
- Object storage: **S3-compatible** (GCS or Cloudflare R2) — no custom file server
- Authentication: **Supabase Auth or Clerk** — do not build auth from scratch for MVP

## AI Text-to-3D Model Sourcing

**Current candidates:** Meshy, Tripo3D, Luma Genie, CSM 3D, self-hosted (e.g., Shap-E, CRM, InstantMesh)

### Evaluation Criteria

| Criterion | Weight | Notes |
|-----------|--------|-------|
| Output mesh quality (manifold ratio, detail) | High | Directly determines repair labor cost |
| Printability rate without manual repair | High | Drives 3D technician hours per order |
| Per-generation cost at target volume | Medium | Factor into custom figurine pricing model |
| API reliability and rate limits | Medium | Celery retry budget depends on this |
| Latency (time to usable mesh) | Low | Pipeline is async; customer waits anyway |
| Data privacy / mesh ownership | High | Figurio must own output mesh IP |

### Current Position (April 2026)

Use a **hosted API** (Meshy or Tripo3D) for launch — faster integration, no GPU infra cost. Wrap the call in a `TextTo3DClient` abstraction with a single `generate(prompt: str) -> MeshResult` interface so the provider can be swapped without touching the Celery task.

Revisit self-hosting when:
- Monthly generation volume exceeds ~500 models/month AND
- Per-unit API cost exceeds self-hosted GPU amortization, OR
- A quality gap is confirmed by QA data (repair rate > 40% of outputs)

Do not self-host before those thresholds — GPU infra management will cost more in engineering time than it saves.

## Mesh Repair Tooling

**Candidates:** NetFabb (cloud API), Meshmixer (local/scripted), Blender Python scripting, Manifold (open-source C++/Python bindings)

### Current Position

Run a **two-layer repair pipeline**:
1. **Automated:** Blender Python script (via `bpy`) for common issues — non-manifold edges, inverted normals, thin walls below J55 minimum (0.5mm). Free, scriptable, runs in-container.
2. **Escalation:** NetFabb Cloud for geometries the Blender script cannot fix. API-based, pay-per-use.

Do not license Meshmixer per-seat — it is GUI-only and cannot be automated in a Celery worker.

Flag models that survive both layers but still fail validation for **human QA review** — do not silently pass bad meshes to MCAE.

## Printing Partner Model

**Current:** MCAE (mcae.cz) — Stratasys J55 PolyJet, outsourced exclusively.

### Decision Thresholds

| Phase | Condition | Action |
|-------|-----------|--------|
| Launch | < 50 orders/month | MCAE exclusive, negotiated per-unit pricing |
| Growth | 50–200 orders/month | Negotiate volume tier with MCAE; evaluate second Czech/EU PolyJet partner as backup |
| Scale | > 200 orders/month | Model in-house Stratasys J55 lease/purchase economics; consider lower-cost FDM/SLA tier for catalog items |

Never build a dependency on MCAE that cannot be transferred to another Stratasys-authorized partner within 30 days. All print files must be stored in Figurio's object storage in a vendor-neutral format (3MF/STL).

## Framework and Service Choices

### When a Second Backend Language Is Justified

- **Go:** Only for a standalone performance-critical service (e.g., a mesh-streaming proxy, a high-throughput webhook receiver). Must be a separate Deployment, not mixed into the Python codebase.
- **Node.js/Express:** Only if consuming a JS-only SDK with no Python equivalent and the integration cannot be wrapped.
- Default for everything else: **Python/FastAPI**.

### When to Add a New Python Dependency

1. Check if the standard library or an already-approved package covers the need
2. Confirm the package is maintained (last commit < 12 months, CVE scan clean)
3. Add via `uv add <package>` — never `pip install`
4. If the package is a large optional dependency (e.g., `bpy`, `open3d`), isolate it to the worker image, not the API image

### Database

PostgreSQL is the single source of truth. Do not introduce a second relational database. Redis is task queue and cache only — not a primary store.

## Writing a Decision Record

For any non-trivial tech decision, document:
1. **Context** — what problem, what constraints, what triggered the evaluation
2. **Options considered** — at least two, with a one-line tradeoff summary each
3. **Decision** — what was chosen and why
4. **Consequences** — what this forecloses, what the swap-out path is if wrong
5. **Review trigger** — the condition under which this decision should be revisited (volume threshold, cost threshold, new product line)

Keep ADRs in `docs/decisions/` as Markdown files named `YYYY-MM-DD-<slug>.md`.
