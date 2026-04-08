---
name: Configure CI/CD with GitHub Actions
assignee: devops-engineer
project: infrastructure
---

# Configure CI/CD with GitHub Actions

Create GitHub Actions workflows:

- **ci.yml** (on PR): checkout, install deps, lint, type-check, run tests (pytest for backend, npm test for frontend)
- **deploy.yml** (on merge to main): build Docker images, push to Docker Hub with SHA + latest tags, helm upgrade to figurio-dev namespace

Use GitHub Secrets for DOCKER_HUB_USERNAME, DOCKER_HUB_TOKEN.
