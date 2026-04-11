---
name: Platform Infrastructure
description: Docker builds, Kubernetes deployment, CI/CD pipelines, domain routing, and monitoring
slug: platform-infra
owner: devops-engineer
---

## Scope

Containerize Figurio services and deploy to Kubernetes. Set up CI/CD pipelines, domain routing, TLS, and monitoring.

## Tech Stack

- Docker with multi-stage builds
- Kubernetes (microk8s-local)
- Helm for resource templating
- Traefik as ingress/reverse proxy
- GitHub Actions for CI/CD
- Docker Hub (lukekelle00) for image registry
- Sentry for error tracking

## Success Criteria

- Frontend and backend running in K8s pods
- Traefik routing traffic to services with TLS
- CI/CD pipeline: push → build → test → deploy
- Sentry capturing errors from both services
- Health checks and basic alerting
