---
name: AI Custom Pipeline
slug: ai-custom-pipeline
status: active
---

# AI Custom Pipeline

Build the "Prompt to Print" pipeline that lets customers describe a figurine in natural language and receive a 3D-printed result.

## Scope

- Text-to-3D model generation via third-party API (Meshy, Tripo3D, Luma Genie, CSM 3D)
- Automated mesh repair (non-manifold geometry, thin walls, floating artifacts)
- Printability validation (wall thickness, support analysis, manifold check)
- 3D preview rendering for customer approval
- Content moderation to reject IP-infringing prompts
- Integration with the storefront (prompt UI, preview approval, two-stage payment)

## Tech Stack

- **ML:** Python, PyTorch, Hugging Face, trimesh, pymeshlab
- **Mesh repair:** Blender Python API (bpy), NetFabb CLI
- **Rendering:** Blender or three.js server-side rendering
- **API:** FastAPI endpoints integrated with the main backend

## Deliverables

1. Text-to-3D API evaluation and selection (benchmark quality, cost, speed)
2. Automated mesh repair pipeline
3. Printability validation service
4. Preview rendering service
5. Content moderation (prompt filtering)
6. Frontend prompt UI with preview approval flow
