---
name: mesh-pipeline-guide
description: >
  3D mesh repair and printability validation pipeline for Figurio's AI-custom
  and catalog figurine workflows. Covers Blender scripting conventions, printability
  checks (manifold geometry, wall thickness >= 1 mm, support structure compatibility),
  automated repair steps, and file format handling (STL/OBJ/GLB) before files are
  sent to the MCAE PolyJet printing partner.
allowed-tools:
  - Read
  - Grep
  - Bash
metadata:
  paperclip:
    tags: [engineering, backend, 3d-pipeline]
---

# Mesh Pipeline Guide

## When to Use

Apply this skill whenever writing or modifying code in `app/mesh/` — the automated pipeline that accepts a raw 3D model from the AI generation service and prepares it for submission to MCAE for PolyJet printing.

## Pipeline Stages

```
Input file (STL/OBJ/GLB)
    └─► 1. Ingest & normalize format → internal GLB
    └─► 2. Validation (non-manifold check, wall thickness, bounding box)
    └─► 3. Automated repair (Blender scripting)
    └─► 4. Post-repair re-validation
    └─► 5. Export STL for MCAE
    └─► 6. Render preview PNG for customer approval
```

Each stage is a Python function in `app/mesh/pipeline.py`. Failures at stage 2 or 4 raise `MeshValidationError` — the job is flagged for human QA review, not auto-retried.

## File Format Handling

Accepted input: STL (binary or ASCII), OBJ (+MTL), GLB/GLTF.

Always normalize to GLB as the internal working format before any processing step. Use the `trimesh` library for loading and conversion:

```python
import trimesh

def load_mesh(path: str) -> trimesh.Trimesh:
    mesh = trimesh.load(path, force="mesh")
    if isinstance(mesh, trimesh.Scene):
        mesh = trimesh.util.concatenate(mesh.dump())
    return mesh
```

Export to binary STL for MCAE submission (they accept STL; do not send GLB):

```python
def export_stl(mesh: trimesh.Trimesh, out_path: str) -> None:
    mesh.export(out_path, file_type="stl")
```

## Printability Validation

All checks live in `app/mesh/validators.py`. Each check returns a `ValidationResult(passed: bool, code: str, detail: str)`.

### 1. Manifold Geometry

The mesh must be watertight (no open edges, no holes).

```python
def check_manifold(mesh: trimesh.Trimesh) -> ValidationResult:
    if not mesh.is_watertight:
        return ValidationResult(False, "NON_MANIFOLD", f"{len(mesh.faces)} faces, not watertight")
    return ValidationResult(True, "MANIFOLD_OK", "")
```

### 2. Wall Thickness

Minimum wall thickness for Stratasys J55 PolyJet: **1.0 mm**. Use a ray-casting approach via trimesh:

```python
MINIMUM_WALL_MM = 1.0

def check_wall_thickness(mesh: trimesh.Trimesh) -> ValidationResult:
    # Sample surface points and cast inward rays; measure distance to opposite face
    origins, normals = trimesh.sample.sample_surface(mesh, count=2000)
    inward = -normals
    hits = mesh.ray.intersects_location(origins + inward * 0.01, inward)[0]
    # compute distances ... (see app/mesh/thickness.py for full impl)
    thin_count = sum(1 for d in distances if d < MINIMUM_WALL_MM)
    if thin_count / len(distances) > 0.05:  # >5% of sampled points too thin
        return ValidationResult(False, "WALL_TOO_THIN", f"{thin_count} thin samples")
    return ValidationResult(True, "WALL_OK", "")
```

### 3. Bounding Box (Size Tiers)

Enforce that the mesh fits within the ordered size tier before prep:

| Tier | Max bounding box (mm) |
|------|----------------------|
| Small | 80 × 80 × 80 |
| Medium | 150 × 150 × 150 |
| Large | 250 × 250 × 250 |

```python
SIZE_TIER_LIMITS_MM = {
    "small": (80, 80, 80),
    "medium": (150, 150, 150),
    "large": (250, 250, 250),
}

def check_bounding_box(mesh: trimesh.Trimesh, tier: str) -> ValidationResult:
    extents = mesh.bounding_box.extents  # (x, y, z) in mesh units
    limits = SIZE_TIER_LIMITS_MM[tier]
    if any(e > l for e, l in zip(extents, limits)):
        return ValidationResult(False, "EXCEEDS_SIZE_TIER", f"extents {extents}")
    return ValidationResult(True, "SIZE_OK", "")
```

### 4. Support Structure Compatibility

Overhangs steeper than 45° require support material. For PolyJet this is automatic, but extremely large unsupported overhangs increase material cost and failure risk. Flag (warn, not fail) faces with downward-facing normals at angles > 45° that span more than 30% of the total surface:

```python
OVERHANG_ANGLE_DEG = 45

def check_overhangs(mesh: trimesh.Trimesh) -> ValidationResult:
    down = np.array([0, 0, -1])
    angles = np.degrees(np.arccos(np.clip(mesh.face_normals.dot(down), -1, 1)))
    overhang_faces = np.sum(angles < OVERHANG_ANGLE_DEG)
    ratio = overhang_faces / len(mesh.faces)
    if ratio > 0.30:
        return ValidationResult(False, "HEAVY_OVERHANG", f"{ratio:.0%} overhang faces")
    return ValidationResult(True, "OVERHANG_OK", "")
```

## Blender Scripting for Automated Repair

Use Blender in **headless mode** for repair steps that `trimesh` cannot handle (complex non-manifold topology, self-intersections). Run Blender as a subprocess from the Celery task:

```python
import subprocess, sys

BLENDER_BIN = "/usr/bin/blender"  # set via env var BLENDER_PATH in production

def run_blender_repair(input_stl: str, output_stl: str) -> None:
    script = "app/mesh/blender_repair.py"
    result = subprocess.run(
        [BLENDER_BIN, "--background", "--python", script,
         "--", input_stl, output_stl],
        capture_output=True, text=True, timeout=120
    )
    if result.returncode != 0:
        raise MeshRepairError(f"Blender repair failed: {result.stderr[-500:]}")
```

### `app/mesh/blender_repair.py` Conventions

This script runs inside Blender's Python environment — it must not import `trimesh` or other venv packages. Parse `sys.argv` after `--` to get paths:

```python
import bpy, sys, bmesh as bm_module

def main():
    argv = sys.argv[sys.argv.index("--") + 1:]
    input_path, output_path = argv[0], argv[1]

    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_mesh.stl(filepath=input_path)
    obj = bpy.context.selected_objects[0]
    bpy.context.view_layer.objects.active = obj

    # Enter edit mode for bmesh repair
    bpy.ops.object.mode_set(mode="EDIT")
    bm = bm_module.from_edit_mesh(obj.data)

    # 1. Remove doubles (merge vertices within 0.01 mm)
    bm_module.ops.remove_doubles(bm, verts=bm.verts, dist=0.01)
    # 2. Fill holes
    bm_module.ops.holes_fill(bm, edges=bm.edges)
    # 3. Recalculate normals outward
    bm_module.ops.recalc_face_normals(bm, faces=bm.faces)

    bm_module.update_edit_mesh(obj.data)
    bpy.ops.object.mode_set(mode="OBJECT")
    bpy.ops.export_mesh.stl(filepath=output_path)

main()
```

Repair steps in order (do not skip):
1. Remove duplicate vertices (threshold 0.01 mm)
2. Fill open holes
3. Recalculate face normals (outward-facing)
4. Dissolve degenerate faces (zero-area triangles)

## Preview Render

After repair, generate a 512×512 PNG turntable preview for the customer approval step. Use Blender headless with a simple orbital camera script at `app/mesh/blender_render.py`. Store output in object storage; return a signed URL via the AI job API response.

## Error Codes

| Code | Meaning | Outcome |
|------|---------|---------|
| `NON_MANIFOLD` | Mesh has open edges | Auto-repair attempted; if re-validation fails → human QA |
| `WALL_TOO_THIN` | Wall below 1 mm | Human QA required; customer notified |
| `EXCEEDS_SIZE_TIER` | Model too large for tier | Job blocked; customer must re-order correct tier |
| `HEAVY_OVERHANG` | >30% overhang surface | Warning only; passes to MCAE with note |
| `MESH_REPAIR_ERROR` | Blender subprocess failed | Human QA; Celery task does not retry |

## Anti-patterns

- Do not run Blender repair synchronously in a FastAPI request handler — always dispatch to a Celery task on the `mesh_repair` queue
- Do not send OBJ or GLB files to MCAE — always export binary STL
- Do not skip post-repair re-validation — a repair step can introduce new geometry errors
- Do not use ASCII STL format for export (large file size, no benefit for PolyJet workflow)
- Do not import Blender (`bpy`) inside the main application process — only in the headless subprocess script
