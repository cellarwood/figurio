---
name: Set up Kubernetes deployment on microk8s with Helm and Traefik
assignee: devops-engineer
project: infrastructure
---

Deploy Figurio on microk8s:

- Helm charts for: backend API, frontend, Celery worker, Redis, PostgreSQL
- Traefik ingress controller with TLS (Let's Encrypt)
- Namespace: figurio
- Resource limits and requests per service
- ConfigMaps for non-secret configuration
- Secrets for Stripe keys, database URL, API keys
- Persistent volumes for PostgreSQL and Redis
- Service mesh basics: internal DNS, service discovery
