---
name: Build automated mesh repair pipeline
assignee: backend-engineer
project: ai-pipeline
---

# Build automated mesh repair pipeline

Build Python service using Blender scripting (bpy) and/or NetFabb for automated mesh repair.

## Fix targets

- Non-manifold geometry
- Thin walls below minimum threshold
- Floating artifacts
- Topology issues

Input: raw 3D model from AI service. Output: print-ready model with repair report. Run as async worker.
