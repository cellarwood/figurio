---
name: Create customer preview and approval flow with 3D render viewer
assignee: frontend-engineer
project: ai-pipeline
---

Build the customer-facing preview and approval flow for AI-generated custom figurines.

- Preview page showing the generated 3D model in the Three.js/React Three Fiber viewer
- Rotate, zoom, and inspect the model from all angles
- Display model details: size options, estimated delivery time, price breakdown
- "Approve" button: triggers remaining 50% payment capture and queues for printing
- "Request Revision" button: allows customer to provide feedback for regeneration (with revision limits)
- "Reject" button: cancels order and refunds 50% deposit
- Order status page showing pipeline progress (generating → repairing → reviewing → preview ready → approved → printing)
- Email/notification when preview is ready for customer review
- Mobile-optimized preview with touch controls
