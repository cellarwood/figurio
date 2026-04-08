---
name: Build QA Review Dashboard
assignee: frontend-engineer
project: ai-pipeline
---

Build the internal QA review dashboard where a 3D technician inspects AI-generated models after mesh repair, before sending previews to customers.

## Requirements

- Queue of models awaiting QA review, sorted by order date
- 3D model viewer with measurement tools (dimensions, wall thickness visualization)
- Side-by-side view: original AI output vs. post-repair model
- Mesh repair report display (issues found, repairs applied, confidence score)
- Approve / reject / send-back-to-repair controls
- Rejection requires notes explaining the issue
- Printability checklist: manifold geometry, minimum thickness, no floating parts, normals correct
- Customer order context: prompt text, selected size tier, payment status

## Tech Stack

- React/TypeScript with three.js for 3D model viewing
- Admin-only route with authentication
- Backend API for QA queue management

## Acceptance Criteria

- QA reviewer can efficiently inspect models in the 3D viewer
- Repair report is clearly displayed alongside the model
- Approval moves model to customer preview stage
- Rejection sends model back to repair queue with notes
- Dashboard shows queue depth and average review time
