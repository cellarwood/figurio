---
name: incident-response
description: >
  Incident response procedures for the Figurio e-commerce platform — severity
  levels P1-P4, escalation paths, communication templates, and post-mortem process.
  Covers Stripe payment failures, backend API downtime, PostgreSQL issues, and
  production K8s/infrastructure problems. Use when detecting or responding to
  any service degradation.
allowed-tools:
  - Bash
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - devops
      - operations
---

# Incident Response

## When to Use

Use this skill when:
- A Sentry alert fires with an elevated error rate
- Prometheus alert triggers (pod down, high latency, certificate expiry)
- A Stripe webhook fails or payment processing stops
- The API or storefront is unreachable
- A database migration fails or PostgreSQL is unavailable
- Any production anomaly is reported by the CEO, CMO, or Head of Operations

## Severity Levels

| Level | Name | Criteria | Response SLA |
|-------|------|----------|--------------|
| P1 | Critical | Full site/API down, Stripe payments failing, data loss risk | Immediate — 15 min |
| P2 | High | Partial outage (checkout broken, AI pipeline down, >50% error rate) | 30 min |
| P3 | Medium | Degraded performance, non-critical feature broken, elevated errors | 2 hours |
| P4 | Low | Cosmetic issues, minor bugs, non-user-facing degradation | Next business day |

## Escalation Paths

```
DevOps Engineer
  └─ P1/P2: escalate immediately to CTO
       └─ CTO: determines if CEO/operations comms needed
            └─ P1 Stripe failure: also notify Head of Operations
                 (orders may need to be held until payment confirmed)
```

- **DevOps Engineer** owns: K8s/infra, deployments, database ops, CI/CD
- **Backend Engineer** owns: application bugs, API errors, Stripe integration code
- **CTO** owns: cross-team coordination, architectural decisions during incident
- **Head of Operations** owns: customer-facing impact, MCAE print hold decisions

## P1 Response Procedure

### Step 1 — Detect & Declare (0-5 min)

```bash
# Check pod health
microk8s kubectl get pods -n figurio-prod

# Check recent events
microk8s kubectl get events -n figurio-prod --sort-by='.lastTimestamp' | tail -20

# Check ingress
microk8s kubectl get ingressroute -n figurio-prod

# Quick API probe
curl -sf https://api.figurio.com/health || echo "API DOWN"
curl -sf https://figurio.com || echo "FRONTEND DOWN"
```

Declare a P1 by notifying the CTO immediately. Do not wait to fully diagnose first.

### Step 2 — Contain (5-15 min)

Depending on the failure:

**API is down (CrashLoopBackOff or ImagePullBackOff):**
```bash
# Roll back to last known good revision
microk8s helm rollback figurio-backend -n figurio-prod
microk8s kubectl rollout status deployment/figurio-backend -n figurio-prod
```

**Stripe payments failing:**
- Check Stripe Dashboard → Developers → Events for webhook errors.
- Check backend logs for `stripe` errors:
  ```bash
  microk8s kubectl logs -l app=figurio-backend -n figurio-prod --tail=100 | grep -i stripe
  ```
- If a bad deploy caused it, roll back backend (see `deployment-runbook` skill).
- If Stripe-side, check `https://status.stripe.com` and hold new orders.

**Database unreachable:**
```bash
# Check PostgreSQL pod
microk8s kubectl get pods -n figurio-prod -l app=postgresql
microk8s kubectl describe pod -l app=postgresql -n figurio-prod

# Check logs
microk8s kubectl logs -l app=postgresql -n figurio-prod --tail=50

# If pod crashed, restart
microk8s kubectl rollout restart deployment/postgresql -n figurio-prod
```
If data is at risk (disk full, corruption), stop writes immediately — scale backend to 0:
```bash
microk8s kubectl scale deployment figurio-backend --replicas=0 -n figurio-prod
```

### Step 3 — Communicate

Use these templates. Send via Google Chat or email to CTO (and CEO if P1).

**Initial Alert (P1):**
```
[INCIDENT P1] <short description>
Time detected: <HH:MM UTC>
Impact: <what users cannot do>
Status: Investigating
Owner: DevOps Engineer
```

**Update (every 15 min for P1, 30 min for P2):**
```
[INCIDENT UPDATE] <title>
Time: <HH:MM UTC>
Status: <Investigating | Mitigating | Monitoring>
Latest: <what was tried, what was found>
ETA to resolve: <estimate or "unknown">
```

**Resolution:**
```
[INCIDENT RESOLVED] <title>
Time resolved: <HH:MM UTC>
Duration: <X min>
Root cause: <1 sentence>
Fix applied: <1 sentence>
Post-mortem: scheduled / not required (P3/P4)
```

## Failure-Specific Playbooks

### Stripe Payment Failure

1. Check Stripe dashboard for webhook delivery failures.
2. Check `figurio-backend` logs for 4xx/5xx on `/webhooks/stripe`.
3. Verify `STRIPE_WEBHOOK_SECRET` K8s Secret is intact:
   ```bash
   microk8s kubectl get secret figurio-secrets -n figurio-prod -o jsonpath='{.data.STRIPE_WEBHOOK_SECRET}' | base64 -d | wc -c
   ```
4. If webhook endpoint is unreachable (ingress issue), fix ingress first.
5. Replay failed webhook events from Stripe Dashboard → Developers → Webhooks.
6. Notify Head of Operations if any orders were placed during the window —
   payment status must be manually verified before print jobs are submitted to MCAE.

### API Downtime

1. Check pod state (CrashLoop → check logs, ImagePullBackOff → check image tag/registry).
2. Check if a bad deploy triggered it → roll back via Helm.
3. Check if a failed DB migration left the schema in a broken state →
   check migration logs, consider downgrade.
4. Check Sentry for the first error after the outage began.

### Database Issues

- **Disk full:** expand PVC or delete old data. Do not restart PostgreSQL while disk is full.
- **Connection pool exhausted:** check `max_connections`, restart backend pods to reset pool.
- **Failed migration:** do NOT deploy backend with new code — roll back migration:
  ```bash
  microk8s kubectl exec -it deploy/figurio-backend -n figurio-prod -- alembic downgrade -1
  ```
- **Corruption suspicion:** stop all writes, restore from latest `pg_dump` backup.

### Sentry Error Spike (No Full Outage)

1. Open Sentry, filter to `figurio-backend` or `figurio-frontend`, sort by frequency.
2. Identify the new error — correlate with last deploy time.
3. If caused by a deploy: roll back. If pre-existing but newly surfaced: create bug ticket.
4. Downgrade to P3 if user impact is limited.

## Post-Mortem Process

Required for all P1 incidents. Optional for P2 (use judgment).

**Timeline:** Draft within 24 hours, finalize within 72 hours.

**Post-Mortem Structure:**

```
Title: <Incident title>
Date: <YYYY-MM-DD>
Severity: P1 / P2
Duration: <X min>
Author: DevOps Engineer

## Summary
One paragraph describing what happened and its business impact.

## Timeline (UTC)
HH:MM — first alert / detection
HH:MM — escalation
HH:MM — root cause identified
HH:MM — fix applied
HH:MM — resolved

## Root Cause
Technical description of the root cause.

## Impact
- Users affected: <estimate>
- Orders blocked: <count or "unknown">
- Revenue impact: <estimate or N/A>

## Contributing Factors
- [What made this more likely or harder to detect?]

## Action Items
| Action | Owner | Due Date |
|--------|-------|----------|
| Add alert for X | DevOps | YYYY-MM-DD |
| Fix Y in code | Backend Engineer | YYYY-MM-DD |
```

Share the completed post-mortem with the CTO. Store in Google Drive under
`Engineering / Incidents / <YYYY-MM-DD>-<slug>.md`.

## Anti-Patterns

- Do not chase root cause before containing the blast radius — restore service first.
- Do not restart PostgreSQL without checking for in-flight transactions.
- Do not replay Stripe webhooks blindly — verify idempotency keys to avoid duplicate orders.
- Do not delete K8s resources to "fix" them — use rollout/rollback commands.
- Do not skip the post-mortem for P1 incidents, even if the fix was simple.
