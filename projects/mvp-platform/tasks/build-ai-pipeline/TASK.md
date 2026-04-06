---
name: Build AI text-to-3D pipeline integration
assignee: backend-engineer
project: mvp-platform
---

Build the async pipeline that turns customer text prompts into printable 3D models with rendered previews.

## Pipeline Steps

1. **Prompt intake** — validate and store customer prompt, create AI generation job record
2. **3D model generation** — call text-to-3D API (Meshy or Tripo3D), poll for completion
3. **Mesh repair** — automated repair of generated model (fix non-manifold geometry, thin walls, floating artifacts)
4. **Preview rendering** — generate 3D render images (multiple angles) for customer review
5. **Status updates** — update job status at each step, exposed via API for frontend polling

## Technical Details

- Async job processing using Celery or ARQ with Redis as broker
- Provider adapter pattern: abstract the 3D API behind an interface so we can swap providers
- Mesh repair: Blender Python API in headless mode or NetFabb CLI
- Preview rendering: Blender headless render or Three.js server-side rendering
- Job states: `pending` → `generating` → `repairing` → `rendering` → `ready_for_review` → `approved` / `rejected`
- Retry with exponential backoff on API failures (max 3 retries)
- Store intermediate artifacts (raw model, repaired model, preview images) in object storage or filesystem

## API Endpoints

- `POST /ai-jobs` — submit prompt, returns job_id
- `GET /ai-jobs/{id}` — get job status and preview URLs when ready
- `POST /ai-jobs/{id}/approve` — customer approves, triggers print queue entry
- `POST /ai-jobs/{id}/reject` — customer rejects, triggers revision or refund flow

## Acceptance Criteria

- End-to-end pipeline working with at least one 3D provider
- Async job processing with status updates
- Mesh repair producing printable geometry
- Preview images generated for customer review
- Retry logic handling API failures gracefully
- Unit and integration tests
