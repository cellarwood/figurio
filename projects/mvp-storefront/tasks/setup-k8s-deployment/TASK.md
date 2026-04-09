---
name: Set Up Kubernetes Deployment
assignee: devops-engineer
project: mvp-storefront
---

Configure MicroK8s cluster with Helm charts for all Figurio services.

- Create Helm chart for frontend (React app served via nginx)
- Create Helm chart for backend (FastAPI + Uvicorn)
- Create Helm chart for PostgreSQL (or use existing PG operator)
- Create Helm chart for Redis (task queue backend)
- Configure Traefik ingress with TLS termination and routing rules
- Set up K8s secrets for Stripe keys, database URL, API tokens
- Configure resource limits and requests for all pods
- Set up persistent volumes for database and media storage
- Write deployment documentation with rollback procedures
