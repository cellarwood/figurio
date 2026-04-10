---
name: Set up CI/CD pipeline with GitHub Actions
assignee: devops-engineer
project: infrastructure
---

Build CI/CD pipeline:

- GitHub Actions workflow for cellarwood/figurio repo
- On PR: lint, type check, run tests (Python + TypeScript)
- On merge to main: build Docker images, push to lukekelle00 Docker Hub
- Deploy: Helm upgrade to microk8s-local cluster
- Database migration step (Alembic) before backend deploy
- Rollback on health check failure
- Separate workflows for backend and frontend (parallel builds)
