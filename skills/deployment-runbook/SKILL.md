---
name: Deployment Runbook
description: Step-by-step deployment procedures and rollback steps for Figurio's Kubernetes infrastructure
---

# Deployment Runbook

## Standard Deployment (via CI/CD)

Triggered automatically on merge to main:

1. GitHub Actions builds Docker images
2. Tags: `lukekelle00/figurio-web:sha-{commit}`, `lukekelle00/figurio-api:sha-{commit}`
3. Pushes to Docker Hub
4. (If configured) Updates Helm values and applies to figurio-dev namespace

**Verify after deploy:**
```bash
kubectl -n figurio-dev get pods          # All Running, no restarts
kubectl -n figurio-dev logs deploy/api   # No errors on startup
curl -s https://api.figurio.cellarwood.org/api/v1/health  # 200 OK
```

## Manual Deployment

When CI/CD is not available or for staging/prod:

```bash
# 1. Build and push
docker build -t lukekelle00/figurio-api:v{version} services/api/
docker push lukekelle00/figurio-api:v{version}

# 2. Update Helm values
# Edit infra/helm/figurio-api/values-{env}.yaml → image.tag: v{version}

# 3. Deploy
helm upgrade figurio-api infra/helm/figurio-api/ \
  -n figurio-{env} \
  -f infra/helm/figurio-api/values-{env}.yaml

# 4. Verify
kubectl -n figurio-{env} rollout status deploy/figurio-api
```

## Rollback

```bash
# Option 1: Helm rollback (preferred)
helm rollback figurio-api -n figurio-{env}

# Option 2: kubectl rollback
kubectl -n figurio-{env} rollout undo deploy/figurio-api

# Option 3: Pin to specific image
kubectl -n figurio-{env} set image deploy/figurio-api \
  api=lukekelle00/figurio-api:v{previous-version}
```

**Always verify after rollback:**
- Pods are healthy
- API health endpoint responds
- Storefront loads correctly

## Database Migrations

**Before deploying code that requires a migration:**
1. Run migration against dev database first
2. Verify migration is reversible: `alembic downgrade -1` then `alembic upgrade head`
3. Deploy migration to staging, verify
4. Deploy to production during low-traffic window

**Never run migrations and code deploy simultaneously.** Migration first, then code deploy.

## Environment-Specific Notes

| Environment | Namespace | Database | Stripe Mode |
|-------------|-----------|----------|-------------|
| Dev | figurio-dev | Local StatefulSet | Test keys |
| Staging | figurio-staging | Local StatefulSet | Test keys |
| Production | figurio-prod | Managed (TBD) | Live keys |
