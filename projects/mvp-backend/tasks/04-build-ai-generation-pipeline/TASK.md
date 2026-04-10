---
name: Build AI figurine generation pipeline
assignee: backend-engineer
project: mvp-backend
---

Build the pipeline for AI text-to-3D figurine generation.

## Deliverables

- Integration with text-to-3D service (Meshy, Tripo3D, or similar)
- Generation job management (queue, status tracking, retry logic)
- Automated mesh repair pipeline (non-manifold geometry, thin walls, floating artifacts)
- 3D rendered preview generation for customer approval
- Content moderation to reject copyrighted character prompts
- Job status API for frontend polling
