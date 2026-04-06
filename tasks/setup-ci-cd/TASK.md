---
name: Set up CI/CD pipelines
slug: setup-ci-cd
assignee: cto
priority: high
status: todo
---

# Set Up CI/CD Pipelines

Implement GitHub Actions workflows for automated testing, building, and deployment.

## Expected Subtasks

- CTO delegates to DevOps Engineer
- ci.yml: runs on PRs -- checkout, install deps, lint, type-check, run tests (pytest + npm test)
- deploy.yml: runs on merge to main -- build Docker images, push to Docker Hub with SHA + latest tags, deploy to figurio-dev namespace
- Staging promotion workflow (manual trigger to deploy specific tag to figurio-staging)
- Production deployment workflow (manual trigger with approval gate)
- Secrets management: GH_TOKEN, DOCKER_HUB_TOKEN, KUBECONFIG in GitHub Secrets
