---
name: deployment-runbook
description: Step-by-step deployment procedures for Figurio services on microk8s — build, push, deploy, verify, and rollback
---

# Deployment Runbook

## Pre-Deployment Checklist

- [ ] All CI checks pass on main branch
- [ ] No active incidents or ongoing deploys
- [ ] Database migrations tested on staging (if any)
- [ ] Rollback plan documented for this specific deploy

## Standard Deployment (via CI/CD)

Automated on merge to main. Pipeline steps:

1. **Build** — Docker multi-stage build for frontend and backend
2. **Test** — run unit tests in CI
3. **Push** — push images to Docker Hub (`lukekelle00/figurio-web`, `lukekelle00/figurio-api`)
4. **Deploy** — `kubectl apply` or `helm upgrade` on microk8s-local
5. **Verify** — health check endpoints respond, smoke tests pass
6. **Notify** — Slack notification with deploy status

## Manual Deployment

When CI/CD is unavailable or for hotfixes:

```bash
# 1. Build images
docker build -t lukekelle00/figurio-web:v{VERSION} -f infra/docker/Dockerfile.web .
docker build -t lukekelle00/figurio-api:v{VERSION} -f infra/docker/Dockerfile.api .

# 2. Push to registry
docker push lukekelle00/figurio-web:v{VERSION}
docker push lukekelle00/figurio-api:v{VERSION}

# 3. Deploy to cluster
kubectl --context microk8s-local set image deployment/figurio-web web=lukekelle00/figurio-web:v{VERSION}
kubectl --context microk8s-local set image deployment/figurio-api api=lukekelle00/figurio-api:v{VERSION}

# 4. Verify
kubectl --context microk8s-local rollout status deployment/figurio-web
kubectl --context microk8s-local rollout status deployment/figurio-api
```

## Rollback

```bash
# Rollback to previous revision
kubectl --context microk8s-local rollout undo deployment/figurio-web
kubectl --context microk8s-local rollout undo deployment/figurio-api

# Or rollback to specific revision
kubectl --context microk8s-local rollout undo deployment/figurio-api --to-revision={N}
```

## Post-Deployment Verification

- [ ] Health endpoints return 200: `/health`, `/api/v1/health`
- [ ] Product catalog loads on storefront
- [ ] Stripe checkout test payment succeeds
- [ ] Order tracking page loads
- [ ] No new errors in application logs (`kubectl logs`)

## Database Migrations

```bash
# Run migrations before deploying new code that depends on schema changes
kubectl --context microk8s-local exec deployment/figurio-api -- alembic upgrade head

# Rollback migration if needed
kubectl --context microk8s-local exec deployment/figurio-api -- alembic downgrade -1
```
