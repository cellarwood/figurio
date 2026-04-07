---
name: Configure Kubernetes namespaces and Helm charts for microk8s-local
assignee: devops-engineer
project: infrastructure
---

Set up Kubernetes deployment on microk8s-local.

- Create namespaces: figurio-dev, figurio-staging, figurio-prod
- Helm charts for each service:
  - figurio-web: Deployment, Service, Ingress (Traefik)
  - figurio-api: Deployment, Service, Ingress (Traefik)
  - figurio-db: PostgreSQL StatefulSet with PVC
- Helm values files per environment (dev, staging, prod)
- Traefik IngressRoute for routing:
  - figurio.cellarwood.org → figurio-web
  - api.figurio.cellarwood.org → figurio-api
- Kubernetes Secrets for: DATABASE_URL, STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET, AI_API_KEY
- Resource limits and requests per pod
- Health check endpoints (liveness, readiness) for both services
- Deploy to figurio-dev namespace and verify services are reachable
