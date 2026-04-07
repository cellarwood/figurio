---
name: Set up GitHub Actions CI/CD pipeline
assignee: devops-engineer
project: infrastructure
---

Create GitHub Actions workflows for continuous integration and deployment.

- CI workflow (.github/workflows/ci.yml) — runs on pull requests:
  - Checkout code
  - Frontend: npm install, lint (eslint), type-check (tsc), test (vitest)
  - Backend: uv sync, lint (ruff), type-check (mypy), test (pytest)
  - Fail fast on any step failure
  - Target: under 5 minutes total
- CD workflow (.github/workflows/deploy.yml) — runs on merge to main:
  - Build Docker images for frontend and backend
  - Tag with: latest, sha-{GITHUB_SHA::7}
  - Push to Docker Hub (lukekelle00)
  - (Optional) Deploy to figurio-dev namespace via kubectl/helm
- Secrets required in GitHub: DOCKER_HUB_USERNAME, DOCKER_HUB_TOKEN
- Cache npm and uv dependencies between runs for speed
- Add status badges to README
