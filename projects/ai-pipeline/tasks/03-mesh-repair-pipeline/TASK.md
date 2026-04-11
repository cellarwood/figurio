---
name: Build automated mesh repair pipeline using Blender scripting
assignee: ml-engineer
project: ai-pipeline
---

Mesh repair automation:
- Blender Python API integration
- Fix non-manifold geometry
- Detect and fix thin walls (below PolyJet minimum)
- Remove floating artifacts and disconnected geometry
- Verify watertight mesh
- Printability scoring (pass/fail with details)
- Output repaired mesh in print-ready format
