---
name: model-evaluation
description: >
  Benchmarking framework for comparing 3D generation APIs (Meshy, Tripo3D, Luma)
  used in Figurio's "Prompt to Print" pipeline. Covers evaluation dimensions
  (output quality, generation speed, cost per model, printability), scoring
  rubrics, test prompt corpus, and how to record and act on results.
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
      - evaluation
---

# 3D Generation API Benchmarking

## Purpose

Figurio periodically evaluates generation providers to decide which should be
the active default (`FIGURIO_3D_PROVIDER`) and to track quality regressions
after provider model updates. Evaluations are triggered manually by the
ML/AI Engineer or automatically when a provider updates its model version.

## Evaluation Dimensions

Every candidate provider is scored across four dimensions:

| Dimension | Weight | Description |
|---|---|---|
| Output Quality | 35% | Visual fidelity and detail of generated figurine |
| Printability | 35% | Mesh suitability for Stratasys J55 PolyJet printing |
| Generation Speed | 15% | Wall-clock time from API submission to download-ready |
| Cost per Model | 15% | USD cost per successfully generated and print-ready mesh |

Printability and quality share equal weight because a visually stunning mesh
that cannot be printed has zero value for Figurio.

## Test Prompt Corpus

The canonical evaluation corpus lives at `evals/prompts/corpus_v2.json`.
It contains 40 prompts across four categories:

| Category | Count | Example |
|---|---|---|
| Human figures | 15 | "A Viking warrior in chainmail, holding an axe" |
| Animals | 10 | "A sitting tabby cat with detailed fur texture" |
| Fantasy creatures | 10 | "A small dragon coiled around a crystal ball" |
| Abstract/objects | 5 | "A trophy shaped like a rocket ship" |

Do not add prompts to the corpus without a PR review — corpus stability is
required for longitudinal comparison.

## Running an Evaluation

```bash
# From the project root
python evals/run_benchmark.py \
  --providers meshy tripo3d luma \
  --corpus evals/prompts/corpus_v2.json \
  --output evals/results/$(date +%Y-%m-%d)/ \
  --repetitions 3
```

The script submits each prompt to each provider `--repetitions` times,
downloads the resulting meshes, runs the automated scoring pipeline, and
writes per-prompt and aggregate results to the output directory.

Use `--providers` to limit to a subset when re-evaluating a single provider
after a model update.

## Scoring

### Output Quality (automated + human)

Automated (50% of quality score):
- CLIP similarity score between the input prompt and a render of the mesh (use `evals/scoring/clip_score.py`)
- Target: CLIP score ≥ 0.28 for a prompt to count as a pass

Human review (50% of quality score):
- 1–5 Likert scale scored by two independent reviewers using `evals/review/rubric.md`
- Criteria: overall likeness to prompt, surface detail, color accuracy, proportions
- Resolve disagreements ≥ 2 points apart by a third reviewer

### Printability (automated)

Run `evals/scoring/printability.py` against each downloaded mesh. It checks:

| Check | Pass condition |
|---|---|
| Watertight | `trimesh.is_watertight == True` |
| Non-manifold edges | 0 |
| Minimum wall thickness | ≥ 1.0 mm (sampled at 5 000 points) |
| Triangle count | ≤ 150 000 (after Blender repair) |
| Bounding box | fits within 200 × 200 × 200 mm |

Printability score for a prompt = (checks passed / 5). A mesh that is not
watertight scores 0 regardless of other checks (non-printable mesh is fatal).

### Generation Speed

Measured as wall-clock seconds from API task submission to mesh file fully
downloaded. Averaged over all repetitions. Timeout cutoff: 600 s (failures
counted as 600 s for averaging purposes).

### Cost per Model

Use the provider's published per-generation pricing at the time of the
evaluation run. Record the exact pricing tier and date in
`evals/results/{date}/cost_notes.txt`. Do not amortize API subscription fees.

## Result Schema

Each evaluation run produces `evals/results/{date}/summary.json`:

```json
{
  "run_date": "2026-04-11",
  "corpus_version": "v2",
  "providers": {
    "meshy": {
      "quality_clip_avg": 0.31,
      "quality_human_avg": 3.8,
      "printability_pass_rate": 0.82,
      "speed_avg_seconds": 187,
      "cost_per_model_usd": 0.14
    },
    "tripo3d": { "..." : "..." },
    "luma": { "..." : "..." }
  },
  "weighted_scores": {
    "meshy": 0.74,
    "tripo3d": 0.71,
    "luma": 0.65
  },
  "recommended_provider": "meshy"
}
```

Per-prompt breakdowns are stored in `evals/results/{date}/per_prompt/`.

## Weighted Score Calculation

```python
def weighted_score(provider_results):
    q = (provider_results["quality_clip_avg"] / 0.35 * 0.5 +
         provider_results["quality_human_avg"] / 5.0 * 0.5) * 0.35
    p = provider_results["printability_pass_rate"] * 0.35
    s = (1 - provider_results["speed_avg_seconds"] / 600) * 0.15
    c = (1 - provider_results["cost_per_model_usd"] / 0.50) * 0.15
    return q + p + s + c
```

Adjust the cost normalizer (`0.50`) if provider pricing changes significantly.

## Acting on Results

| Outcome | Action |
|---|---|
| Current provider wins or ties | No change. Record results in `evals/results/`. |
| Challenger wins by ≥ 0.05 weighted score | Open PR to update `FIGURIO_3D_PROVIDER` default and provider config. |
| Any provider printability pass rate < 0.60 | Remove from rotation immediately; notify CTO and ops. |
| Current provider regresses by ≥ 0.05 vs. last run | Trigger unscheduled full evaluation across all providers. |

Provider switches require sign-off from the CTO agent before merging to main.

## Storing Results

All evaluation results must be committed to the `evals/results/` directory in
the monorepo so historical comparisons remain possible. Use the ISO date as the
directory name (`YYYY-MM-DD`). If multiple runs occur on the same day, append
`-2`, `-3`, etc.

## Anti-patterns

- Do not evaluate providers using ad-hoc prompts — always use the canonical corpus for comparability.
- Do not record only aggregate scores — per-prompt breakdowns are required to diagnose category-specific regressions.
- Do not switch providers based on speed or cost alone — printability is a hard constraint for Figurio's PolyJet workflow.
- Do not run evaluations against production provider API keys if a sandbox environment is available.
