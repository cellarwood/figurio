---
name: incident-response
description: >
  Incident response playbook for Figurio — severity classification for
  payment failures, site down, and stuck orders; escalation paths to the CTO;
  Sentry alert handling procedures; and a post-mortem template.
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
      - incident-response
---

# Incident Response Playbook

## Severity Levels

| Level | Definition | Response SLA |
|-------|------------|-------------|
| SEV-1 | Platform is down or payments are completely broken | Immediate — drop everything |
| SEV-2 | Major feature degraded (e.g., orders stuck, image gen failing) | Within 15 minutes |
| SEV-3 | Non-critical degradation (e.g., slow responses, single-user error) | Within 2 hours |

When in doubt, **classify higher and downgrade** — it is better to over-respond
than to let an SEV-1 drift for 30 minutes.

---

## Severity Classification Guide

### SEV-1 — Immediate Response

- `https://figurio.cz` returns 5xx or is unreachable
- Stripe webhook endpoint (`/api/webhooks/stripe`) is failing — payments not
  being processed or Stripe events not received
- PostgreSQL pod is down or in CrashLoopBackOff
- Traefik ingress is not routing — TLS cert expired or IngressRoute broken
- CI/CD pipeline is deploying a broken image and site is degraded

### SEV-2 — Respond Within 15 Minutes

- Order status stuck in `pending` for >10 minutes after payment confirmation
- AI figurine generation jobs failing for all users (Meshy/Tripo3D errors,
  backend worker crash)
- Stripe webhooks delayed (events not processed, orders not transitioning state)
- Backend pod restarting repeatedly but service still partially available
- GitHub Actions deploy pipeline broken — no new deploys possible

### SEV-3 — Respond Within 2 Hours

- Single user reporting an order issue that is not reproduced broadly
- Elevated error rate in Sentry (spike, not sustained)
- Slow response times (p95 > 2s) but not complete failure
- A non-critical background job (e.g., backup CronJob) failing

---

## Escalation Paths

| Condition | Escalate to | Channel |
|-----------|-------------|---------|
| SEV-1 any duration | CTO immediately | Slack `#ops` + direct message |
| SEV-2 unresolved after 30 min | CTO | Slack `#ops` |
| Payment processing down | CTO + CEO | Slack `#ops` + direct message |
| Data loss or potential data breach | CTO + CEO immediately | Direct message only |

Post in `#ops` for all SEV-1 and SEV-2 incidents. Use plain declarative
statements: "PostgreSQL pod is in CrashLoopBackOff. Root cause: PVC at 98%
capacity. Expanding volume now. ETA 5 minutes."

Never leave an active SEV-1 or SEV-2 without a named owner.

---

## Sentry Alert Handling

Figurio uses Sentry for error observability on both frontend and backend.

### Triage Steps

1. Open the Sentry issue — read the full stack trace, not just the title.
2. Check the "first seen" vs "last seen" timestamps. A spike in an old issue
   differs from a brand-new error class.
3. Check the Sentry `environment` tag — confirm it is `production`, not `dev`.
4. Check "affected users" count. One user != SEV-1.
5. Cross-reference with recent deploys: did the error first appear after the
   last `main` merge?

### Common Sentry Alert Patterns

| Alert Pattern | Likely Cause | First Action |
|---------------|--------------|--------------|
| `stripe.error.SignatureVerificationError` | Webhook secret mismatch or Stripe replay | Check `STRIPE_WEBHOOK_SECRET` in K8s Secret; check Stripe dashboard for failed deliveries |
| `sqlalchemy.exc.OperationalError: connection refused` | PostgreSQL pod down or PVC full | `kubectl get pods -n figurio`; check PVC usage |
| `ConnectionError` to Meshy/Tripo3D API | External AI API outage or key expired | Check API status pages; verify API keys in K8s Secrets |
| `ImagePullBackOff` logged from cluster | Bad image tag pushed to Docker Hub | Check image exists: `docker pull lukekelle00/figurio-backend:<sha>` |
| Frontend JS `ChunkLoadError` | Stale cached frontend after deploy | Likely a cache/CDN issue; check if backend is serving new frontend hash |

### Alert Response Actions

For Sentry alerts that constitute a SEV-1 or SEV-2:
1. Acknowledge the alert in Sentry (assign to self).
2. Post status in `#ops` immediately.
3. Follow the relevant runbook steps (deployment-runbook for deploy issues,
   this file for service failures).
4. Update Sentry issue with findings as you go.
5. Resolve the Sentry issue only after confirming fix is deployed and error
   rate returns to baseline.

---

## Response Procedures by Incident Type

### Site Down (SEV-1)

```bash
# 1. Check pod status
kubectl get pods -n figurio

# 2. Check ingress
kubectl get ingressroute -n figurio
kubectl logs -n kube-system -l app=traefik --tail=50

# 3. Check recent events
kubectl get events -n figurio --sort-by='.lastTimestamp' | tail -20

# 4. If a pod is CrashLoopBackOff, get logs
kubectl logs <pod-name> -n figurio --previous
```

If the issue is a bad deploy: execute Helm rollback immediately (see
deployment-runbook).

If Traefik is the issue: restart Traefik pod and check certificate status.

### Payment Failures (SEV-1)

1. Check Stripe Dashboard → Webhooks → recent delivery attempts.
2. Check backend Sentry for `stripe` tagged errors.
3. Verify the `STRIPE_WEBHOOK_SECRET` and `STRIPE_SECRET_KEY` Kubernetes
   Secrets are present and correct:
   ```bash
   kubectl get secret figurio-backend-secrets -n figurio -o jsonpath='{.data}' | \
     python3 -c "import sys,json,base64; d=json.load(sys.stdin); print(list(d.keys()))"
   ```
4. Confirm the backend `/api/webhooks/stripe` route is reachable via Traefik.
5. If Stripe deliveries are failing with 5xx, the backend is likely down —
   follow the Site Down procedure.
6. If Stripe deliveries are returning 400 (signature error), rotate the webhook
   secret: update in Stripe Dashboard → update K8s Secret → redeploy backend.

### Orders Stuck (SEV-2)

An order is "stuck" when it remains in `pending` state for >10 minutes after
a successful Stripe payment.

1. Check Sentry for `order` or `webhook` tagged errors in the last 30 minutes.
2. Check Stripe webhook delivery log for the affected payment's `checkout.session.completed` event.
3. If the event was delivered but not processed, query PostgreSQL:
   ```bash
   kubectl exec -it <postgres-pod> -n figurio -- \
     psql -U figurio -c "SELECT id, status, stripe_session_id, created_at FROM orders ORDER BY created_at DESC LIMIT 10;"
   ```
4. If the order exists but status is wrong, identify whether it is a backend
   processing bug or a data integrity issue before any manual update.
5. Escalate to CTO if a manual DB fix is required — do not run `UPDATE` on
   orders without explicit authorization.

### PostgreSQL Down (SEV-1)

```bash
kubectl get pods -n figurio -l app=postgres
kubectl describe pod <postgres-pod> -n figurio
kubectl logs <postgres-pod> -n figurio --previous

# Check PVC capacity
kubectl get pvc -n figurio
kubectl describe pvc figurio-postgres-pvc -n figurio
```

Common causes:
- **PVC full** — expand the PVC or delete old WAL files; restart pod.
- **OOMKilled** — increase memory limits in Helm values; restart pod.
- **CrashLoopBackOff after deploy** — roll back Helm release.

Never delete the PostgreSQL PVC. Escalate to CTO before any destructive
database operation.

---

## Post-Mortem Template

Write a post-mortem for every SEV-1 and any SEV-2 that was unresolved for
more than 30 minutes. Post to `#ops` and file in the GitHub repository under
`docs/post-mortems/YYYY-MM-DD-<slug>.md`.

```markdown
## Post-Mortem: <Short Title>

**Date:** YYYY-MM-DD
**Severity:** SEV-1 / SEV-2
**Duration:** HH:MM (detection time to resolution time)
**Services affected:** frontend / backend / postgres / payments
**Author:** DevOps Engineer

### Summary

One paragraph. What broke, what the user impact was, how long it lasted.

### Timeline

| Time (UTC) | Event |
|------------|-------|
| HH:MM | First Sentry alert / user report |
| HH:MM | DevOps Engineer begins investigation |
| HH:MM | Root cause identified |
| HH:MM | Fix applied / rollback executed |
| HH:MM | Service confirmed healthy |

### Root Cause

Specific technical explanation. No vague language.

### Contributing Factors

What conditions allowed this to happen (missing alert, untested code path, etc.)

### Resolution

Exact steps taken to restore service.

### Action Items

| Action | Owner | Due |
|--------|-------|-----|
| Add alert for X | DevOps Engineer | YYYY-MM-DD |
| Fix Y in code | Backend Engineer | YYYY-MM-DD |
```
