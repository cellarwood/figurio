---
name: Platform Infrastructure
slug: platform-infrastructure
description: Docker containers, Kubernetes deployment on microk8s, CI/CD with GitHub Actions, monitoring with Sentry
owner: devops-engineer
---

## Scope

Set up production infrastructure for Figurio — containerization, orchestration, CI/CD, monitoring, and database management.

## Tech Stack

- Docker with multi-stage builds
- Kubernetes on microk8s
- Traefik as ingress/reverse proxy
- GitHub Actions for CI/CD
- Docker Hub (lukekelle00) for image registry
- Sentry for error tracking
- PostgreSQL on K8s

## Success Criteria

- Frontend and backend deploy automatically on push to main
- Traefik routes traffic with SSL termination
- PostgreSQL runs reliably with backup strategy
- Sentry captures and alerts on errors
- Rollback procedure is documented and tested
