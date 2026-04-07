---
name: Infrastructure Setup
description: Set up monorepo, Docker builds, Kubernetes deployment, and CI/CD pipeline for Figurio's development and production environments
slug: infrastructure
owner: devops-engineer
---

## Scope

Build the complete development and deployment infrastructure:

- Monorepo structure with apps/web (frontend) and services/api (backend)
- Docker multi-stage builds for all services
- Kubernetes namespaces and Helm charts for microk8s-local
- GitHub Actions CI/CD pipeline (test on PR, build+deploy on merge)
- Traefik ingress for routing and TLS

## Success Criteria

- Monorepo structure established with working local dev environment (docker-compose)
- Docker images build successfully and push to Docker Hub (lukekelle00)
- Kubernetes namespaces (figurio-dev, figurio-staging, figurio-prod) configured
- Helm charts deploy all services to microk8s-local
- GitHub Actions CI runs tests on PR, CD builds and deploys on merge to main
- Traefik routes traffic to frontend and API services
- PostgreSQL running as StatefulSet in dev namespace

## Workspace

This project targets the main application repository at github.com/cellarwood/figurio.
