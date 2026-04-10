---
name: Create Docker multi-stage builds for frontend and backend
assignee: devops-engineer
project: infrastructure
---

Create optimized Docker images:

- Backend: Python multi-stage build (builder → runtime), Alpine-based, uv for deps
- Frontend: Node multi-stage build (builder → nginx runtime), distroless or Alpine
- Celery worker: shared backend image with different entrypoint
- Redis: official image with persistence config
- docker-compose.yml for local development
- .dockerignore files to minimize image size
- Health check commands in Dockerfiles
