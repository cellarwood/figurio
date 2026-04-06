---
name: Set up GitHub Actions CI/CD pipeline
assignee: devops-engineer
project: infrastructure-setup
---

Create GitHub Actions workflows for automated testing, building, and deployment.

## Workflows

### ci.yml (runs on pull requests)
- Checkout code
- **Backend:** Install Python deps with uv, run pytest, run ruff lint, run mypy type check
- **Frontend:** Install npm deps, run vitest, run eslint, run TypeScript check
- Report results as PR checks

### deploy.yml (runs on merge to main)
- Build Docker images for frontend and backend
- Tag images: `latest`, `sha-{commit_sha}`, `v{version}` (from package.json/pyproject.toml)
- Push to Docker Hub (lukekelle00)
- Deploy to figurio-dev namespace via `helm upgrade --install`
- Run smoke test (health check endpoint)

## Secrets Required

- `DOCKER_HUB_USERNAME` and `DOCKER_HUB_TOKEN` for registry push
- `KUBECONFIG` for deployment (or use a deploy key/service account)

## Acceptance Criteria

- CI workflow running on all PRs, blocking merge on failure
- Deploy workflow building, pushing, and deploying on merge to main
- Images appearing in Docker Hub with correct tags
- Successful deployment to figurio-dev verified by smoke test
