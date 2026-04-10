---
name: Build custom figurine workflow API (prompt, preview, approval, deposit)
assignee: backend-engineer
project: mvp-backend
---

Build the API for the custom figurine ordering workflow.

## Requirements
- Prompt submission endpoint with content moderation (reject IP-infringing prompts)
- Job status tracking for AI generation pipeline
- Preview delivery endpoint (rendered 3D images)
- Customer approval/revision request flow
- Two-stage Stripe payment: 50% deposit at order, 50% on approval
- Timeout handling for abandoned custom orders
- Integration with the text-to-3D pipeline service
