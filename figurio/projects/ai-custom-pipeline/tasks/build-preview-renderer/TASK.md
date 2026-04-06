---
name: Build preview renderer
slug: build-preview-renderer
assignee: cto
priority: high
status: todo
---

# Build Preview Renderer

Implement the 3D preview rendering service that generates customer-facing previews of their custom figurine before printing.

## Expected Subtasks

- CTO delegates to ML Engineer (rendering backend) and Frontend Engineer (preview UI)
- Server-side rendering: Blender headless rendering or three.js SSR to produce turntable images/video of the model
- Multiple angles: front, side, back, 3/4 view
- Size reference visualization (show figurine next to common objects for scale)
- Frontend: preview approval page where customer can rotate the model, zoom, and approve/request changes
- Integration with the two-stage payment flow (approval triggers second payment capture)
