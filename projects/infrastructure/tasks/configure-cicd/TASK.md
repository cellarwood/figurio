---
name: Configure CI/CD Pipelines
assignee: devops-engineer
project: infrastructure
---

Set up GitHub Actions CI/CD pipelines for automated building, testing, and deployment of Figurio services.

## Requirements

### CI Pipeline (on push/PR)
- Lint and type-check frontend (TypeScript)
- Lint and type-check backend (Python/mypy)
- Run frontend unit tests
- Run backend unit tests
- Build Docker images to verify they compile

### CD Pipeline (on merge to main)
- Build production Docker images
- Push to Docker Hub (lukekelle00)
- Deploy to microk8s-local cluster via kubectl/helm
- Run smoke tests against deployed services
- Notify Slack on success/failure

### Secrets Required
- `DOCKER_HUB_USERNAME` and `DOCKER_HUB_TOKEN` for image push
- `GH_TOKEN` for repository operations
- `KUBE_CONFIG` for cluster access
- `SLACK_WEBHOOK_URL` for notifications

## Acceptance Criteria

- PRs cannot merge without passing CI checks
- Merges to main automatically deploy to the cluster
- Failed deployments roll back automatically
- Build time under 10 minutes for full pipeline
- Slack notification on deploy success or failure
