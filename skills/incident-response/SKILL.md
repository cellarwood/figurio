---
name: incident-response
description: >
  Figurio incident response playbook for the devops-engineer agent.
  Defines severity levels (P1: payments broken, P2: orders stuck, P3: degraded
  performance), Sentry alert triage, MCAE API outage handling, and database
  recovery procedures on microk8s-local.
allowed-tools:
  - Bash
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - devops
      - incident
      - on-call
---

# Incident Response

Figurio is a D2C e-commerce platform selling 3D-printed figurines. Incidents
affecting checkout, order processing, or print-job dispatch have direct revenue
impact. This playbook covers triage, severity classification, and resolution steps.

## Severity Levels

| Level | Definition | Examples | Response SLA |
|-------|-----------|----------|--------------|
| P1 | Payments broken — customers cannot complete purchases | Payment gateway 5xx, checkout API down, Stripe webhook failures | Immediate — fix or rollback within 30 min |
| P2 | Orders stuck — purchases succeed but fulfillment halted | Worker not dispatching print jobs, MCAE API unreachable, queue backlog > 100 | Within 2 hours |
| P3 | Degraded performance — site slow or partial errors | High latency, elevated error rate < 10%, non-critical API failures | Within 8 hours |

## First Steps for Any Incident

1. Check Sentry for active issues: `https://sentry.io/organizations/figurio`
2. Check pod health on the cluster:
   ```bash
   kubectl config use-context microk8s-local
   kubectl -n figurio-prod get pods
   kubectl -n figurio-prod get events --sort-by='.lastTimestamp' | tail -30
   ```
3. Check recent deployments — was there a deploy in the last 30 minutes?
   ```bash
   helm history figurio-backend -n figurio-prod | tail -5
   helm history figurio-worker -n figurio-prod | tail -5
   ```
4. If a deploy is the likely cause, **roll back immediately** before further diagnosis.
   See the `deployment-runbook` skill for rollback steps.

## P1 — Payments Broken

### Symptoms
- Sentry: `PaymentError`, `CheckoutFailure`, or `StripeWebhookError` alerts
- `POST /api/v1/orders` returning 5xx
- Customer reports of failed purchases

### Diagnosis

```bash
# Check backend pod logs for payment errors
kubectl -n figurio-prod logs -l app=figurio-backend --tail=100 | grep -i "payment\|stripe\|checkout"

# Verify backend is up and responding
curl -sf https://figurio.cz/api/v1/health

# Check if Stripe webhook endpoint is reachable
curl -sf https://figurio.cz/api/v1/webhooks/stripe
```

### Resolution Steps

1. If backend pods are crashing — rollback the last backend deploy.
2. If Stripe is returning errors — check Stripe status page; this is an external
   dependency. Set site to maintenance mode until Stripe recovers.
3. If webhook signature validation is failing — verify the `STRIPE_WEBHOOK_SECRET`
   environment variable in the backend deployment:
   ```bash
   kubectl -n figurio-prod get deployment figurio-backend -o jsonpath='{.spec.template.spec.containers[0].env}'
   ```
4. After fix: place a test order end-to-end in staging before declaring resolved.

## P2 — Orders Stuck

### Symptoms
- New orders in the database with status `pending` or `submitted` for > 15 minutes
- Worker pod logs show connection errors or retry loops
- Sentry: `PrintJobDispatchError`, `McaeApiError`

### Diagnosis

```bash
# Check worker pod status and logs
kubectl -n figurio-prod get pods -l app=figurio-worker
kubectl -n figurio-prod logs -l app=figurio-worker --tail=100

# Check Redis queue depth
kubectl -n figurio-prod exec -it deploy/figurio-worker -- redis-cli -h redis LLEN figurio:jobs:pending

# Check PostgreSQL connectivity from worker
kubectl -n figurio-prod exec -it deploy/figurio-worker -- python -c "import psycopg2; print('db ok')"
```

### MCAE API Outage

MCAE (the 3D print fulfillment API) is an external dependency. When it is unreachable:

1. Worker will retry with exponential backoff — check if retries are actually happening:
   ```bash
   kubectl -n figurio-prod logs -l app=figurio-worker --tail=200 | grep -i "mcae\|retry\|backoff"
   ```
2. If MCAE is confirmed down (not a local network issue), jobs queue up in Redis.
   This is tolerable for up to 4 hours — Redis and worker will drain automatically
   when MCAE recovers.
3. If Redis queue grows beyond 500 jobs, escalate — manual intervention may be needed
   to prevent memory pressure on the single-node cluster.
4. Notify the business: orders will be fulfilled once MCAE recovers. No data is lost.

### Resolution Steps

1. If worker pods are crash-looping — check for a bad deploy; roll back if needed.
2. If MCAE is up but rejecting requests — check API credentials:
   ```bash
   kubectl -n figurio-prod get secret figurio-mcae-secret -o jsonpath='{.data.api_key}' | base64 -d
   ```
3. If Redis is the problem — restart the worker after confirming Redis is healthy:
   ```bash
   kubectl -n figurio-prod rollout restart deployment/figurio-worker
   ```

## P3 — Degraded Performance

### Symptoms
- Sentry: elevated error rate, slow transaction traces
- Traefik dashboard showing high latency on backend routes
- CPU or memory pressure on the microk8s node

### Diagnosis

```bash
# Node resource usage
kubectl top nodes
kubectl top pods -n figurio-prod

# Check for OOMKilled pods
kubectl -n figurio-prod get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.containerStatuses[0].lastState.terminated.reason}{"\n"}{end}'

# PostgreSQL slow queries — connect via port-forward
kubectl -n figurio-prod port-forward svc/figurio-postgres 5432:5432 &
psql $DATABASE_URL -c "SELECT pid, now() - query_start AS duration, query FROM pg_stat_activity WHERE state = 'active' ORDER BY duration DESC LIMIT 10;"
```

### Resolution Steps

1. OOMKilled pods — increase memory limits in the Helm values and redeploy, or
   identify the memory leak via Sentry performance traces.
2. Slow PostgreSQL queries — identify the offending query, add an index or optimize
   via a new Alembic migration.
3. Redis cache miss spike — check if cache keys were invalidated by a recent deploy;
   warm the cache by triggering a few product page loads.

## Database Recovery

### Alembic migration failure mid-deploy

If a migration partially applied and the backend is in a broken state:

1. **Do not restart the backend** — keep traffic away by scaling to 0:
   ```bash
   kubectl -n figurio-prod scale deployment/figurio-backend --replicas=0
   ```
2. Inspect migration state:
   ```bash
   kubectl -n figurio-prod run alembic-check \
     --image=lukekelle00/figurio-backend:<tag> \
     --restart=Never \
     --env="DATABASE_URL=..." \
     -- alembic current
   ```
3. Attempt `alembic downgrade -1` if the previous revision is safe to return to.
4. If downgrade is not safe, restore from the most recent PostgreSQL backup.
5. Scale backend back up only after migrations are in a clean state.

### PostgreSQL pod crash

```bash
# Check pod status and events
kubectl -n figurio-prod describe pod -l app=figurio-postgres

# If PVC is healthy but pod crashed, restart
kubectl -n figurio-prod rollout restart statefulset/figurio-postgres
```

If the PV/PVC is corrupted, restore from the latest backup snapshot before attempting
any data repair.

## Sentry Alert Triage

- **New issue spike immediately after deploy** — likely regression, roll back.
- **Recurring known issue** — check if there is an open GitHub issue; tag it.
- **MCAE-related errors** — correlate with MCAE status; mute the alert if it is a
  known external outage with an ETA.
- **Payment errors** — always P1 regardless of volume. Do not mute.

Sentry project slugs: `figurio-backend`, `figurio-frontend`, `figurio-worker`.

## Post-Incident

After every P1 or P2 resolution:
1. Document what broke, why, and how it was fixed in a GitHub issue tagged `incident`.
2. Add a Sentry alert rule if the failure mode was not already monitored.
3. Update this runbook if a new resolution pattern was discovered.
