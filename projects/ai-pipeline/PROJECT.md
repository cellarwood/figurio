---
name: AI Figurine Pipeline
description: Text-to-3D generation pipeline — AI model integration, automated mesh repair, QA review queue, preview rendering
slug: ai-pipeline
owner: ml-ai-engineer
---

## Scope

Build the AI-powered custom figurine pipeline that converts text prompts into printable 3D models. Includes integration with text-to-3D APIs (Meshy, Tripo3D, Luma), automated mesh repair for printability, an internal QA review queue, and a preview rendering service for customer approval.

## Tech Stack

- Python with PyTorch
- Text-to-3D APIs (Meshy, Tripo3D, Luma — benchmark and select)
- Blender scripting for mesh repair
- NetFabb for manifold geometry fixes

## Success Criteria

- 80%+ of generated models pass automated printability checks
- Average mesh repair time under 5 minutes
- Preview renders ready within 1 hour of generation
- Content moderation blocks copyrighted character requests
