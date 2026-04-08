---
name: Build AI Prompt Submission UI
assignee: frontend-engineer
project: ai-pipeline
---

Build the customer-facing interface for the "Prompt to Print" custom figurine service. Customers describe their desired figurine in natural language, pay a deposit, and receive a 3D preview for approval.

## Requirements

- Text prompt input with character limit and example prompts for inspiration
- Style/mood selector (realistic, cartoon, fantasy, steampunk, etc.)
- Size tier pre-selection with pricing display (including deposit amount)
- Prompt submission with 50% deposit payment via Stripe
- Order status page showing generation progress
- 3D model viewer for previewing the generated figurine
- Approve/request-revision/reject controls
- Second payment capture (remaining 50%) on approval

## User Flow

1. Customer writes prompt describing their figurine
2. Selects style preferences and size tier
3. Pays 50% deposit via Stripe
4. Receives notification when preview is ready (email + in-app)
5. Reviews 3D preview in interactive viewer
6. Approves → remaining 50% charged → enters print queue
7. Or requests revision → model regenerated (limited revisions)

## Acceptance Criteria

- Prompt submission creates order with deposit payment
- Generation status updates in real-time (polling or SSE)
- 3D viewer renders the generated model with rotation/zoom
- Approval triggers second Stripe charge
- Clear communication of timeline expectations (10-15 business days)
