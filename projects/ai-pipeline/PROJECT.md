---
name: AI Prompt-to-Print Pipeline
description: Build the end-to-end AI pipeline from text prompt to 3D model generation, mesh repair, QA review, and customer approval
slug: ai-pipeline
owner: cto
---

## Scope

Build the AI-powered custom figurine pipeline with these capabilities:

- Text prompt intake via the storefront
- Integration with text-to-3D generation API (Meshy or Tripo3D)
- Automated mesh repair using Blender scripting (fix non-manifold geometry, thin walls, floating artifacts)
- Admin QA review dashboard for 3D technician validation
- Customer preview with rendered 3D model and approval/rejection flow
- Two-stage payment: 50% deposit at prompt submission, 50% on preview approval

## Success Criteria

- Customer can submit a text prompt and receive a 3D model preview within the target turnaround
- Automated mesh repair handles common geometry issues without manual intervention
- QA dashboard allows technicians to review, annotate, and approve/reject models
- Customer approval flow triggers remaining 50% payment and queues model for printing
- Pipeline handles failures gracefully (generation timeout, repair failure, customer rejection)

## Workspace

This project targets the main application repository at github.com/cellarwood/figurio.
