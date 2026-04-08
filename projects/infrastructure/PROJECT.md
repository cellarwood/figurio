---
name: Infrastructure
description: Set up the deployment infrastructure — monorepo structure, Docker builds, Kubernetes manifests, CI/CD pipelines, and Traefik ingress
slug: infrastructure
owner: devops-engineer
---

# Infrastructure

All deployment and operations infrastructure for Figurio. Covers the monorepo setup, containerization, orchestration, networking, and automated pipelines.

## Scope

- Monorepo structure with frontend, backend, and shared packages
- Docker multi-stage builds for minimal production images
- Kubernetes manifests and Helm charts for microk8s deployment
- Traefik ingress configuration with SSL/TLS
- GitHub Actions CI/CD pipelines for automated build, test, and deploy
- Docker Hub image publishing (lukekelle00)
- Secret management and environment configuration
- Monitoring and health checks

## Infrastructure Details

- **Cluster:** microk8s-local
- **Registry:** Docker Hub (lukekelle00)
- **Domain:** cellarwood.org
- **Ingress:** Traefik
- **CI/CD:** GitHub Actions
- **Repository:** github.com/cellarwood/figurio

## Success Criteria

- Automated pipeline from git push to deployed containers
- Zero-downtime deployments via rolling updates
- Traefik routes traffic to correct services with valid SSL
- All secrets managed securely (not in git)
