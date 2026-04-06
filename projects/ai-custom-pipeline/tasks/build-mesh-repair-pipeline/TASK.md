---
name: Build mesh repair pipeline
slug: build-mesh-repair-pipeline
assignee: cto
priority: high
status: todo
---

# Build Mesh Repair Pipeline

Implement the automated mesh repair and printability validation pipeline that processes AI-generated 3D models for printing.

## Expected Subtasks

- CTO delegates to ML Engineer
- Automated repair steps: fix non-manifold edges, close holes, remove floating artifacts, ensure minimum wall thickness, optimize polygon count
- Tools: trimesh, pymeshlab, Blender Python API (bpy)
- Printability validation: manifold check, wall thickness analysis, support structure estimation, bounding box fit within size tiers
- Output: repaired mesh file + printability report (pass/fail with reasons)
- Integration as a FastAPI service callable from the order pipeline
- Logging and metrics (repair success rate, average repair time, common failure modes)
