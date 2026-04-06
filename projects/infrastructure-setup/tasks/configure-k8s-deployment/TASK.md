---
name: Configure Kubernetes namespaces, Helm charts, and Traefik ingress
assignee: devops-engineer
project: infrastructure-setup
---

Set up the Kubernetes deployment for Figurio on microk8s.

## Namespaces

- `figurio-dev` — development and testing
- `figurio-staging` — pre-production validation
- `figurio-prod` — production

## Helm Charts

### figurio-web
- Deployment: Nginx serving React build
- Service: ClusterIP
- Ingress: Traefik IngressRoute for `figurio.cellarwood.org`

### figurio-api
- Deployment: FastAPI with Uvicorn
- Service: ClusterIP
- Ingress: Traefik IngressRoute for `api.figurio.cellarwood.org`
- Environment variables from Kubernetes secrets (Stripe keys, DB URL, AI API key)

### figurio-db
- StatefulSet: PostgreSQL 16
- PersistentVolumeClaim for data
- Service: ClusterIP (internal only)

### figurio-redis
- Deployment: Redis for job queue
- Service: ClusterIP (internal only)

## Traefik Configuration

- TLS termination with Let's Encrypt (cert-manager)
- Rate limiting middleware
- CORS headers for API

## Acceptance Criteria

- All Helm charts templating correctly (`helm template` passes)
- Services deploying to figurio-dev namespace on microk8s
- Traefik routing traffic to frontend and API
- Secrets management for sensitive environment variables
- Health check endpoints working for all services
