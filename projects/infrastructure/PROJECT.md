---
name: Infrastructure
description: DevOps and deployment — Docker builds, Kubernetes orchestration, CI/CD pipelines, monitoring and alerting
slug: infrastructure
owner: devops-engineer
---

## Scope

Set up the production infrastructure for Figurio. Includes Docker multi-stage builds for all services, Kubernetes deployment on microk8s (dev) and GKE (production), Traefik ingress with TLS, GitHub Actions CI/CD pipeline, and monitoring with Sentry.

## Tech Stack

- Docker with multi-stage builds
- Kubernetes (microk8s local, GKE production)
- Helm for resource templating
- Terraform for cloud resources
- Traefik as ingress/reverse proxy
- GitHub Actions for CI/CD

## Success Criteria

- Zero-downtime deployments with rolling updates
- Automated test → build → deploy pipeline
- Health checks and alerting for all services
- Rollback procedure tested and documented
