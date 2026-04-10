---
name: Infrastructure
description: Docker, Kubernetes, CI/CD, monitoring, and production deployment for Figurio platform
slug: infrastructure
owner: devops-engineer
---

## Scope

Set up production infrastructure for Figurio on microk8s with full CI/CD pipeline.

### Core Components

- Docker multi-stage builds for frontend (Node) and backend (Python) services
- Kubernetes deployment on microk8s with Helm charts
- Traefik ingress with TLS termination
- PostgreSQL with automated backups and Alembic migration tooling
- GitHub Actions CI/CD: build, test, Docker push to lukekelle00 Docker Hub, deploy
- Sentry error tracking and application metrics
- Redis for Celery job queue

### Infrastructure

- K8s cluster: microk8s-local
- Docker Hub: lukekelle00
- GitHub: cellarwood/figurio

## Success Criteria

- Zero-downtime deployments via Helm rollouts
- Automated CI/CD from push to deploy
- Database backups running on schedule
- Sentry capturing errors from both frontend and backend
- TLS working end-to-end
