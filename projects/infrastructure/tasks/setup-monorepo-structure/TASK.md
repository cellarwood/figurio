---
name: Set up monorepo structure with apps/web and services/api
assignee: devops-engineer
project: infrastructure
---

Create the monorepo directory structure for the Figurio codebase.

- Root structure:
  ```
  figurio/
    apps/
      web/                  # React/TypeScript frontend
        Dockerfile
        package.json
        src/
    services/
      api/                  # Python/FastAPI backend
        Dockerfile
        pyproject.toml
        src/
    packages/
      shared/               # Shared types, constants
    infra/
      helm/                 # Helm charts per service
      docker-compose.yml    # Local dev stack
    .github/
      workflows/
  ```
- Initialize apps/web with React + TypeScript + Vite + Tailwind CSS
- Initialize services/api with FastAPI + uv + pyproject.toml
- Create docker-compose.yml for local development (frontend, API, PostgreSQL, Traefik)
- Create .gitignore covering Node, Python, Docker, and IDE files
- Verify both services start locally with docker-compose up
