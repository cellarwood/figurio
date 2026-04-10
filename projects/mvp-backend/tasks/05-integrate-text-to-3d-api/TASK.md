---
name: Integrate text-to-3D API (Meshy/Tripo3D) with mesh repair
assignee: ml-engineer
project: mvp-backend
---

Build the AI-powered text-to-3D generation pipeline.

## Requirements
- Integration with Meshy or Tripo3D API for text-to-3D generation
- Automated mesh repair pipeline using Blender scripting:
  - Fix non-manifold geometry
  - Enforce minimum wall thickness for PolyJet
  - Remove floating artifacts
  - Optimize topology
- Printability validation checks (manifold, wall thickness, support structures)
- Quality scoring system for generated models
- Preview render generation for customer approval
- Async job queue for long-running generation tasks
