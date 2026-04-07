---
name: Build automated mesh repair pipeline using Blender scripting
assignee: backend-engineer
project: ai-pipeline
---

Build an automated mesh repair system that prepares AI-generated 3D models for PolyJet printing.

- Blender Python scripting (bpy) or CLI subprocess for mesh operations
- Fix non-manifold geometry (close holes, merge vertices)
- Enforce minimum wall thickness for PolyJet printing (≥1mm)
- Remove floating artifacts and disconnected geometry
- Validate support-structure compatibility
- Check and fix mesh orientation (normals facing outward)
- Preserve vertex colors/textures through repair process
- Output repair report: what was fixed, confidence score, any issues requiring human review
- Queue repaired model for QA review if automated repair succeeds
- Flag model for manual intervention if repair confidence is below threshold
- Performance target: repair should complete within 2-5 minutes per model
