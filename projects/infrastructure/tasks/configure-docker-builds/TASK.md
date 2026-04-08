---
name: Configure Docker Builds
assignee: devops-engineer
project: infrastructure
---

Create Docker configurations for all Figurio services with multi-stage builds for minimal production images.

## Requirements

- Dockerfile for frontend (React/TS → nginx static serve)
  - Build stage: Node.js, npm install, build
  - Production stage: nginx:alpine with built static files
- Dockerfile for backend (Python/FastAPI)
  - Build stage: Python with uv, install dependencies
  - Production stage: slim Python image with uvicorn
- docker-compose.yml for local development
  - Frontend with hot reload
  - Backend with auto-reload
  - PostgreSQL database
  - Volume mounts for development
- .dockerignore files to exclude node_modules, .venv, etc.

## Image Targets

- Frontend: `lukekelle00/figurio-web:latest`
- Backend: `lukekelle00/figurio-api:latest`

## Acceptance Criteria

- `docker compose up` starts full local development stack
- Production images are under 200MB each
- Multi-stage builds don't leak build dependencies into production
- Images build successfully in CI environment
