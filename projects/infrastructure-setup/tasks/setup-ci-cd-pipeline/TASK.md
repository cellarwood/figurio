---
name: Set up CI/CD pipeline
assignee: devops-engineer
project: infrastructure-setup
---

Create GitHub Actions workflows for continuous integration and deployment.

## CI Workflow (`ci.yml`) — runs on PRs

- Checkout code
- Set up Python (uv) and Node.js (npm)
- Install dependencies for both services
- Run backend tests: `pytest` with coverage report
- Run frontend tests: `vitest`
- Run linting: `ruff` (Python), `eslint` (TypeScript)
- Run type checking: `mypy` (Python), `tsc --noEmit` (TypeScript)
- Fail on any test failure or lint error

## Deploy Workflow (`deploy.yml`) — runs on merge to main

- Build Docker images for API and web
- Tag with commit SHA and `latest`
- Push to Docker Hub
- Deploy to figurio-dev namespace: `helm upgrade --install`
- Run smoke test against deployed services (health check endpoints)

## Requirements

- Docker Hub credentials stored as GitHub secrets
- Kubernetes config for deployment (kubeconfig or service account)
- Separate workflow files for CI and deploy
- Build cache for Docker layers to speed up builds
