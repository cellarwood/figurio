---
name: Set up infrastructure
slug: setup-infrastructure
assignee: cto
priority: critical
status: todo
---

# Set Up Infrastructure

Initialize the monorepo, Docker configurations, Kubernetes namespaces, and CI/CD pipelines for Figurio.

## Expected Subtasks

- CTO delegates to DevOps Engineer
- Create GitHub monorepo under Kelle00-AI org with standard layout (apps/web, services/api, services/ml-pipeline, infra/helm, .github/workflows)
- Write Dockerfiles for each service (multi-stage builds, Alpine/distroless)
- Set up Kubernetes namespaces: figurio-dev, figurio-staging, figurio-prod
- Configure Traefik ingress with SSL (Let's Encrypt)
- Write Helm charts for API, web, and ML pipeline services
- Set up PostgreSQL (dev: docker-compose, staging/prod: StatefulSet or managed)
- Configure Docker Hub image push (lukekelle00 account)
- Set up monitoring stack (Grafana, Prometheus, Loki, Sentry)
