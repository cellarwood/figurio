---
name: AI Pipeline
description: Build the Prompt-to-Print pipeline — AI text-to-3D generation, automated mesh repair, QA review, customer preview approval, and production handoff
slug: ai-pipeline
owner: cto
---

# AI Pipeline

The AI-powered custom figurine pipeline that takes a customer's text description and produces a printable 3D model. This is Figurio's key differentiator — turning imagination into physical objects.

## Scope

- Text-to-3D generation via third-party API (Meshy, Tripo3D, or Luma Genie)
- Automated mesh repair pipeline (fix non-manifold geometry, thin walls, floating artifacts)
- QA review dashboard for human technician sign-off
- Customer-facing 3D preview and approval interface
- Two-stage Stripe payment (50% deposit, 50% on approval)
- Production handoff — approved models queued for MCAE printing

## Pipeline Flow

1. Customer submits text prompt via storefront
2. Backend dispatches to text-to-3D API
3. Generated model goes through automated mesh repair
4. QA reviewer inspects and approves/rejects
5. Customer receives 3D preview for approval
6. On approval, second payment captured and model enters print queue

## Success Criteria

- End-to-end pipeline from prompt to printable model in under 48 hours
- Mesh repair catches 90%+ of common geometry issues automatically
- Customer preview provides accurate representation of final product
- Two-stage payment flow handles deposits and completions correctly
