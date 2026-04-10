---
name: Dockerize backend and frontend with multi-stage builds
assignee: devops-engineer
project: infrastructure
---

Create production-ready Docker images.

## Requirements
- Backend: Python multi-stage build with Alpine/distroless base
- Frontend: Node build stage + nginx serve stage
- Docker Compose for local development
- Image optimization for minimal size
- Push to Docker Hub (lukekelle00)
- Health check configuration in Dockerfiles
