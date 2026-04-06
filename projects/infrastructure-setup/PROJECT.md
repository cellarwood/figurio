---
name: Infrastructure Setup
description: Production-ready infrastructure with Docker, Kubernetes, CI/CD, and monitoring for the Figurio platform
slug: infrastructure-setup
owner: cto
---

## Scope

Set up the complete deployment and operations infrastructure:

1. **Monorepo structure** with Docker multi-stage builds for frontend and backend services
2. **Kubernetes deployment** on microk8s with Helm charts, namespaces (dev/staging/prod), and Traefik ingress
3. **CI/CD pipeline** via GitHub Actions — test on PR, build+push+deploy on merge
4. **Monitoring** — Prometheus metrics, Grafana dashboards, Sentry error tracking

## Success Criteria

- All services running on Kubernetes with Helm charts
- CI/CD pipeline deploying automatically on merge to main
- Monitoring dashboards showing API latency, error rates, and order pipeline health
- Local dev environment working via docker-compose
- Docker images pushed to Docker Hub (lukekelle00)

## Workspace

This project targets the main application repository at `github.com/cellarwood/figurio`.
