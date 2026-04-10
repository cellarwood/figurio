---
name: ml-pipeline-guide
description: >
  Text-to-3D pipeline guide for Figurio's AI-custom figurine ("Prompt to Print") workflow.
  Covers API integration with Meshy, Tripo3D, Luma Genie, and CSM; automated mesh repair
  via Blender scripting; printability validation; and quality scoring before handing off to
  production at MCAE (Stratasys J55 PolyJet).
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
      - 3d-pipeline
---

# Text-to-3D Pipeline Guide

## When to Use

Use this skill when building, debugging, or extending the "Prompt to Print" pipeline —
from customer text prompt to a production-ready `.obj`/`.stl` mesh delivered to MCAE.

---

## Pipeline Overview

```
Customer Prompt
    │
    ▼
[1] Text-to-3D API  (Meshy → Tripo3D → Luma Genie → CSM, in fallback order)
    │
    ▼
[2] Raw Mesh Retrieval  (.glb / .obj)
    │
    ▼
[3] Blender Mesh Repair  (automated script)
    │
    ▼
[4] Printability Validation  (wall thickness, manifold, support geometry)
    │
    ▼
[5] Quality Scoring  (auto-score; if below threshold → retry API or flag for review)
    │
    ▼
[6] Customer Preview Render  (Blender EEVEE, 360° turntable)
    │
    ▼
[7] Production Export  (.obj + textures → MCAE SFTP)
```

---

## 1. Text-to-3D API Integration

### Provider Priority

Call providers in this order; advance to the next on HTTP error, timeout (>90 s), or
quality score below threshold:

| Priority | Provider  | SDK/Endpoint              | Typical latency |
|----------|-----------|---------------------------|-----------------|
| 1        | Meshy     | `meshy-ai` Python client  | 30–60 s         |
| 2        | Tripo3D   | REST `/v2/task`           | 45–90 s         |
| 3        | Luma Genie| REST `/dream-machine/...` | 60–120 s        |
| 4        | CSM       | REST `/session`           | 90–180 s        |

### Prompt Construction

Always inject Figurio style tokens into the raw customer prompt before sending:

```python
STYLE_PREFIX = (
    "full-color 3D-printed figurine, PolyJet material, "
    "smooth surface, neutral A-pose, single unified mesh, "
    "no loose parts, no internal cavities, "
)

def build_api_prompt(customer_prompt: str) -> str:
    return STYLE_PREFIX + customer_prompt.strip()
```

### Meshy Integration

```python
import meshy

client = meshy.Client(api_key=settings.MESHY_API_KEY)

task = client.text_to_3d.create(
    prompt=build_api_prompt(customer_prompt),
    art_style="realistic",
    negative_prompt="multiple pieces, hollow interior, low poly",
    target_polycount=200_000,   # Figurio standard: 150k–250k faces
)
task.wait(timeout=90)
mesh_url = task.model_urls["obj"]
```

### Tripo3D Integration

```python
import httpx

resp = httpx.post(
    "https://api.tripo3d.ai/v2/openapi/task",
    headers={"Authorization": f"Bearer {settings.TRIPO3D_API_KEY}"},
    json={
        "type": "text_to_model",
        "prompt": build_api_prompt(customer_prompt),
        "model_version": "v2.0-20240919",
        "face_limit": 200000,
    },
    timeout=90,
)
task_id = resp.json()["data"]["task_id"]
# Poll GET /v2/openapi/task/{task_id} until status == "success"
```

### Luma Genie / CSM

Use their respective REST SDKs following the same pattern: submit, poll, download `.glb`.
Always convert `.glb` → `.obj` via Blender before the repair step.

---

## 2. Blender Mesh Repair Script

Run all repairs inside a headless Blender process:

```bash
blender --background --python scripts/repair_mesh.py -- \
    --input raw_mesh.obj \
    --output repaired_mesh.obj
```

### `scripts/repair_mesh.py` — Key Operations (in order)

```python
import bpy, bmesh

def repair(input_path: str, output_path: str):
    bpy.ops.wm.obj_import(filepath=input_path)
    obj = bpy.context.selected_objects[0]
    bpy.context.view_layer.objects.active = obj

    bm = bmesh.new()
    bm.from_mesh(obj.data)

    # 1. Remove duplicate vertices (threshold: 0.01 mm)
    bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=0.0001)

    # 2. Fill holes (figurines sometimes have open bases)
    bmesh.ops.holes_fill(bm, edges=[e for e in bm.edges if e.is_boundary], sides=0)

    # 3. Recalculate normals outward
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)

    # 4. Dissolve degenerate faces
    bmesh.ops.dissolve_degenerate(bm, dist=0.0001, edges=bm.edges)

    bm.to_mesh(obj.data)
    bm.free()

    # 5. Apply decimate if face count > 250k
    if len(obj.data.polygons) > 250_000:
        mod = obj.modifiers.new("Decimate", "DECIMATE")
        mod.ratio = 250_000 / len(obj.data.polygons)
        bpy.ops.object.modifier_apply(modifier="Decimate")

    bpy.ops.wm.obj_export(filepath=output_path, export_materials=True)
```

---

## 3. Printability Validation

Validation runs after repair. All checks are in `pipeline/validate.py`.

| Check | Threshold | Action on failure |
|-------|-----------|-------------------|
| Manifold (watertight) | Zero open edges | Re-repair or reject |
| Minimum wall thickness | ≥ 1.0 mm (J55 spec) | Flag for manual review |
| Maximum bounding box | 200 × 200 × 300 mm | Scale down automatically |
| Non-manifold vertices | Zero | Re-repair |
| Face count | 50k – 250k | Remesh |
| Intersecting geometry | None | Re-repair |

```python
def validate_printability(mesh_path: str) -> ValidationResult:
    # Uses Blender Python API via subprocess for geometry checks
    # Uses trimesh for thickness sampling (ray-cast method, 500 sample points)
    ...
```

See `pipeline/validate.py` for the full implementation.

---

## 4. Quality Scoring

Score each output 0–100 before sending to customer preview or production.
Retry the next provider if score < 60.

| Dimension | Weight | Measured by |
|-----------|--------|-------------|
| Geometric detail (faces, feature sharpness) | 30% | Blender geometry analysis |
| Prompt adherence | 35% | CLIP similarity (ViT-L/14) between prompt and render |
| Surface smoothness | 20% | Average dihedral angle variance |
| Printability (all checks passed) | 15% | `validate_printability()` boolean |

```python
import torch, clip
from PIL import Image

model, preprocess = clip.load("ViT-L/14", device="cuda")

def prompt_adherence_score(prompt: str, render_path: str) -> float:
    image = preprocess(Image.open(render_path)).unsqueeze(0).to("cuda")
    text  = clip.tokenize([prompt]).to("cuda")
    with torch.no_grad():
        logits, _ = model(image, text)
    # Normalize cosine similarity to 0–1
    return float(torch.sigmoid(logits[0][0]).item())
```

---

## 5. Retry & Escalation Logic

```python
PROVIDERS = ["meshy", "tripo3d", "luma_genie", "csm"]
QUALITY_THRESHOLD = 60

for provider in PROVIDERS:
    result = run_provider(provider, prompt)
    if result.quality_score >= QUALITY_THRESHOLD:
        break
else:
    # All providers failed — escalate to human review queue
    flag_for_manual_review(order_id, reason="all_providers_below_threshold")
```

---

## Anti-patterns

- Do NOT send the raw customer prompt to the API without the style prefix — outputs will be hollow, multi-part, or wrong scale.
- Do NOT skip the repair step even if the provider claims a "watertight" mesh — all providers occasionally return open edges.
- Do NOT use Blender's `REMESH` modifier before repair — it destroys texture UV maps needed for J55 full-color printing.
- Do NOT export as `.stl` for production — MCAE requires `.obj` + `.mtl` + texture PNGs for color data.
