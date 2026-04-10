---
name: deployment-runbook
description: >
  Step-by-step deployment procedures for Figurio services on microk8s (local/staging)
  and GKE (production). Covers rolling updates, rollback procedures, and health check
  verification for the React/TS frontend, FastAPI backend, and supporting infrastructure.
allowed-tools:
  - Read
  - Grep
  - Bash
metadata:
  paperclip:
    tags:
      - devops
      - deployment
      - kubernetes
---

# Deployment Runbook

Standard deployment procedures for all Figurio services. Follow these steps in order — do not skip verification steps.

## Environments

| Environment | Platform | Context |
|-------------|----------|---------|
| Local dev   | microk8s | `microk8s kubectl` |
| Staging     | microk8s | `microk8s kubectl -n staging` |
| Production  | GKE      | `kubectl` (GKE context via gcloud) |

Switch GKE context before any production operation:
```bash
gcloud container clusters get-credentials figurio-prod --region europe-west1
kubectl config current-context  # verify
```

## Pre-Deployment Checklist

Before every deployment:

- [ ] GitHub Actions CI pipeline is green on the target branch
- [ ] Docker image is published to `lukekelle00/<service>:<tag>` on Docker Hub
- [ ] Sentry release is created for the new version
- [ ] Stripe webhook endpoints are not in maintenance mode (if backend deploy)
- [ ] Zásilkovna API keys are unchanged (if backend deploy)
- [ ] Database migrations are applied (if schema changes)

## Rolling Update — Standard Deployment

### 1. Update the image tag

```bash
# Backend
kubectl set image deployment/figurio-backend \
  api=lukekelle00/figurio-backend:<new-tag> \
  -n figurio

# Frontend
kubectl set image deployment/figurio-frontend \
  web=lukekelle00/figurio-frontend:<new-tag> \
  -n figurio
```

### 2. Monitor the rollout

```bash
kubectl rollout status deployment/figurio-backend -n figurio --timeout=5m
kubectl rollout status deployment/figurio-frontend -n figurio --timeout=5m
```

Expected output: `successfully rolled out`

### 3. Health check verification

```bash
# Check pod readiness
kubectl get pods -n figurio -l app=figurio-backend
kubectl get pods -n figurio -l app=figurio-frontend

# Backend health endpoint
kubectl exec -n figurio deploy/figurio-backend -- \
  curl -sf http://localhost:8000/health

# Check recent logs for errors
kubectl logs -n figurio deploy/figurio-backend --since=2m | grep -i error
kubectl logs -n figurio deploy/figurio-frontend --since=2m | grep -i error
```

### 4. Smoke tests

- `GET /api/v1/products` returns 200 with product list
- `GET /api/v1/health` returns `{"status": "ok"}`
- Frontend loads at the root URL (check via Traefik ingress)
- Stripe webhook endpoint responds at `/api/v1/payments/webhook`

### 5. Sentry verification

Check Sentry for new error spikes in the first 5 minutes post-deploy. If error rate increases >10% over baseline, initiate rollback.

## Rollback Procedure

### Immediate rollback (within same deployment)

```bash
kubectl rollout undo deployment/figurio-backend -n figurio
kubectl rollout undo deployment/figurio-frontend -n figurio

# Verify rollback completed
kubectl rollout status deployment/figurio-backend -n figurio
kubectl rollout status deployment/figurio-frontend -n figurio
```

### Rollback to a specific revision

```bash
# List revision history
kubectl rollout history deployment/figurio-backend -n figurio

# Roll back to specific revision
kubectl rollout undo deployment/figurio-backend \
  --to-revision=<N> -n figurio
```

### Post-rollback checks

Run the same health check and smoke test steps from the standard deployment. Notify the team in the incident channel that a rollback occurred — do not leave this undocumented.

## Database Migrations

Run migrations before deploying the new backend image. Use a Kubernetes Job:

```bash
kubectl apply -f k8s/jobs/migrate.yaml -n figurio
kubectl wait --for=condition=complete job/figurio-migrate -n figurio --timeout=3m
kubectl logs job/figurio-migrate -n figurio
```

If migration fails: stop the deployment, do not proceed. Restore from the pre-migration backup if the migration is destructive.

## Traefik Ingress

After deploying changes that affect routing (new endpoints, path changes):

```bash
kubectl get ingressroute -n figurio
kubectl describe ingressroute figurio-ingress -n figurio
```

Verify Traefik picks up the new routes — check Traefik dashboard or logs if routes are not resolving.

## GitHub Actions — Automated Deploys

Production deploys are triggered by merging to `main`. The pipeline:
1. Runs tests
2. Builds and pushes `lukekelle00/<service>:${{ github.sha }}` to Docker Hub
3. Updates the Kubernetes deployment image tag
4. Runs smoke tests

Manual deploys (hotfixes) bypass the pipeline only when the pipeline itself is broken. Document the reason in the deploy log.

## Terraform Infrastructure Changes

For any infrastructure changes (GKE node pools, Traefik config, GCP resources):

```bash
cd terraform/
terraform plan -out=tfplan
# Review the plan carefully — never auto-apply on prod
terraform apply tfplan
```

Do not apply Terraform changes during active incidents.
