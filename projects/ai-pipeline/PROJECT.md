---
name: AI Prompt-to-Print Pipeline
description: Text-to-3D generation, mesh repair, preview rendering, and customer approval workflow for custom figurines
slug: ai-pipeline
owner: ml-engineer
---

## Scope

Build the complete AI pipeline that enables customers to describe a figurine and receive a printable 3D model.

## Key Deliverables

- Text-to-3D service evaluation and integration
- Async generation service with job queue
- Automated mesh repair pipeline (Blender scripting)
- Preview renderer for customer approval
- Customer approval/revision frontend workflow
- Human QA review interface for admin

## Tech Stack

- Python with PyTorch for ML components
- Blender Python API for mesh repair
- FastAPI for generation service API
- Text-to-3D service API (Meshy, Tripo3D, or similar)

## Success Criteria

- Generation latency under 5 minutes per model
- Mesh repair pipeline passes 90%+ of models for printability
- Customer preview renders accurately represent final print
- Two-stage deposit payment flow working
