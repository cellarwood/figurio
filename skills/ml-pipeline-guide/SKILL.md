---
name: ml-pipeline-guide
description: >
  Text-to-3D pipeline conventions for Figurio's figurine generation system.
  Covers API integration with Meshy, Tripo3D, Luma Genie, and CSM 3D; mesh
  repair steps (non-manifold fix, thin wall detection, floating artifact
  removal); quality scoring criteria; and async job queue patterns for
  managing long-running generation jobs.
allowed-tools:
  - Read
  - Write
  - Grep
  - Bash
metadata:
  paperclip:
    tags:
      - ml
      - engineering
      - 3d-pipeline
---

# ML Pipeline Guide

This skill defines how Figurio's text-to-3D generation pipeline is structured,
from prompt intake through mesh delivery to MCAE for Stratasys J55 PolyJet printing.

## Pipeline Stages

```
prompt → API dispatch → raw mesh → repair → quality score → approve/reject
```

Each stage is a discrete async step managed by the job queue. No stage blocks
the HTTP request lifecycle.

## API Integration

### Supported Services

| Service  | SDK / transport       | Output format | Notes                          |
|----------|-----------------------|---------------|--------------------------------|
| Meshy    | REST, `httpx` async   | GLB / OBJ     | Best texture color fidelity    |
| Tripo3D  | REST, `httpx` async   | GLB           | Fastest generation (~30 s)     |
| Luma Genie | REST, `httpx` async | GLB           | Strong topology for characters |
| CSM 3D   | REST, `httpx` async   | OBJ + MTL     | Good geometric detail          |

### Client Pattern

All service clients inherit from `BaseText3DClient` in `app/ml/clients/base.py`.
Each client must implement:

```python
async def submit(self, prompt: str, style_hints: dict) -> str:
    """Submit generation job. Returns provider job_id."""

async def poll(self, job_id: str) -> JobStatus:
    """Return PENDING | PROCESSING | DONE | FAILED."""

async def download(self, job_id: str, dest_path: Path) -> Path:
    """Download completed mesh to dest_path. Returns final path."""
```

- All HTTP calls use `httpx.AsyncClient` with a 90-second timeout.
- Retry on 429/503 with exponential backoff: 2 s, 4 s, 8 s (max 3 retries).
- Provider API keys are read from environment variables:
  `MESHY_API_KEY`, `TRIPO3D_API_KEY`, `LUMA_API_KEY`, `CSM3D_API_KEY`.

### Multi-Provider Dispatch

For catalog figurines, run Meshy and Tripo3D in parallel; keep the result with
the higher quality score. For custom AI figurines, use the provider configured
in `settings.DEFAULT_TEXT3D_PROVIDER` (default: `meshy`).

```python
results = await asyncio.gather(
    meshy_client.submit(prompt, style_hints),
    tripo_client.submit(prompt, style_hints),
    return_exceptions=True,
)
```

## Mesh Repair Steps

All downloaded meshes pass through `app/ml/repair/pipeline.py` before scoring.
Repairs run in this order — order matters.

### 1. Non-Manifold Fix

Use `pymeshlab` (`MeshSet.meshing_repair_non_manifold_edges`).
Fail the job if edge count after repair exceeds 5 % of original (indicates
geometry is beyond automated repair).

### 2. Thin Wall Detection

Figurio's minimum printable wall thickness on the J55 is **0.8 mm**.
Cast interior rays using `trimesh`; flag any region below threshold.
If flagged volume exceeds 2 % of total mesh volume, add warning to job metadata
(`repair_warnings: ["thin_wall"]`) — do not auto-reject, let quality scorer
decide.

### 3. Floating Artifact Removal

Identify disconnected components with `trimesh.graph.connected_components`.
Remove any component whose volume is less than 0.5 % of the largest component.
Log removed component count to job metadata (`artifacts_removed: N`).

### 4. Export

After repair, export as binary STL (for MCAE slicer compatibility) and GLB
(for storefront 3D preview). Both go to `storage/meshes/{job_id}/`.

## Quality Scoring

Scoring runs in `app/ml/scoring/scorer.py` and produces a `QualityScore`
dataclass with fields:

| Field               | Range  | Weight | Description                                      |
|---------------------|--------|--------|--------------------------------------------------|
| `detail_score`      | 0–1    | 0.30   | Surface detail density (vertex count normalized) |
| `color_accuracy`    | 0–1    | 0.30   | Color coverage vs. prompt keywords (CLIP-based)  |
| `geometry_score`    | 0–1    | 0.25   | Watertightness + symmetry heuristics             |
| `printability`      | 0–1    | 0.15   | Thin wall penalty + support volume estimate      |

`total = weighted sum of above fields`

Thresholds:
- `total >= 0.75` → approve
- `0.55 <= total < 0.75` → manual review queue
- `total < 0.55` → auto-reject, re-queue with fallback provider

Store scores in `job.quality_score` (JSON column) in the jobs table.

## Async Job Queue

### Technology

ARQ (async Redis Queue) with Redis 7. Worker entrypoint: `app/ml/worker.py`.

### Job Lifecycle

```
QUEUED → DISPATCHED → POLLING → REPAIR → SCORING → DONE
                                                  ↘ FAILED
```

Each transition writes a timestamped entry to `job.status_history` (JSONB).

### Key Queue Functions

```python
# Enqueue from FastAPI endpoint
await arq_pool.enqueue_job("generate_figurine", job_id=job_id, prompt=prompt)

# Worker task signature
async def generate_figurine(ctx, *, job_id: str, prompt: str): ...
```

### Polling Loop

Inside the worker, poll the provider every 10 seconds, up to 20 minutes.
If the provider is still PROCESSING after 20 minutes, mark job FAILED with
`failure_reason: "provider_timeout"` and alert via Slack webhook.

### Concurrency

Run at most 4 simultaneous generation jobs per worker process
(`max_jobs=4` in ARQ worker settings). Scale workers horizontally for higher
throughput; do not raise `max_jobs` above 4 (GPU-bound scoring step).

## Error Handling

- All unhandled exceptions in worker tasks must be caught, logged with
  `structlog` including `job_id`, and set job status to FAILED.
- Never silently swallow errors — always update job status so the API can
  surface failure to the customer.
- On FAILED, send a Stripe refund trigger event to `app/payments/refunds.py`
  if the job was tied to a paid order.
