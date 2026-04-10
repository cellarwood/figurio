---
name: model-evaluation
description: >
  Evaluate 3D model output quality for Figurio figurines before production handoff to MCAE
  (Stratasys J55 PolyJet). Covers manifold geometry checks, minimum wall thickness validation
  (1.0 mm J55 spec), support-structure compatibility, PolyJet color-texture requirements,
  and customer preview rendering via Blender EEVEE.
allowed-tools:
  - Read
  - Write
  - Bash
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - ml
      - quality
      - 3d-pipeline
---

# Model Evaluation

## When to Use

Run this evaluation after the Blender mesh repair step and before sending a customer
preview render or dispatching files to MCAE. Also use it when triaging a failed or
flagged order, or when comparing outputs across text-to-3D providers.

---

## Evaluation Checklist

Every model must pass all **hard gates** before proceeding. **Soft checks** produce
warnings and a score deduction but do not block production.

| # | Check | Gate | Threshold |
|---|-------|------|-----------|
| 1 | Manifold (watertight) | Hard | 0 open edges, 0 non-manifold verts |
| 2 | Minimum wall thickness | Hard | ≥ 1.0 mm everywhere (J55 spec) |
| 3 | Bounding box | Hard | ≤ 200 × 200 × 300 mm |
| 4 | Face count | Hard | 50k – 250k faces |
| 5 | Self-intersecting geometry | Hard | None |
| 6 | Support-structure compatibility | Hard | No overhangs > 70° without base contact |
| 7 | UV map present and packed | Hard | Required for J55 full-color |
| 8 | Texture resolution | Soft | ≥ 2048 × 2048 px |
| 9 | Surface smoothness | Soft | Mean dihedral angle variance < 0.15 rad² |
| 10 | CLIP prompt adherence | Soft | Score ≥ 0.55 (ViT-L/14) |

---

## 1. Manifold Geometry Check

The J55 PolyJet slicer rejects any non-manifold mesh. Use `trimesh` for fast checks and
Blender for repair-relevant detail.

```python
import trimesh

def check_manifold(mesh_path: str) -> dict:
    mesh = trimesh.load(mesh_path, force="mesh")
    return {
        "is_watertight": mesh.is_watertight,
        "open_edges": len(trimesh.grouping.group_rows(
            mesh.edges_sorted, require_count=1
        )),
        "non_manifold_verts": int((~mesh.is_volume) and not mesh.is_watertight),
    }
```

If `is_watertight` is `False`, send back to `scripts/repair_mesh.py` (see
`ml-pipeline-guide` skill) before re-evaluating. Do not pass a non-manifold mesh.

---

## 2. Minimum Wall Thickness (J55 Spec)

The Stratasys J55 requires a minimum wall thickness of **1.0 mm** for structural
integrity in PolyJet VeroUltra material. Use ray-casting to sample thickness at 500
random surface points.

```python
import trimesh
import numpy as np

def check_wall_thickness(mesh_path: str, min_thickness_mm: float = 1.0) -> dict:
    mesh = trimesh.load(mesh_path, force="mesh")
    # Sample surface points
    points, face_ids = trimesh.sample.sample_surface(mesh, 500)
    normals = mesh.face_normals[face_ids]

    # Cast rays inward; thickness = distance to opposite surface
    ray_origins = points + normals * 0.001        # offset to avoid self-hit
    ray_dirs    = -normals
    hits, _, _ = mesh.ray.intersects_location(ray_origins, ray_dirs)

    if len(hits) == 0:
        return {"min_mm": None, "violations": 500, "pass": False}

    dists = np.linalg.norm(hits - points[:len(hits)], axis=1) * 1000  # → mm
    violations = int((dists < min_thickness_mm).sum())
    return {
        "min_mm": float(dists.min()),
        "mean_mm": float(dists.mean()),
        "violations": violations,          # sample points below threshold
        "pass": violations == 0,
    }
```

Violation count > 0 triggers manual review — do not auto-repair wall thickness, as
fixes require human artistic judgment.

---

## 3. Support-Structure Compatibility

The J55 prints with SUP706 soluble support. Overhangs beyond 70° from vertical require
support geometry that must be reachable by the soluble bath — internal cavities cannot
be supported.

```python
import trimesh
import numpy as np

def check_overhangs(mesh_path: str, max_angle_deg: float = 70.0) -> dict:
    mesh = trimesh.load(mesh_path, force="mesh")
    up = np.array([0, 0, 1])
    angles = np.degrees(np.arccos(
        np.clip(mesh.face_normals @ up, -1, 1)
    ))
    # Faces pointing downward (angle > 90) that are overhang candidates
    overhang_faces = (angles > (180 - max_angle_deg)).sum()
    return {
        "overhang_face_count": int(overhang_faces),
        "overhang_ratio": float(overhang_faces / len(mesh.faces)),
        "pass": overhang_faces == 0,      # hard gate: flag, not reject
    }
```

Overhang ratio > 0.05 (>5% of faces) is flagged for MCAE to confirm support plan.
Figurines in A-pose typically pass; dynamic poses (flying, crouching) often fail.

---

## 4. PolyJet Color-Texture Requirements

Full-color J55 output requires:

- `.obj` + `.mtl` + texture PNG(s) — never bare `.stl`
- Texture atlas resolution: **2048 × 2048 px minimum**, 4096 preferred
- All faces UV-mapped (zero un-mapped faces)
- Color gamut: sRGB; MCAE converts to J55 color profile internally

```python
from PIL import Image
import re

def check_texture(obj_path: str, mtl_path: str) -> dict:
    tex_files = re.findall(r"map_Kd (.+\.png)", open(mtl_path).read())
    results = []
    for tex in tex_files:
        img = Image.open(tex)
        w, h = img.size
        results.append({
            "file": tex,
            "resolution": (w, h),
            "pass": w >= 2048 and h >= 2048,
        })
    return {"textures": results, "all_pass": all(r["pass"] for r in results)}
```

---

## 5. Customer Preview Render

After all hard gates pass, generate the preview render for the customer order page.

```bash
blender --background --python scripts/render_preview.py -- \
    --input repaired_mesh.obj \
    --output preview_360.gif \
    --frames 36 \
    --resolution 800
```

### Render Settings (`scripts/render_preview.py`)

- Engine: **EEVEE** (fast, sufficient for preview fidelity)
- Lighting: 3-point studio setup, neutral gray background (`#CCCCCC`)
- Camera: orbit 360° in 36 frames (10° steps), 800 × 800 px
- Output: animated GIF for the order confirmation page; also export frame 18 (front
  view) as `preview_front.jpg` for email thumbnails

---

## 6. Evaluation Result Schema

All checks write results to a shared dict before scoring:

```python
EvaluationResult = {
    "order_id": str,
    "provider": str,               # which text-to-3D API was used
    "manifold": dict,              # from check_manifold()
    "wall_thickness": dict,        # from check_wall_thickness()
    "overhangs": dict,             # from check_overhangs()
    "texture": dict,               # from check_texture()
    "face_count": int,
    "bounding_box_mm": [x, y, z],
    "quality_score": float,        # 0–100 composite (see ml-pipeline-guide)
    "hard_gates_passed": bool,
    "action": str,                 # "approve" | "repair" | "manual_review" | "reject"
}
```

### Action Routing

| Condition | Action |
|-----------|--------|
| All hard gates pass, quality ≥ 60 | `approve` → render preview → MCAE handoff |
| Non-manifold or self-intersecting | `repair` → re-run `repair_mesh.py` → re-evaluate |
| Wall thickness violation | `manual_review` → human artist queue |
| Bounding box exceeded | `repair` → auto-scale → re-evaluate |
| Quality < 60, all gates pass | retry next text-to-3D provider |
| All providers exhausted | `reject` → notify ops team |

---

## Anti-patterns

- Do NOT approve a mesh with `is_watertight: False` — the J55 slicer will fail silently and produce a defective print.
- Do NOT auto-fix wall thickness violations by scaling the mesh — this distorts the figurine proportions; always send to human review.
- Do NOT skip the texture resolution check — low-resolution textures print as visible pixelation on the J55 at 600 DPI.
- Do NOT use `trimesh.repair.fix_winding()` as a substitute for the full Blender repair pipeline — it does not handle complex topology.
- Do NOT render the customer preview before all hard gates pass — customers must never see a preview for a model that cannot be printed.
