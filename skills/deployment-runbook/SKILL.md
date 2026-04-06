---
name: deployment-runbook
description: Deployment procedures and rollback steps for the Figurio platform
---

# Deployment Runbook

## Standard Deployment (via CI/CD)

Automated on merge to `main`:

1. GitHub Actions builds Docker images
2. Images pushed to Docker Hub with tags: `latest`, `sha-{commit}`
3. Helm upgrade applied to `figurio-dev` namespace
4. Smoke test verifies health endpoints

### Manual Promotion to Staging/Prod

```bash
# Promote a specific image to staging
helm upgrade figurio-api infra/helm/figurio-api \
  --namespace figurio-staging \
  --set image.tag=sha-abc1234

helm upgrade figurio-web infra/helm/figurio-web \
  --namespace figurio-staging \
  --set image.tag=sha-abc1234
```

```bash
# Promote to production (same commands, different namespace)
helm upgrade figurio-api infra/helm/figurio-api \
  --namespace figurio-prod \
  --set image.tag=sha-abc1234
```

## Rollback Procedure

If a deployment causes issues:

```bash
# Instant rollback via Helm
helm rollback figurio-api 1 --namespace figurio-prod
helm rollback figurio-web 1 --namespace figurio-prod

# Verify rollback
kubectl get pods -n figurio-prod
curl -s https://api.figurio.cellarwood.org/health
```

## Health Check Endpoints

| Service | Endpoint | Expected |
|---------|----------|----------|
| API | `GET /health` | `{"status": "ok"}` |
| API | `GET /health/db` | `{"status": "ok", "db": "connected"}` |
| Web | `GET /` | HTTP 200 |

## Pre-Deployment Checklist

- [ ] All CI checks passing on the commit
- [ ] Database migrations applied (if any)
- [ ] Environment variables updated in K8s secrets (if any new ones)
- [ ] No ongoing incidents or maintenance windows

## Post-Deployment Verification

1. Check health endpoints
2. Verify Grafana dashboards for error rate spike
3. Place a test order in staging (Stripe test mode)
4. Check Sentry for new errors
