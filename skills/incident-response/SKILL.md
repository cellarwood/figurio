---
name: incident-response
description: >
  Incident handling procedures for Figurio — severity classification for e-commerce
  and 3D printing operations, escalation paths, communication templates for customers
  and stakeholders, and postmortem format.
allowed-tools:
  - Read
  - Grep
  - Bash
metadata:
  paperclip:
    tags:
      - devops
      - incidents
      - operations
---

# Incident Response

Procedures for detecting, responding to, and learning from incidents affecting Figurio services.

## Severity Levels

### SEV-1 — Critical (respond immediately)

Production is down or revenue is blocked. All hands.

Examples:
- Checkout / Stripe payment flow completely broken
- Frontend unreachable (GKE ingress down, Traefik failure)
- FastAPI backend crash-looping in production
- Customer data at risk (security breach suspected)
- Zásilkovna order export failure causing shipping stoppage

Response time: **within 15 minutes**

### SEV-2 — High (respond within 1 hour)

Significant degradation — most users affected or key feature broken.

Examples:
- "Prompt to Print" AI pipeline returning errors for >50% of requests
- Product catalog returning stale data (cache invalidation failure)
- Order status emails not sending
- Sentry error rate spike >50% over baseline

Response time: **within 1 hour**

### SEV-3 — Medium (respond within 4 hours)

Partial degradation — subset of users or non-critical feature affected.

Examples:
- Single product category broken
- Admin panel inaccessible (non-customer-facing)
- Staging environment down
- Non-critical API endpoint returning 500s

Response time: **within 4 hours**

### SEV-4 — Low (respond next business day)

Minor issues, no user impact.

Examples:
- CI pipeline flaky (not blocking deploys)
- Non-critical Sentry noise
- Documentation or config drift

## Escalation Paths

```
SEV-1  →  DevOps on-call  →  CTO (if not resolved in 30 min)  →  CEO (if revenue impact >1hr)
SEV-2  →  DevOps on-call  →  CTO (if not resolved in 2hr)
SEV-3  →  DevOps engineer (async)
SEV-4  →  Backlog ticket
```

For payment incidents (Stripe), also contact the backend engineer immediately — payment logic lives in the FastAPI service.

For shipping incidents (Zásilkovna), loop in the COO — they have the vendor contact.

## Incident Response Steps

### 1. Detect and declare

- Sentry alert, user report, or monitoring alert fires
- Assign a severity level
- Post in `#incidents` (Slack/Discord): "Incident declared: [SEV-X] — [one-line description] — investigating"

### 2. Investigate

Check in this order:

```bash
# Pod health
kubectl get pods -n figurio
kubectl describe pod <crashing-pod> -n figurio

# Recent logs
kubectl logs -n figurio deploy/figurio-backend --since=10m
kubectl logs -n figurio deploy/figurio-frontend --since=10m

# Sentry — check the error and stack trace for the incident
# GKE events
kubectl get events -n figurio --sort-by='.lastTimestamp' | tail -20

# Traefik ingress
kubectl logs -n kube-system deploy/traefik --since=10m
```

### 3. Contain

- If a bad deploy caused it: **rollback immediately** (see deployment-runbook skill)
- If a dependency is failing (Stripe, Zásilkovna): activate the relevant maintenance page via Traefik middleware
- If data is at risk: isolate the affected service — scale to 0 replicas if necessary

```bash
kubectl scale deployment/figurio-backend --replicas=0 -n figurio
```

### 4. Communicate

Send updates every 30 minutes for SEV-1, every hour for SEV-2, until resolved.

**Customer-facing status page update template:**
```
[Time] We are currently experiencing issues with [feature].
Our team is investigating. Orders placed during this time will be processed normally
once the issue is resolved. We will update this page every 30 minutes.
```

**Internal update template (Slack #incidents):**
```
[Time] SEV-X Update
Status: Investigating / Identified / Mitigating / Resolved
Impact: [what is broken, how many users]
Cause: [hypothesis or confirmed root cause]
Next action: [what is happening now]
ETA: [estimate or "unknown"]
```

### 5. Resolve

- Confirm all health checks pass (see deployment-runbook)
- Confirm Sentry error rate returns to baseline
- Post resolution message in `#incidents`:
  ```
  [Time] RESOLVED — SEV-X [description]
  Duration: Xh Xm | Root cause: [summary] | Fix: [summary]
  Postmortem: [link or "to follow within 48h"]
  ```

## Postmortem Format

Write a postmortem for every SEV-1 and SEV-2. Publish within 48 hours of resolution in the team wiki.

```markdown
# Postmortem: [Incident Title]
Date: YYYY-MM-DD
Severity: SEV-X
Duration: Xh Xm
Author: [name]

## Summary
One paragraph. What happened, what was the impact, how was it resolved.

## Timeline (UTC)
- HH:MM — First alert / user report
- HH:MM — Incident declared
- HH:MM — Root cause identified
- HH:MM — Fix applied
- HH:MM — Resolved and verified

## Root Cause
Technical description of why the failure occurred.

## Impact
- Users affected: [estimate]
- Orders affected: [count or "none"]
- Revenue impact: [estimate or "none"]

## What Went Well
- [item]

## What Went Wrong
- [item]

## Action Items
| Action | Owner | Due |
|--------|-------|-----|
| [item] | [name] | [date] |
```

## Runbooks for Common Scenarios

### Stripe webhook failures

1. Check `kubectl logs -n figurio deploy/figurio-backend | grep stripe`
2. Verify the Stripe webhook secret in the Kubernetes secret: `kubectl get secret figurio-backend-secrets -n figurio -o yaml`
3. Check Stripe dashboard for webhook delivery failures
4. Re-enable failed webhooks from Stripe dashboard if needed

### Zásilkovna order export stuck

1. Check the export job logs in the backend service
2. Verify Zásilkovna API credentials have not expired
3. Contact COO to notify Zásilkovna if orders are delayed >2 hours

### GKE node out of resources

```bash
kubectl describe nodes | grep -A5 "Allocated resources"
kubectl top nodes
# If a node is at capacity, check for resource leaks:
kubectl top pods -n figurio --sort-by=memory
```

Scale up the node pool via Terraform if sustained load requires it — do not do this manually through GCP console.
