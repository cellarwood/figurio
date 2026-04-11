---
name: incident-response
description: >
  Incident handling for the Figurio platform — Sentry alert triage, rollback
  procedures for failed Helm deployments, database recovery steps, and Stripe
  webhook failure handling. Use this skill when responding to production alerts,
  outages, or degraded service on the Figurio platform.
allowed-tools:
  - Bash
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - devops
      - engineering
      - incident
---

# Incident Response

## When to Use

Use this skill when a production alert fires, a deployment causes a regression, a Stripe webhook fails, or the database enters a bad state. This is the playbook — work through it top-to-bottom and document every action taken.

## Severity Levels

| Level | Definition | Response Time |
|-------|-----------|---------------|
| P1 | Checkout unavailable, payments failing, site down | Immediate |
| P2 | Order pipeline degraded, high error rate, partial outage | < 15 min |
| P3 | Non-critical feature broken, elevated latency, isolated errors | < 1 hour |

## Phase 1 — Triage with Sentry

Sentry is the primary alert source. On receiving an alert:

1. Open the Sentry issue and identify: service, error type, first seen vs. spike.
2. Check the breadcrumb trail — was a deployment in the last 30 minutes?
3. Correlate with pod health:

```bash
kubectl get pods -n figurio
kubectl describe pod <crashing-pod> -n figurio
kubectl logs <crashing-pod> -n figurio --previous
```

4. Check Sentry release tracking — if the regression correlates with a new release, proceed to rollback immediately.

Key Sentry projects for Figurio:
- `figurio-api` — backend service errors
- `figurio-frontend` — client-side JS errors
- `figurio-workers` — background job failures (order processing, image rendering)

## Phase 2 — Deployment Rollback

If the incident is caused by a bad deploy, roll back via Helm.

```bash
# List recent revisions
helm history <release-name> -n figurio

# Roll back to the previous revision
helm rollback <release-name> -n figurio

# Roll back to a specific revision
helm rollback <release-name> <revision-number> -n figurio
```

Verify the rollback took effect:

```bash
kubectl rollout status deployment/<service-name> -n figurio
kubectl get pods -n figurio -l app=<service-name>
```

After rollback, confirm error rate drops in Sentry before declaring recovery. Allow 3-5 minutes for the rate to stabilize.

Pin the Docker image tag in `helm/<service-name>/values.yaml` back to the last known-good SHA and commit it.

## Phase 3 — Stripe Webhook Failure Handling

Stripe webhooks are the backbone of Figurio's order confirmation and fulfillment pipeline.

### Diagnosing

1. Check the Stripe Dashboard → Developers → Webhooks → Event log for delivery failures.
2. Identify whether the failure is a connectivity issue (5xx from Figurio) or a logic error (2xx but order not created).
3. Cross-reference with Sentry `figurio-api` for matching exceptions at the webhook endpoint.

### Recovery Steps

**If Figurio's webhook endpoint is returning 5xx (service down):**
- Restore service first (Phase 2 rollback or pod restart).
- Once healthy, use Stripe Dashboard to resend failed events: Webhooks → select endpoint → Failed deliveries → Resend.

**If events were silently dropped (2xx but no DB write):**
- Identify the order IDs from Stripe event payloads.
- Manually replay the events:

```bash
# Using Stripe CLI
stripe events resend <event-id>
```

- Confirm each replayed event creates the expected record in the database.

**If the webhook signing secret is mismatched:**
- Rotate the secret in the Stripe Dashboard.
- Update the Kubernetes secret:

```bash
kubectl create secret generic stripe-webhook-secret \
  --from-literal=secret=<new-secret> \
  --namespace figurio \
  --dry-run=client -o yaml | kubectl apply -f -
```

- Restart the API pod to pick up the new secret:

```bash
kubectl rollout restart deployment/figurio-api -n figurio
```

## Phase 4 — Database Recovery

### Pod-level DB Connection Issues

Check if the database pod is healthy:

```bash
kubectl get pods -n figurio -l app=postgres
kubectl logs -n figurio -l app=postgres --tail=50
```

If the pod is crash-looping, describe it for resource or config issues:

```bash
kubectl describe pod <postgres-pod> -n figurio
```

### Restoring from Backup

Figurio database backups are stored as Kubernetes CronJob outputs. Identify the latest backup:

```bash
kubectl get cronjobs -n figurio
kubectl get pods -n figurio -l job-name=db-backup --sort-by=.metadata.creationTimestamp
```

To restore:
1. Scale down dependent services to prevent writes during restore:

```bash
kubectl scale deployment figurio-api --replicas=0 -n figurio
kubectl scale deployment figurio-workers --replicas=0 -n figurio
```

2. Run the restore job (defined in `helm/postgres/templates/restore-job.yaml`), providing the backup file path.
3. Verify data integrity with a record count check.
4. Scale services back up:

```bash
kubectl scale deployment figurio-api --replicas=2 -n figurio
kubectl scale deployment figurio-workers --replicas=2 -n figurio
```

### Data Corruption

Do not attempt manual SQL fixes without a second pair of eyes. Snapshot the current state first:

```bash
kubectl exec -n figurio <postgres-pod> -- pg_dump figurio_production > /tmp/pre-fix-dump.sql
```

## Phase 5 — Post-Incident

After recovery:

1. Confirm error rate in Sentry has returned to baseline.
2. Verify all Stripe webhooks that failed during the incident have been replayed and orders are consistent.
3. Write a brief incident note capturing: timeline, root cause, fix applied, and follow-up action items.
4. Open a GitHub Issue tagged `incident` with the post-incident summary.
5. If a deployment caused the incident, add a regression test before the fix is redeployed.

## Quick Reference — Useful Commands

```bash
# Real-time pod logs across all figurio pods
kubectl logs -n figurio -l app=figurio-api -f --max-log-requests=5

# Resource usage — spot OOM candidates
kubectl top pods -n figurio

# Recent events in the namespace
kubectl get events -n figurio --sort-by=.lastTimestamp | tail -20

# Check Traefik is routing correctly after an incident
kubectl get ingressroute -n figurio
```

## Anti-patterns

- Do NOT restart pods as the first response without checking logs — it destroys the evidence.
- Do NOT manually edit the database without snapshotting first.
- Do NOT mark an incident resolved until Sentry error rate has stabilized, not just when the fix is deployed.
- Do NOT replay Stripe events in bulk without verifying idempotency — duplicate orders are a P1 in their own right.
