---
name: deployment-runbook
description: >
  Step-by-step deployment runbook for Figurio services on microk8s. Covers Helm
  chart rollout, Traefik ingress configuration, Docker Hub image tagging
  (lukekelle00), health checks, rollback procedure, and secret rotation for
  Stripe and database credentials.
allowed-tools:
  - Read
  - Grep
  - Bash
metadata:
  paperclip:
    tags:
      - engineering
      - devops
      - deployment
---

# Deployment Runbook

Standard operating procedure for deploying Figurio services to the microk8s
Kubernetes cluster. Follow this runbook for every production deployment.

## When to Use

Use this runbook when:
- Promoting a GitHub Actions CI/CD build to production
- Performing a hotfix rollout outside the normal release cadence
- Rotating Stripe or database secrets
- Recovering from a failed rollout

## Pre-flight Checks

Before initiating a rollout, confirm:

1. GitHub Actions workflow is green on `main` — Docker image pushed to
   `lukekelle00/<service>:<sha>` on Docker Hub.
2. Sentry release is tagged so errors from the new version are attributed
   correctly.
3. No active P1/P2 incidents are open (hold deployment until resolved).
4. Run a quick sanity check on the target cluster:

```bash
microk8s kubectl get nodes          # all nodes Ready
microk8s kubectl get pods -n figurio  # no pods in CrashLoopBackOff
```

## Image Tagging Convention

All production images are tagged with both the Git SHA and `latest`:

```
lukekelle00/<service>:<git-sha-7>
lukekelle00/<service>:latest
```

Never deploy `latest` directly in Helm values — always pin the SHA tag so
rollbacks are unambiguous.

## Helm Rollout

Figurio services live under `helm/figurio/`. Each service has a
`values-prod.yaml` override file.

### Update the image tag

```bash
# Edit helm/figurio/values-prod.yaml
image:
  repository: lukekelle00/<service>
  tag: "<git-sha-7>"
```

### Apply the release

```bash
microk8s helm3 upgrade --install figurio-<service> helm/figurio/ \
  -f helm/figurio/values-prod.yaml \
  --namespace figurio \
  --atomic \
  --timeout 5m
```

`--atomic` rolls back automatically if pods do not become Ready within the
timeout. Check Helm history after:

```bash
microk8s helm3 history figurio-<service> --namespace figurio
```

## Traefik Ingress Configuration

Ingress resources are declared in `helm/figurio/templates/ingress.yaml`. Key
conventions:

- Ingress class: `traefik` (set via `kubernetes.io/ingress.class: traefik`)
- TLS termination handled by Traefik with Let's Encrypt — do not add manual
  cert-manager annotations unless instructed.
- Host patterns:
  - `figurio.cz` → frontend service
  - `api.figurio.cz` → backend API service
  - `ai.figurio.cz` → AI custom figurine pipeline service

When adding a new route, update `values-prod.yaml` ingress block and verify
Traefik picks it up:

```bash
microk8s kubectl get ingressroute -n figurio
```

## Health Checks

After every rollout, verify:

```bash
# Pod readiness
microk8s kubectl rollout status deployment/<service> -n figurio --timeout=3m

# HTTP smoke test
curl -sf https://api.figurio.cz/health | jq .status  # expect "ok"
curl -sf https://figurio.cz/                          # expect HTTP 200
curl -sf https://ai.figurio.cz/health | jq .status   # expect "ok"
```

Check Sentry for any new error spike in the first 5 minutes post-deploy.

## Rollback Procedure

### Helm rollback (preferred)

```bash
microk8s helm3 rollback figurio-<service> --namespace figurio
```

This reverts to the previous Helm revision. Confirm with:

```bash
microk8s helm3 history figurio-<service> --namespace figurio
microk8s kubectl rollout status deployment/<service> -n figurio
```

### Manual image pin (emergency)

If Helm state is inconsistent, patch the deployment directly:

```bash
microk8s kubectl set image deployment/<service> \
  <container>=lukekelle00/<service>:<previous-sha> \
  -n figurio
```

Then reconcile Helm values to match so the next `helm upgrade` does not
re-introduce the broken image.

## Secret Rotation

### Stripe credentials

Stripe keys are stored in the `figurio-stripe` Kubernetes Secret.

1. Generate new restricted key in the Stripe Dashboard.
2. Update the secret:

```bash
microk8s kubectl create secret generic figurio-stripe \
  --from-literal=STRIPE_SECRET_KEY=sk_live_... \
  --from-literal=STRIPE_WEBHOOK_SECRET=whsec_... \
  --namespace figurio \
  --dry-run=client -o yaml | microk8s kubectl apply -f -
```

3. Restart the backend deployment to pick up the new secret:

```bash
microk8s kubectl rollout restart deployment/backend -n figurio
```

4. Verify Stripe webhook delivery in the Stripe Dashboard — confirm at least
   one successful event within 2 minutes.
5. Revoke the old Stripe key only after confirming the new one is active.

### Database credentials

DB credentials are stored in the `figurio-db` Kubernetes Secret.

1. Rotate the password in the database (coordinate with backend-engineer if
   schema migrations are pending — do not rotate mid-migration).
2. Update the secret:

```bash
microk8s kubectl create secret generic figurio-db \
  --from-literal=DATABASE_URL=postgres://... \
  --namespace figurio \
  --dry-run=client -o yaml | microk8s kubectl apply -f -
```

3. Restart all workloads that mount the secret:

```bash
microk8s kubectl rollout restart deployment/backend deployment/ai-pipeline \
  -n figurio
```

4. Confirm pod restarts succeed and `/health` endpoints return `"ok"`.

## Post-Deploy Checklist

- [ ] All pods in `figurio` namespace are Running/Ready
- [ ] HTTP smoke tests pass for all three hosts
- [ ] Sentry shows no new error spikes
- [ ] Helm history shows `DEPLOYED` status for the new revision
- [ ] Stripe test transaction completes end-to-end (for backend deploys)
