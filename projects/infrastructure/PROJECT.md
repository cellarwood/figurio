---
name: Infrastructure
description: Docker, Kubernetes (microk8s-local), CI/CD, Traefik ingress, monitoring, and domain setup
slug: infrastructure
owner: devops-engineer
---

## Scope

Set up production infrastructure for Figurio on microk8s-local.

### Key Systems
- Docker multi-stage builds for backend and frontend
- Kubernetes manifests and Helm charts
- Traefik ingress with TLS termination
- GitHub Actions CI/CD pipeline
- Sentry error tracking and structured logging
- Docker Hub (lukekelle00) for image registry

### Infrastructure Details
- K8s cluster: microk8s-local
- Docker Hub: lukekelle00
- GitHub: cellarwood/figurio
- Domain: cellarwood.org

## Success Criteria
- Zero-downtime deployments via Helm
- Automated build/test/deploy on push to main
- Monitoring and alerting operational
- Rollback procedure documented and tested
