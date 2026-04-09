---
name: deployment-runbook
description: >
  Step-by-step deployment procedures for the Figurio platform on MicroK8s —
  Docker build, Helm deploy, database migration, rollback procedures,
  and health check verification.
---

# Deployment Runbook

## Standard Deployment (CI/CD)

Triggered automatically on merge to main via GitHub Actions:

1. Run tests (pytest for backend, vitest for frontend)
2. Build Docker images (multi-stage, Alpine base)
3. Push to Docker Hub (`lukekelle00/figurio-frontend:{sha}`, `lukekelle00/figurio-backend:{sha}`)
4. Helm upgrade on MicroK8s cluster
5. Wait for rollout completion
6. Run smoke tests against production

## Manual Deployment

```bash
# 1. Build images
docker build -t lukekelle00/figurio-frontend:latest -f frontend/Dockerfile .
docker build -t lukekelle00/figurio-backend:latest -f backend/Dockerfile .

# 2. Push to Docker Hub
docker push lukekelle00/figurio-frontend:latest
docker push lukekelle00/figurio-backend:latest

# 3. Deploy via Helm
helm upgrade figurio ./helm/figurio \
  --namespace figurio \
  --set frontend.image.tag=latest \
  --set backend.image.tag=latest \
  --wait --timeout 5m

# 4. Verify
kubectl get pods -n figurio
kubectl logs -n figurio -l app=figurio-backend --tail=20
```

## Database Migration

```bash
# Run inside the backend pod
kubectl exec -n figurio deploy/figurio-backend -- alembic upgrade head
```

Always run migrations BEFORE deploying new backend code that depends on the schema change.

## Rollback

```bash
# Rollback Helm release to previous revision
helm rollback figurio -n figurio

# Verify
kubectl get pods -n figurio
```

If a database migration needs reverting:
```bash
kubectl exec -n figurio deploy/figurio-backend -- alembic downgrade -1
```

## Health Checks

- Frontend: `GET /` returns 200
- Backend: `GET /api/v1/health` returns `{"status": "ok"}`
- Database: backend health check includes DB connection test
