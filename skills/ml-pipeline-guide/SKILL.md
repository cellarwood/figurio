---
name: ml-pipeline-guide
description: >
  Text-to-3D pipeline conventions for Figurio's "Prompt to Print" feature.
  Covers API integration with Meshy and Tripo3D, mesh repair automation via
  Blender scripting and NetFabb, printability quality thresholds, and error
  handling for the MCAE/PolyJet production workflow.
allowed-tools:
  - Read
  - Write
  - Grep
  - Bash
metadata:
  paperclip:
    tags:
      - engineering
      - ml
      - pipeline
---

# Text-to-3D Pipeline Guide

## Overview

The Figurio "Prompt to Print" pipeline converts a customer text prompt into a
print-ready `.stl` or `.obj` mesh suitable for the Stratasys J55 PolyJet printer.
The pipeline is implemented as a FastAPI background task and runs in a dedicated
Kubernetes job pod.

## Pipeline Stages

```
Customer prompt
  → Prompt sanitization & enrichment
  → 3D generation API call (Meshy or Tripo3D)
  → Mesh download & validation
  → Automated mesh repair (Blender + NetFabb)
  → Quality threshold check
  → Asset storage (S3-compatible bucket)
  → Order record update (PostgreSQL)
```

## Stage 1 — Prompt Sanitization & Enrichment

Before sending to a generation API, every prompt must be:

1. Checked against the content policy blocklist (stored in `config/content_policy.json`).
2. Enriched with a Figurio style suffix: append `", full-color, highly detailed figurine, suitable for 3D printing"` unless the user prompt already contains material/style keywords.
3. Capped at 400 characters total after enrichment.

Sanitization is handled by `app/ml/prompt.py::sanitize_prompt()`.

## Stage 2 — 3D Generation API Integration

### Provider Selection

The active provider is controlled by the env var `FIGURIO_3D_PROVIDER` (values: `meshy`, `tripo3d`). Default: `meshy`.

Use `app/ml/providers/router.py::get_provider()` — never instantiate provider clients directly in pipeline code.

### Meshy Integration

```python
# app/ml/providers/meshy.py
POST https://api.meshy.ai/v2/text-to-3d
Headers: Authorization: Bearer {MESHY_API_KEY}
Body:
  {
    "mode": "preview",          # first pass — fast low-res
    "prompt": enriched_prompt,
    "art_style": "realistic",
    "negative_prompt": "low quality, blurry",
    "topology": "triangle",
    "target_polycount": 50000   # Figurio standard
  }
```

After preview generation completes, always trigger a `refine` pass:

```python
POST https://api.meshy.ai/v2/text-to-3d/{task_id}/refine
Body: {"texture_richness": "high"}
```

Poll `GET /v2/text-to-3d/{task_id}` every 10 s with a 5-minute timeout.
Terminal statuses: `SUCCEEDED`, `FAILED`, `EXPIRED`.

### Tripo3D Integration

```python
# app/ml/providers/tripo3d.py
POST https://api.tripo3d.ai/v2/openapi/task
Headers: Authorization: Bearer {TRIPO3D_API_KEY}
Body:
  {
    "type": "text_to_model",
    "prompt": enriched_prompt,
    "model_version": "v2.0-20240919",
    "face_limit": 50000,
    "texture": true,
    "pbr": true
  }
```

Poll `GET /v2/openapi/task/{task_id}` every 8 s with a 6-minute timeout.
Terminal statuses: `success`, `failed`.

### Mesh Download

On success, download the primary mesh asset (prefer `.glb`, fall back to `.obj`).
Store the raw file at `tmp/{order_id}/raw_mesh.{ext}` on the pod's ephemeral volume.

## Stage 3 — Mesh Repair

Run repairs in this order. Each step is a separate Blender Python script call.

### 3a. Blender Automated Repair

Script: `scripts/blender/repair_mesh.py`

```bash
blender --background --python scripts/blender/repair_mesh.py -- \
  --input tmp/{order_id}/raw_mesh.glb \
  --output tmp/{order_id}/repaired_mesh.stl
```

The script performs:
- Remove duplicate vertices (`mesh.remove_doubles(threshold=0.0001)`)
- Fill holes (max hole edge count: 200)
- Recalculate normals (outside)
- Scale to fit within a 200 × 200 × 200 mm bounding box (J55 build volume is 350 × 270 × 200 mm; leave margin for support structures)
- Export as binary STL

### 3b. NetFabb Cloud Repair (fallback)

If the Blender script exits non-zero or produces a mesh that fails validation,
submit to NetFabb Cloud via `app/ml/repair/netfabb.py::repair_async()`.

```python
# Uses the NetFabb REST API
POST https://api3.netfabb.com/repair
Body: multipart with STL file
# Poll for completion, download repaired STL
```

NetFabb repair is mandatory when Blender reports more than 500 remaining non-manifold edges.

## Stage 4 — Quality Threshold Check

All thresholds are defined in `config/print_quality.yaml`. Current values:

| Metric | Minimum / Maximum | Rejection action |
|---|---|---|
| Watertight (manifold) | must be manifold | retry NetFabb, then fail order |
| Triangle count | ≤ 150 000 | decimate to 100 000 in Blender |
| Minimum wall thickness | ≥ 1.0 mm | flag for manual review |
| Bounding box | ≤ 200 × 200 × 200 mm | auto-scale |
| Non-manifold edges | 0 | fail if > 0 after NetFabb |

Validation is implemented in `app/ml/validation.py::validate_mesh()` using `trimesh`.

```python
import trimesh
mesh = trimesh.load("repaired_mesh.stl")
assert mesh.is_watertight, "Mesh is not watertight"
assert mesh.is_volume, "Mesh has no valid volume"
```

## Stage 5 — Error Handling

| Failure point | Action |
|---|---|
| Content policy violation | Return HTTP 422 to customer immediately with localized message |
| Provider API timeout | Retry once with 30 s delay; if second attempt fails, try alternate provider |
| Provider returns `FAILED` | Switch to alternate provider once; if both fail, enqueue for manual prompt review |
| Mesh download error | Retry 3 times with exponential backoff (2 s, 4 s, 8 s) |
| Blender script crash | Log stderr, escalate to NetFabb repair |
| NetFabb repair fails | Set order status `MESH_REPAIR_FAILED`, notify ops via Slack `#ml-alerts` |
| Quality threshold failure | Set order status `QUALITY_REVIEW`, notify ops; do not charge customer |

All pipeline errors must be logged to the `ml_pipeline_events` PostgreSQL table with `order_id`, `stage`, `error_code`, `provider`, and `raw_error_message`.

## Environment Variables

| Variable | Description |
|---|---|
| `FIGURIO_3D_PROVIDER` | Active generation provider (`meshy` or `tripo3d`) |
| `MESHY_API_KEY` | Meshy API key (from Kubernetes secret `ml-api-keys`) |
| `TRIPO3D_API_KEY` | Tripo3D API key (from Kubernetes secret `ml-api-keys`) |
| `NETFABB_API_KEY` | NetFabb Cloud API key |
| `BLENDER_BIN` | Path to Blender binary (default: `/usr/bin/blender`) |
| `MESH_STORAGE_BUCKET` | S3-compatible bucket for final mesh assets |

## Anti-patterns

- Do not call provider APIs directly from route handlers — always go through `router.py`.
- Do not skip the Blender repair step even if the provider reports the mesh is manifold — provider meshes routinely have subtle errors.
- Do not store raw or repaired meshes in the PostgreSQL database — store only the S3 object key.
- Do not expose provider API keys in pipeline logs — use structured logging with key masking.
