---
name: Infrastructure Setup
description: Set up the monorepo, Docker builds, Kubernetes deployment, CI/CD pipeline, and monitoring for Figurio
slug: infrastructure-setup
owner: cto
---

## Scope

Establish the complete development and deployment infrastructure:

- GitHub monorepo with apps/web, services/api, infra/helm structure
- Docker multi-stage builds for API and web services
- Kubernetes deployment on microk8s-local with Helm charts
- Traefik ingress routing figurio.cellarwood.org to the web frontend
- GitHub Actions CI/CD: test on PR, build+deploy on merge
- Monitoring with Prometheus, Grafana, and Sentry

## Success Criteria

- Monorepo structure in place with working docker-compose for local dev
- API and web services deployable to microk8s-local via Helm
- figurio.cellarwood.org resolves and serves the storefront
- CI pipeline runs tests on every PR
- Deploy pipeline builds, pushes, and deploys on merge to main
- Grafana dashboard showing API response times and error rates

## Workspace

This project targets the Figurio monorepo at `github.com/cellarwood/figurio`.
