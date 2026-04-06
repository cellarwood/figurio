---
name: Configure Kubernetes deployment
assignee: devops-engineer
project: infrastructure-setup
---

Create Helm charts and Kubernetes configuration for deploying Figurio to microk8s-local.

## Requirements

### Namespaces
- `figurio-dev` — development and testing
- `figurio-staging` — pre-production validation
- `figurio-prod` — production

### Helm Charts
- `figurio-api`: Deployment, Service, ConfigMap, Secret references for the FastAPI backend
- `figurio-web`: Deployment, Service for the React frontend (nginx serving static build)
- PostgreSQL: StatefulSet or use existing microk8s addon

### Traefik Ingress
- Route `figurio.cellarwood.org` to the web frontend service
- Route `figurio.cellarwood.org/api/*` to the API service
- TLS via Let's Encrypt (cert-manager) or Traefik's built-in ACME

### Configuration
- Environment-specific values files: `values-dev.yaml`, `values-staging.yaml`, `values-prod.yaml`
- Secrets managed via Kubernetes secrets (Stripe keys, database URL)
- Health check endpoints: `/health` for API, nginx default for web

## Technical Notes

- kubectl context: `microk8s-local`
- Use `helm upgrade --install` for idempotent deployments
- Test with `helm template` and `helm upgrade --dry-run` before applying
