---
name: Evaluate and select text-to-3D AI provider
assignee: cto
---

Benchmark candidate text-to-3D AI providers to select the best option for Figurio's "Prompt to Print" pipeline.

## Candidates

1. **Meshy** — text-to-3D API with mesh export
2. **Tripo3D** — text and image to 3D model generation
3. **Luma Genie** — 3D generation from text/image
4. **CSM 3D** — common sense machines 3D generation
5. **Self-hosted model** — open-source alternatives (if viable)

## Evaluation Criteria

### Quality (40% weight)
- Geometric detail and accuracy
- Color/texture quality
- Printability: manifold geometry, minimum wall thickness, support-structure compatibility
- How much manual mesh repair is needed?

### Cost (25% weight)
- Per-generation pricing
- Monthly/annual plans and volume discounts
- Cost at projected volumes (100, 500, 1000 generations/month)

### Speed (15% weight)
- Generation time per model
- API response times
- Batch processing capabilities

### API Quality (10% weight)
- Documentation completeness
- SDK availability (Python preferred)
- Webhook/callback support for async generation
- Rate limits and quotas

### Strategic Fit (10% weight)
- Export formats (.glb, .obj, .stl — printable formats)
- Ability to specify scale/dimensions
- Content moderation capabilities (reject copyrighted character prompts)
- Reliability and uptime guarantees

## Process

1. Create test prompt set (10 diverse prompts representing typical customer requests)
2. Generate models from each provider using the same prompts
3. Evaluate each model against criteria
4. Attempt to print 2-3 top results via MCAE (coordinate with Head of Operations)
5. Score and recommend

## Deliverables

- Comparison matrix with scores across all criteria
- Sample outputs from each provider
- Cost projection at 100/500/1000 generations per month
- Recommendation with rationale
- Integration plan for selected provider (API docs, auth setup, error handling)

## Acceptance Criteria

- At least 3 providers tested with the same prompt set
- Cost analysis completed at multiple volume levels
- Printability tested on at least 2 generated models
- Clear recommendation with trade-off analysis
