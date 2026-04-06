---
name: Set up monorepo structure with Docker multi-stage builds
assignee: devops-engineer
project: infrastructure-setup
---

Create the monorepo layout and Docker build pipeline for all Figurio services.

## Monorepo Structure

```
figurio/
  apps/
    web/                  # React/TypeScript frontend
      Dockerfile
      package.json
      src/
  services/
    api/                  # FastAPI backend
      Dockerfile
      pyproject.toml
      src/
  infra/
    helm/                 # Helm charts
    docker-compose.yml    # Local dev stack
  .github/
    workflows/
```

## Docker Builds

### Frontend (apps/web/Dockerfile)
- Stage 1: Node.js build (npm ci, npm run build)
- Stage 2: Nginx Alpine serving static files
- Image: `lukekelle00/figurio-web:{tag}`

### Backend (services/api/Dockerfile)
- Stage 1: Python build with uv (uv sync)
- Stage 2: Python slim runtime with only production dependencies
- Image: `lukekelle00/figurio-api:{tag}`

### Local Dev (docker-compose.yml)
- Frontend dev server with hot reload
- Backend dev server with auto-reload
- PostgreSQL 16
- Redis (for async job queue)

## Acceptance Criteria

- Monorepo structure created with placeholder apps
- Both Dockerfiles building successfully
- docker-compose bringing up the full local stack
- README with local dev setup instructions
