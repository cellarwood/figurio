---
name: deployment-runbook
description: >
  Figurio deployment procedures for the microk8s-local Kubernetes cluster.
  Covers Helm chart rollouts for backend/frontend/worker services, PostgreSQL
  Alembic migrations, rollback procedures, and post-deploy health checks.
allowed-tools:
  - Bash
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - devops
      - deployment
      - kubernetes
---

# Deployment Runbook

Figurio runs on a single-node microk8s cluster (`microk8s-local`). All services
are deployed via Helm charts. Docker images are hosted on Docker Hub under
`lukekelle00`. CI/CD is managed through GitHub Actions (`cellarwood/figurio`).

## Kubectl / Helm Context

Always confirm the correct context before any operation:

```bash
kubectl config use-context microk8s-local
kubectl config current-context   # verify
```

Namespace convention: `figurio-prod` for production, `figurio-staging` for staging.

## Services

| Service    | Helm chart path          | Docker image                    |
|------------|--------------------------|---------------------------------|
| backend    | `helm/backend`           | `lukekelle00/figurio-backend`   |
| frontend   | `helm/frontend`          | `lukekelle00/figurio-frontend`  |
| worker     | `helm/worker`            | `lukekelle00/figurio-worker`    |

## Standard Rollout

### 1. Build and push image (CI does this automatically on merge to main)

```bash
docker build --target production -t lukekelle00/figurio-<service>:<tag> .
docker push lukekelle00/figurio-<service>:<tag>
```

### 2. Run Alembic migrations (backend only — do this BEFORE deploying backend)

```bash
kubectl -n figurio-prod run alembic-migrate \
  --image=lukekelle00/figurio-backend:<tag> \
  --restart=Never \
  --env="DATABASE_URL=$(kubectl -n figurio-prod get secret figurio-db-secret -o jsonpath='{.data.url}' | base64 -d)" \
  -- alembic upgrade head

# Wait for completion, then check logs
kubectl -n figurio-prod logs alembic-migrate
kubectl -n figurio-prod delete pod alembic-migrate
```

Migrations must complete successfully before the backend Deployment is updated.
If migration fails, stop — do not proceed with the Helm upgrade.

### 3. Helm upgrade

```bash
helm upgrade --install figurio-<service> helm/<service> \
  --namespace figurio-prod \
  --set image.tag=<tag> \
  --atomic \
  --timeout 5m
```

`--atomic` rolls back automatically if the rollout fails within the timeout.
Deploy services in order: **backend → worker → frontend**.

### 4. Verify rollout

```bash
kubectl -n figurio-prod rollout status deployment/figurio-<service>
kubectl -n figurio-prod get pods -l app=figurio-<service>
```

## Health Check Endpoints

After each service deploy, verify:

| Service  | Endpoint                        | Expected        |
|----------|---------------------------------|-----------------|
| backend  | `GET /api/v1/health`            | `200 {"status":"ok"}` |
| frontend | `GET /healthz`                  | `200`           |
| worker   | `GET /worker/health`            | `200 {"status":"ok"}` |

Traefik ingress is the entry point. Check that TLS is terminating correctly:

```bash
curl -sf https://figurio.cz/api/v1/health
curl -sf https://figurio.cz/healthz
```

## Rollback

### Helm rollback (no schema changes)

```bash
helm rollback figurio-<service> 0 --namespace figurio-prod
# 0 = previous release; use `helm history figurio-<service> -n figurio-prod` to pick a specific revision
```

### Alembic downgrade (if migration was applied)

Identify the previous revision from migration history:

```bash
kubectl -n figurio-prod run alembic-downgrade \
  --image=lukekelle00/figurio-backend:<previous-tag> \
  --restart=Never \
  --env="DATABASE_URL=..." \
  -- alembic downgrade -1

kubectl -n figurio-prod logs alembic-downgrade
kubectl -n figurio-prod delete pod alembic-downgrade
```

Then roll back the backend Helm release to the previous tag.

**Rule:** Never downgrade the database while the newer backend version is still running.
Order: roll back backend deploy first (to old image), then run `alembic downgrade`.

## Redis

Redis is not versioned with Alembic. Cache keys are namespaced by service version.
On backend rollback, Redis keys from the new version may persist but are non-destructive —
the old backend ignores unknown key schemas.

## CI/CD Pipeline

GitHub Actions runs `.github/workflows/deploy.yml` on push to `main`.
Stages: build → push → migrate → helm-upgrade (per service).
Sentry release tracking is triggered at the end of a successful deploy.

Check pipeline status at: `https://github.com/cellarwood/figurio/actions`

## Post-Deploy Checklist

- [ ] All pods in `Running` state
- [ ] Health check endpoints return `200`
- [ ] Sentry: no new error spike in the 5 minutes after deploy
- [ ] Spot-check: place a test order through the storefront (staging only)
- [ ] Confirm Traefik TLS certificate is valid (`curl -vI https://figurio.cz`)
