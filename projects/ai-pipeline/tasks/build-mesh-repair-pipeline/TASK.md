---
name: Build Mesh Repair Pipeline
assignee: backend-engineer
project: ai-pipeline
---

Build the automated mesh repair pipeline that fixes common geometry issues in AI-generated 3D models to make them printable on the Stratasys J55 PolyJet.

## Requirements

- Automated detection and repair of non-manifold geometry
- Minimum wall thickness enforcement (based on J55 specs — typically 0.5mm+)
- Floating artifact removal (disconnected geometry below volume threshold)
- Hole filling for open meshes
- Normal direction correction (all normals facing outward)
- Support structure compatibility check
- Mesh decimation for overly complex models (maintain visual quality)
- Report generation: what was detected, what was fixed, confidence score

## Tech Stack

- Python with Blender scripting (bpy) for mesh operations
- Alternative: trimesh library for simpler operations
- NetFabb or Meshmixer CLI for advanced repair (if available)
- Queue-based processing (process models asynchronously)

## Pipeline Flow

1. Receive raw model from text-to-3D service
2. Run diagnostic checks (manifold, thickness, normals, floating parts)
3. Apply automated repairs in order of severity
4. Generate repair report with before/after metrics
5. Pass to QA review queue if repairs applied, or auto-approve if clean

## Acceptance Criteria

- Catches 90%+ of common geometry issues (non-manifold, thin walls, holes)
- Repairs do not degrade visual quality of the model
- Processing time under 5 minutes per model
- Repair report provides clear pass/fail with details
- Failed repairs are flagged for manual intervention
