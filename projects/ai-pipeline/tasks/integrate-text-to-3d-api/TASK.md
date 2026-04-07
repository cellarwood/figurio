---
name: Integrate text-to-3D API with prompt intake endpoint
assignee: backend-engineer
project: ai-pipeline
---

Integrate a third-party text-to-3D generation service into the backend.

- Evaluate and select primary API: Meshy, Tripo3D, Luma Genie, or CSM 3D (based on quality, speed, cost benchmarks)
- Build prompt intake endpoint: POST /custom-orders (accepts text prompt, validates input, creates order with 50% deposit)
- Submit prompt to the selected text-to-3D API asynchronously
- Poll or webhook for generation completion
- Store generated 3D model file (GLB/OBJ) in object storage
- Handle generation failures (timeout, API error, content moderation rejection)
- Content moderation: reject prompts requesting recognizable copyrighted characters
- Track generation metrics: success rate, average time, cost per generation
- Return model URL to the frontend for preview rendering
