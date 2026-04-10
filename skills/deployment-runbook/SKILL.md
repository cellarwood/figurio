---
name: deployment-runbook
description: >
  Step-by-step deployment procedures for Figurio services on microk8s — backend
  FastAPI API, React frontend, PostgreSQL database migrations, Helm chart upgrades,
  Traefik ingress updates, TLS certificate management, and rollback procedures.
  Use this whenever deploying, upgrading, or rolling back any Figurio service.
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - devops
      - deployment
---

# Deployment Runbook

## When to Use

Use this skill for any production or staging deployment of Figurio services:
backend API updates, frontend releases, database migrations, Helm chart changes,
ingress/TLS config changes, and rollback operations.

## Cluster Context

- **Runtime:** microk8s (local K8s cluster)
- **Namespaces:** `figurio-prod`, `figurio-staging`
- **Ingress:** Traefik (via microk8s add-on or Helm release)
- **Registry:** Docker Hub — `lukekelle00/<service>:<tag>`
- **CI/CD:** GitHub Actions — builds, pushes image, triggers Helm upgrade
- **Observability:** Sentry (errors), Prometheus (metrics)
- **Secrets management:** K8s Secrets (created manually or via Terraform)

## Pre-Deployment Checklist

Before any deployment:

1. Confirm GitHub Actions CI pipeline passed on the target commit (all tests green).
2. Check current cluster state: `microk8s kubectl get pods -n figurio-prod`
3. Note the currently running image tag for the service being deployed (for rollback).
4. For DB migrations: ensure a database backup exists or `pg_dump` is run manually.
5. Confirm Sentry is reachable and error rate baseline is known.

## Backend API Deployment (FastAPI)

The backend runs as a Deployment in `figurio-prod`. Image: `lukekelle00/figurio-backend:<tag>`.

### Standard Deploy

```bash
# 1. Pull the new image tag from CI output or git SHA
IMAGE_TAG=<git-sha-or-semver>

# 2. Update image via Helm upgrade
microk8s helm upgrade figurio-backend ./helm/backend \
  --namespace figurio-prod \
  --set image.tag=$IMAGE_TAG \
  --set image.repository=lukekelle00/figurio-backend \
  --atomic \
  --timeout 5m

# 3. Verify rollout
microk8s kubectl rollout status deployment/figurio-backend -n figurio-prod

# 4. Tail logs briefly to confirm healthy startup
microk8s kubectl logs -l app=figurio-backend -n figurio-prod --tail=50 -f
```

### Verify Health

```bash
# Hit the health endpoint through ingress
curl -sf https://api.figurio.com/health | jq .

# Expected: {"status": "ok", "version": "<tag>"}
```

## Frontend Deployment (React)

The frontend is a static build served via Nginx in a Docker container.
Image: `lukekelle00/figurio-frontend:<tag>`.

```bash
IMAGE_TAG=<git-sha-or-semver>

microk8s helm upgrade figurio-frontend ./helm/frontend \
  --namespace figurio-prod \
  --set image.tag=$IMAGE_TAG \
  --set image.repository=lukekelle00/figurio-frontend \
  --atomic \
  --timeout 3m

microk8s kubectl rollout status deployment/figurio-frontend -n figurio-prod
```

Verify by loading `https://figurio.com` and checking the page title / version footer.

## Database Migrations

Migrations run as a Kubernetes Job before the backend Deployment is updated.
Migration tool: Alembic (invoked inside the backend container).

```bash
# 1. Apply the migration job manifest
microk8s kubectl apply -f k8s/jobs/migrate.yaml -n figurio-prod

# 2. Wait for job completion (timeout 10m)
microk8s kubectl wait --for=condition=complete job/figurio-migrate \
  -n figurio-prod --timeout=600s

# 3. Check migration logs
microk8s kubectl logs job/figurio-migrate -n figurio-prod

# 4. If job failed, do NOT proceed with backend deploy — investigate first
microk8s kubectl describe job/figurio-migrate -n figurio-prod

# 5. Clean up completed job after verification
microk8s kubectl delete job figurio-migrate -n figurio-prod
```

Migration failures are P1 incidents — see `incident-response` skill.

## Traefik Ingress Updates

Figurio uses Traefik as the ingress controller. Ingress rules live in
`helm/ingress/` or as standalone `IngressRoute` manifests.

```bash
# Apply updated ingress config
microk8s kubectl apply -f k8s/ingress/figurio-ingressroute.yaml -n figurio-prod

# Verify routes are accepted
microk8s kubectl get ingressroute -n figurio-prod

# Check Traefik dashboard (port-forward if needed)
microk8s kubectl port-forward svc/traefik 9000:9000 -n kube-system
# Open http://localhost:9000/dashboard/
```

When adding a new route:
- Confirm the backend/frontend service name and port match.
- Test the route with `curl -H "Host: <domain>" http://localhost` if DNS not yet live.

## TLS Certificate Management

TLS is managed via cert-manager with Let's Encrypt (ACME). Certificates are
stored as K8s Secrets.

```bash
# List current certificates and expiry
microk8s kubectl get certificate -n figurio-prod

# Check a specific cert status
microk8s kubectl describe certificate figurio-tls -n figurio-prod

# Force renewal if expiring within 7 days
microk8s kubectl annotate certificate figurio-tls \
  cert-manager.io/force-renewal=true -n figurio-prod --overwrite

# Watch renewal progress
microk8s kubectl get certificaterequest -n figurio-prod -w
```

Certificates auto-renew at 60 days. Alert fires at 14 days remaining via
Prometheus rule. If renewal fails, escalate — ACME challenge failures often
indicate DNS or ingress misconfiguration.

## Rollback Procedures

### Helm Rollback (preferred)

```bash
# View release history
microk8s helm history figurio-backend -n figurio-prod

# Roll back to previous revision
microk8s helm rollback figurio-backend -n figurio-prod

# Or to a specific revision
microk8s helm rollback figurio-backend <revision> -n figurio-prod

# Confirm rollout
microk8s kubectl rollout status deployment/figurio-backend -n figurio-prod
```

### Image Tag Rollback (manual override)

```bash
microk8s kubectl set image deployment/figurio-backend \
  backend=lukekelle00/figurio-backend:<previous-tag> \
  -n figurio-prod

microk8s kubectl rollout status deployment/figurio-backend -n figurio-prod
```

### Database Migration Rollback

Alembic downgrade — run inside a backend pod or migration job:

```bash
microk8s kubectl exec -it deploy/figurio-backend -n figurio-prod -- \
  alembic downgrade -1
```

Only downgrade if the migration is reversible and data integrity is confirmed.
When in doubt, restore from backup.

## Post-Deployment Verification

After any deployment:

1. `microk8s kubectl get pods -n figurio-prod` — all pods Running, no CrashLoopBackOff.
2. Check Sentry — no new error spike in the 5 minutes post-deploy.
3. Check Prometheus — `http_request_duration_seconds` and `http_requests_total` normal.
4. Smoke test critical paths:
   - `GET /health` — 200 OK
   - `GET /api/v1/products` — returns product list
   - Stripe checkout flow (staging only, or use test mode).
5. Record the deployed image tag in the deployment log (team doc or Git tag).

## Anti-Patterns

- Never deploy backend without running migrations first (if migration exists).
- Never delete a running pod to "force restart" — use `rollout restart` instead.
- Never edit K8s resources with `kubectl edit` in production — all changes go
  through Helm or manifests in Git.
- Never push directly to the Docker Hub image used by prod without a CI build.
