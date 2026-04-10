---
name: deployment-runbook
description: >
  Step-by-step deployment procedures for the Figurio platform on microk8s.
  Covers Traefik IngressRoute and SSL certificate setup, GitHub Actions CI/CD
  pipeline, rolling updates via Helm, rollback procedures, and PostgreSQL
  migration sequencing.
allowed-tools:
  - Read
  - Write
  - Bash
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - devops
      - deployment
---

# Deployment Runbook

Standard deployment procedures for Figurio's microk8s cluster. Follow these
steps in order. Default to rollback when in doubt — see the Rollback section.

## Services Overview

| Service | Image | Registry |
|---------|-------|----------|
| frontend | `lukekelle00/figurio-frontend:<tag>` | Docker Hub |
| backend | `lukekelle00/figurio-backend:<tag>` | Docker Hub |
| postgres | in-cluster StatefulSet | — |

Image tags use the short Git SHA (`git rev-parse --short HEAD`). The CI/CD
pipeline tags and pushes on every successful merge to `main`.

---

## 1. Pre-Deployment Checklist

Before any production deploy:

- [ ] GitHub Actions build job passed on `main` (green check on commit)
- [ ] New image exists on Docker Hub: `docker pull lukekelle00/figurio-{service}:<sha>`
- [ ] No active incidents open in Sentry for the affected service
- [ ] PostgreSQL migrations (if any) reviewed — see section 4
- [ ] Helm diff reviewed: `helm diff upgrade figurio ./helm/figurio -f helm/figurio/values.prod.yaml`

---

## 2. CI/CD Pipeline (GitHub Actions)

Pipeline file: `.github/workflows/deploy.yml`

On merge to `main`:
1. **Build** — Docker multi-stage build for `frontend` and `backend`
2. **Push** — Tag as `<sha>` and `latest`, push both to Docker Hub (`lukekelle00`)
3. **Deploy** — `helm upgrade` against the microk8s cluster via `kubectl` configured with the cluster kubeconfig secret

The deploy step runs a rolling update. Monitor rollout:

```bash
kubectl rollout status deployment/figurio-backend -n figurio
kubectl rollout status deployment/figurio-frontend -n figurio
```

A rollout is complete when all pods show `Running` and ready counts match
desired. If it stalls for more than 5 minutes, proceed to the Rollback section.

---

## 3. Traefik IngressRoute and SSL

IngressRoute manifests live under `helm/figurio/templates/ingress.yaml`.

Traefik uses ACME (Let's Encrypt) for automatic TLS. Certificate state:

```bash
# Check cert-manager or Traefik ACME certificate status
kubectl get certificate -n figurio
kubectl describe certificate figurio-tls -n figurio
```

If a certificate is not Ready after a fresh cluster setup:

1. Confirm Traefik ACME resolver is configured in `traefik.yaml` (or Helm
   values for the Traefik addon).
2. Confirm DNS A records for `figurio.cz` (and subdomains) point to the
   cluster's public IP.
3. Check Traefik pod logs: `kubectl logs -n kube-system -l app=traefik`
4. ACME challenges require port 80 to be reachable from the internet.

**To add a new IngressRoute** for a service, update
`helm/figurio/templates/ingress.yaml` and apply with `helm upgrade`.

---

## 4. Database Migrations

Migrations run **before** the new application pods are deployed.

### Migration Sequence

1. Take a PostgreSQL backup (see section 5).
2. Run the migration job:

```bash
kubectl apply -f k8s/jobs/migrate.yaml -n figurio
kubectl wait --for=condition=complete job/figurio-migrate -n figurio --timeout=120s
kubectl logs job/figurio-migrate -n figurio
```

3. Confirm exit code 0 and no error lines in logs.
4. Proceed with the Helm rolling update only after migration confirms success.
5. If migration fails, **do not deploy** the new image. Investigate logs,
   restore from backup if data was mutated, then fix and re-run.

---

## 5. PostgreSQL Backup

A CronJob runs automated backups. To take a manual backup before a risky
change:

```bash
kubectl create job --from=cronjob/figurio-pg-backup manual-backup-$(date +%Y%m%d) -n figurio
kubectl wait --for=condition=complete job/manual-backup-$(date +%Y%m%d) -n figurio --timeout=300s
```

Confirm backup file appears in the configured backup destination (PVC or
object storage bucket).

---

## 6. Rolling Update (Helm)

Standard production deploy after CI pipeline has pushed images:

```bash
# Dry run first — always
helm upgrade figurio ./helm/figurio \
  -f helm/figurio/values.prod.yaml \
  --set backend.image.tag=<sha> \
  --set frontend.image.tag=<sha> \
  --dry-run

# Apply
helm upgrade figurio ./helm/figurio \
  -f helm/figurio/values.prod.yaml \
  --set backend.image.tag=<sha> \
  --set frontend.image.tag=<sha>
```

Watch rollout:

```bash
kubectl rollout status deployment/figurio-backend -n figurio --timeout=5m
kubectl rollout status deployment/figurio-frontend -n figurio --timeout=5m
```

Post-deploy smoke checks:
- `curl -I https://figurio.cz` returns `200`
- Stripe webhook endpoint `/api/webhooks/stripe` returns `200` on GET health
- Sentry shows no new error spike in the 5 minutes after deploy

---

## 7. Rollback

**Default: roll back first, investigate after.**

### Option A — Helm rollback (preferred)

```bash
helm history figurio -n figurio          # find last known good revision
helm rollback figurio <revision> -n figurio
kubectl rollout status deployment/figurio-backend -n figurio
kubectl rollout status deployment/figurio-frontend -n figurio
```

### Option B — kubectl image rollback (emergency only)

```bash
kubectl rollout undo deployment/figurio-backend -n figurio
kubectl rollout undo deployment/figurio-frontend -n figurio
```

### Database rollback

If migrations ran and must be reverted:

1. Stop the backend deployment: `kubectl scale deployment/figurio-backend --replicas=0 -n figurio`
2. Restore from the pre-deploy backup (see restore procedure in the PostgreSQL
   runbook).
3. Roll back the Helm release to the previous revision.
4. Scale backend back up: `kubectl scale deployment/figurio-backend --replicas=<n> -n figurio`

Always document the rollback decision in the relevant GitHub issue or Slack
`#ops` channel with: what was rolled back, why, and what revision is now running.

---

## 8. Cluster Health Checks

Run after any deployment or incident to confirm cluster state:

```bash
kubectl get nodes                                  # all nodes Ready
kubectl get pods -n figurio                        # all pods Running
kubectl top nodes                                  # CPU/memory within limits
kubectl top pods -n figurio
kubectl get pvc -n figurio                         # PVCs Bound
```
