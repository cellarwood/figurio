---
name: Configure CI/CD pipeline with GitHub Actions
assignee: devops-engineer
project: infrastructure
---

Set up continuous integration and deployment.

## Deliverables

- GitHub Actions workflow for backend (lint, test, build, push to Docker Hub)
- GitHub Actions workflow for frontend (lint, test, build, push to Docker Hub)
- Deployment workflow (update K8s manifests, rolling update)
- Branch protection rules for main
- Docker Hub image tagging strategy (commit SHA + latest)
