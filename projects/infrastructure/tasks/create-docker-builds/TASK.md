---
name: Create Docker multi-stage builds for frontend and backend
assignee: devops-engineer
project: infrastructure
---

Write optimized Dockerfiles for both services.

- Frontend (apps/web/Dockerfile):
  - Stage 1: Node.js builder — install deps, build production bundle
  - Stage 2: Nginx Alpine — serve static files
  - Target image size: under 50MB
- Backend (services/api/Dockerfile):
  - Stage 1: Python builder — install uv, sync dependencies
  - Stage 2: Python slim — copy venv, run uvicorn
  - Target image size: under 200MB
- Image naming convention: lukekelle00/figurio-web:{tag}, lukekelle00/figurio-api:{tag}
- Tags: latest, v{semver}, sha-{commit-sha}
- Test both images build and run locally
- Add .dockerignore files to exclude node_modules, .venv, __pycache__, .git
