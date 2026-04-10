---
name: Build AI prompt-to-print pipeline with text-to-3D and mesh repair
assignee: backend-engineer
project: platform-backend
---

Build the AI custom figurine generation pipeline:

- Text-to-3D API integration (Meshy or Tripo3D) with prompt handling
- Async job queue (Celery + Redis) for generation requests
- Job status tracking: queued → generating → repairing → preview_ready → approved → printing
- Automated mesh repair: Blender scripting for non-manifold geometry, wall thickness validation (>=1mm), floating artifact removal
- Content moderation: reject prompts requesting copyrighted characters
- Generated model storage and management
- Printability validation report per model
