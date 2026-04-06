---
name: Set up monorepo structure
assignee: devops-engineer
project: infrastructure-setup
---

Create the GitHub monorepo structure for the Figurio project.

## Structure

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
    helm/
      figurio-api/        # Helm chart for API
      figurio-web/        # Helm chart for web
    docker-compose.yml    # Local dev stack (API + web + PostgreSQL)
  .github/
    workflows/
      ci.yml
      deploy.yml
  README.md
```

## Requirements

- Initialize React/TypeScript app in `apps/web/` with Vite, shadcn-ui, Tailwind
- Initialize FastAPI app in `services/api/` with `uv`, pyproject.toml
- Docker-compose for local dev: API on port 8000, web on port 3000, PostgreSQL on 5432
- Multi-stage Dockerfiles for both services (build + runtime stages, Alpine base)
- `.gitignore` covering Python, Node.js, and Docker artifacts
