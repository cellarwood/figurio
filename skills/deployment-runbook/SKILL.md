---
name: deployment-runbook
description: Step-by-step deployment procedures for Figurio services — Docker build, push to Docker Hub (lukekelle00), Helm upgrade to microk8s-local K8s cluster.
---

# Deployment Runbook

## Purpose

Step-by-step procedures for deploying Figurio services to the microk8s-local Kubernetes cluster. Follow these steps exactly — no shortcuts in production.

## Architecture Overview

```
GitHub (source) → GitHub Actions (CI) → Docker Hub (registry) → microk8s-local (K8s)
```

- **Registry**: Docker Hub, namespace `lukekelle00`.
- **Orchestration**: microk8s-local (single-node Kubernetes).
- **Package manager**: Helm 3.
- **Environments**: dev, staging, prod (separate namespaces).

## Docker Image Naming

| Service      | Image Name                        | Example Tag          |
|--------------|-----------------------------------|----------------------|
| Web frontend | `lukekelle00/figurio-web:TAG`     | `v1.2.0`, `latest`  |
| API backend  | `lukekelle00/figurio-api:TAG`     | `v1.2.0`, `latest`  |

Tag format:
- Release: `v{MAJOR}.{MINOR}.{PATCH}` (e.g., `v1.2.0`).
- Dev/staging: `{branch}-{short-sha}` (e.g., `main-a1b2c3d`).
- Latest: `latest` tag updated only from main branch builds.

## Deployment Steps

### 1. Pre-Deploy Checklist

- [ ] All tests pass on the branch being deployed.
- [ ] Code has been reviewed and merged to the target branch.
- [ ] Database migrations (if any) have been tested locally.
- [ ] Environment variables and secrets are up to date in K8s.
- [ ] MCAE vendor status checked (no planned outages affecting fulfillment).

### 2. Build Docker Images

```bash
# API backend
docker build -t lukekelle00/figurio-api:${TAG} -f docker/api/Dockerfile .

# Web frontend
docker build -t lukekelle00/figurio-web:${TAG} -f docker/web/Dockerfile .
```

Multi-stage builds:
- Stage 1: Install dependencies and run tests.
- Stage 2: Build production artifacts.
- Stage 3: Minimal runtime image (python:3.11-slim for API, nginx:alpine for web).

### 3. Run Tests in Container

```bash
docker run --rm lukekelle00/figurio-api:${TAG} pytest --tb=short
docker run --rm lukekelle00/figurio-web:${TAG} npm run test -- --ci
```

Do not push images that fail tests.

### 4. Push to Docker Hub

```bash
docker push lukekelle00/figurio-api:${TAG}
docker push lukekelle00/figurio-web:${TAG}
```

### 5. Run Database Migrations (if applicable)

```bash
# Connect to the cluster
microk8s kubectl -n ${NAMESPACE} exec -it deploy/figurio-api -- \
  alembic upgrade head
```

Always run migrations before deploying the new application version.

### 6. Helm Upgrade

```bash
# API backend
microk8s helm3 upgrade figurio-api ./helm/figurio-api \
  --namespace ${NAMESPACE} \
  --set image.tag=${TAG} \
  --values ./helm/figurio-api/values-${ENV}.yaml \
  --wait --timeout 5m

# Web frontend
microk8s helm3 upgrade figurio-web ./helm/figurio-web \
  --namespace ${NAMESPACE} \
  --set image.tag=${TAG} \
  --values ./helm/figurio-web/values-${ENV}.yaml \
  --wait --timeout 5m
```

### 7. Post-Deploy Verification

- [ ] Pods are running: `microk8s kubectl -n ${NAMESPACE} get pods`.
- [ ] Health check passes: `curl https://${DOMAIN}/health`.
- [ ] API docs accessible: `curl https://${DOMAIN}/docs`.
- [ ] Frontend loads: open `https://${DOMAIN}` in browser.
- [ ] Smoke test: browse catalog, add to cart, verify 3D viewer loads.
- [ ] Check logs for errors: `microk8s kubectl -n ${NAMESPACE} logs deploy/figurio-api --tail=50`.
- [ ] Stripe webhook test: send test event from Stripe Dashboard.

## Rollback Procedure

If post-deploy verification fails:

```bash
# Rollback to previous Helm release
microk8s helm3 rollback figurio-api 0 --namespace ${NAMESPACE}
microk8s helm3 rollback figurio-web 0 --namespace ${NAMESPACE}

# If database migration needs reversal
microk8s kubectl -n ${NAMESPACE} exec -it deploy/figurio-api -- \
  alembic downgrade -1
```

- `rollback 0` reverts to the immediately previous release.
- Always rollback application first, then database migration.
- Notify the team immediately in Slack when rolling back production.

## Environment Configuration

### Namespaces

| Environment | Namespace       | Domain                     |
|-------------|-----------------|----------------------------|
| Development | figurio-dev     | dev.figurio.local          |
| Staging     | figurio-staging | staging.figurio.local      |
| Production  | figurio-prod    | figurio.cz                 |

### Helm Values per Environment

Each environment has its own values file:

- `values-dev.yaml`: Single replica, debug logging, Stripe test keys.
- `values-staging.yaml`: Single replica, info logging, Stripe test keys.
- `values-prod.yaml`: 2+ replicas, warn logging, Stripe live keys.

### Kubernetes Secrets

Managed via `microk8s kubectl create secret`:

```
figurio-api-secrets:
  STRIPE_SECRET_KEY
  STRIPE_WEBHOOK_SECRET
  DATABASE_URL
  JWT_SECRET_KEY
  AI_SERVICE_API_KEY

figurio-db-secrets:
  POSTGRES_PASSWORD
```

Never store secrets in Helm values files or Git.

## Deployment Frequency

- **Production**: Weekly releases (Tuesday), hotfixes as needed.
- **Staging**: On every merge to main.
- **Development**: On every push to feature branches.

## Emergency Hotfix Process

1. Create branch `hotfix/{description}` from main.
2. Fix, test, push, and get expedited review.
3. Merge to main.
4. Deploy directly to production following steps 2-7 above.
5. Skip staging for true emergencies, but deploy to staging afterward for parity.
