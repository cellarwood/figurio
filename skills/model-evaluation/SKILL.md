---
name: model-evaluation
description: >
  Benchmarking framework for comparing text-to-3D services (Meshy, Tripo3D,
  Luma Genie, CSM 3D) used in Figurio's figurine pipeline. Defines quality
  metrics (detail, color accuracy, geometric correctness), cost-per-generation
  tracking, latency measurement, and printability pass rate on the Stratasys
  J55 PolyJet at MCAE.
allowed-tools:
  - Read
  - Write
  - Grep
  - Bash
metadata:
  paperclip:
    tags:
      - ml
      - evaluation
      - 3d-pipeline
---

# Model Evaluation

This skill defines how Figurio benchmarks and compares text-to-3D generation
services before production use and during periodic re-evaluation.

## When to Run Evaluation

- Before onboarding a new provider API.
- When an existing provider ships a major model update.
- Quarterly, or whenever printability pass rate drops below 80 % in production
  telemetry.
- When per-generation cost changes by more than 20 %.

## Benchmark Dataset

Use the fixed prompt set in `evals/prompts/benchmark_v1.json` (50 prompts).
The set covers:
- Human figurines (character, pose variety)
- Animal figurines
- Fantasy/sci-fi characters
- Abstract decorative objects

Do not modify `benchmark_v1.json` — extend it by creating `benchmark_v2.json`
and keeping prior versions for longitudinal comparison.

## Metrics

### 1. Detail Score (weight 0.30)

Proxy: normalized vertex count of the repaired mesh against the dataset mean.

```python
detail_score = min(vertex_count / DETAIL_BASELINE_VERTICES, 1.0)
# DETAIL_BASELINE_VERTICES = 150_000 (empirically set from J55-printable meshes)
```

### 2. Color Accuracy (weight 0.30)

CLIP-based similarity between the rendered figurine thumbnail and the original
text prompt. Use `open_clip` with `ViT-B/32` (same model in production scorer).

```python
from open_clip import create_model_and_transforms, tokenize
# cosine_similarity(image_embed, text_embed) → float in [0, 1]
```

Report mean and p10/p90 across the benchmark set.

### 3. Geometric Correctness (weight 0.25)

Two sub-checks combined equally:

- **Watertightness**: `trimesh.is_watertight` — boolean pass/fail per mesh.
  Report pass rate across dataset.
- **Symmetry deviation** (for humanoid prompts): compute bilateral symmetry
  score by reflecting the mesh and measuring Hausdorff distance. Normalize
  against mesh bounding box diagonal. Lower is better.

### 4. Printability Pass Rate (weight 0.15)

A mesh passes printability if ALL of the following hold after repair:
- No non-manifold edges remain.
- Thin wall warnings affect < 2 % of total volume.
- Mesh is watertight.
- Total support volume estimate (computed via `app/ml/scoring/support_estimator.py`)
  is < 30 % of figurine volume (excessive support = failed print or bad surface).

Report **printability pass rate** as a percentage of the benchmark set.
This is the most operationally critical metric — J55 prints are expensive
(~800 CZK/job at MCAE); high reject rates have direct cost impact.

## Cost and Latency

Track per provider:

| Metric                  | How to measure                                              |
|-------------------------|-------------------------------------------------------------|
| `cost_per_generation`   | Parse provider invoice API or per-call charge from docs     |
| `p50_latency_s`         | Time from `submit()` call to `download()` completion        |
| `p95_latency_s`         | Same, 95th percentile across benchmark set                  |
| `failure_rate`          | Jobs ending in FAILED / total submitted                     |

Record all measurements in `evals/results/{provider}/{date}/metrics.json`.

## Running a Benchmark

```bash
# Run full benchmark against one provider
uv run python -m evals.run --provider meshy --prompts evals/prompts/benchmark_v1.json

# Compare two providers side-by-side
uv run python -m evals.compare --providers meshy tripo3d --results-dir evals/results/
```

The `evals.run` module:
1. Submits all 50 prompts to the provider via the standard client interface.
2. Polls until DONE or FAILED.
3. Runs the repair pipeline and scorer on each result.
4. Writes per-prompt and aggregate metrics to `evals/results/{provider}/{date}/`.

## Reporting Format

`metrics.json` schema:

```json
{
  "provider": "meshy",
  "model_version": "v3",
  "eval_date": "2026-04-11",
  "prompt_set": "benchmark_v1",
  "n_prompts": 50,
  "aggregate": {
    "detail_score_mean": 0.82,
    "color_accuracy_mean": 0.74,
    "watertightness_pass_rate": 0.94,
    "printability_pass_rate": 0.88,
    "cost_per_generation_czk": 18.50,
    "p50_latency_s": 42,
    "p95_latency_s": 118,
    "failure_rate": 0.02
  },
  "per_prompt": [ ... ]
}
```

Convert USD provider costs to CZK using the rate in `config/fx_rates.json`
(updated weekly by the devops cron job).

## Provider Ranking

Score providers with a composite index for routing decisions:

```
composite = (
    0.30 * detail_score_mean +
    0.30 * color_accuracy_mean +
    0.25 * (watertightness_pass_rate + symmetry_score) / 2 +
    0.15 * printability_pass_rate
) * (1 - failure_rate) * latency_penalty
```

`latency_penalty = 1.0` if p50 < 60 s, else `0.9` if p50 < 120 s, else `0.75`.

The provider with the highest composite score is set as `DEFAULT_TEXT3D_PROVIDER`
in the environment config. Document the decision in `evals/results/decisions.md`.

## Anti-patterns

- Do not evaluate on a subset of prompts smaller than 30 — variance is too high.
- Do not compare results across different versions of `benchmark_v*.json`.
- Do not fold printability pass rate — a provider scoring 0.95 on detail but
  0.60 on printability is not production-suitable for J55 output.
- Do not use wall-clock time measured inside a notebook as latency — always
  use the `evals.run` harness, which timestamps at the HTTP layer.
