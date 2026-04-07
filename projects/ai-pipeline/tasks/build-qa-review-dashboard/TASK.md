---
name: Build admin QA review dashboard for 3D model validation
assignee: frontend-engineer
project: ai-pipeline
---

Build an admin dashboard for QA technicians to review AI-generated 3D models before customer preview.

- Queue view: list of models pending QA review, sorted by creation time
- Review view: 3D model viewer with measurement tools (check dimensions, wall thickness)
- Display mesh repair report: what was auto-fixed, confidence score, flagged issues
- Approve button: marks model as QA-passed and triggers customer preview notification
- Reject button: marks model as failed with technician notes, triggers regeneration or customer notification
- Request manual repair button: routes to manual repair queue with notes
- Filter by status: pending, approved, rejected, manual-repair
- Batch review mode for high-volume periods
- Admin authentication required (role-based access)
