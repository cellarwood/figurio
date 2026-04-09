---
name: Integrate Text-to-3D API
assignee: backend-engineer
project: mvp-storefront
---

Integrate a text-to-3D AI service and build the automated mesh repair pipeline.

- Evaluate text-to-3D APIs (Meshy, Tripo3D, Luma Genie, CSM 3D) for quality, cost, and reliability
- Implement API integration with the selected provider
- Build async job processing with Celery: prompt → API call → receive model → mesh repair → QA queue
- Implement automated mesh repair using Blender scripting (bpy) or trimesh: fix non-manifold geometry, enforce minimum wall thickness, remove floating artifacts
- Validate repaired models against printability constraints (manifold check, wall thickness, support structure compatibility)
- Build content moderation layer to reject prompts requesting copyrighted characters
- Create API endpoints: POST /custom-figurines (submit prompt), GET /custom-figurines/{id} (check status/preview)
- Store generated models in object storage with URLs in the database
