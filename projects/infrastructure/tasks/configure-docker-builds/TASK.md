---
name: Configure Docker multi-stage builds for frontend and backend
assignee: devops-engineer
project: infrastructure
---

# Configure Docker multi-stage builds for frontend and backend

Create Dockerfiles with multi-stage builds. Frontend: node build stage -> nginx serve stage. Backend: uv install stage -> slim Python runtime stage. Target images: lukekelle00/figurio-web, lukekelle00/figurio-api. Optimize for minimal image size (Alpine/distroless). Include health check endpoints.
