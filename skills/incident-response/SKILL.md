---
name: incident-response
description: >
  Incident response playbook for Figurio: severity classification (P0-P3),
  escalation paths from DevOps through CTO to CEO, communication templates
  for internal and customer-facing updates, and postmortem format.
allowed-tools:
  - Bash
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - devops
      - incident
      - operations
---

# Incident Response Playbook

## When to Use

Use this playbook whenever a Figurio service degrades, goes down, or behaves
unexpectedly in a way that affects customers, orders, or the 3D pipeline.
Covers detection through resolution and postmortem.

---

## 1. Severity Levels

| Level | Name | Definition | Response Time |
|-------|------|------------|---------------|
| P0 | Critical | Full storefront down, checkout broken, all orders blocked | Immediate — 24/7 |
| P1 | High | Partial outage (e.g. ML pipeline failed, payment errors for subset of users) | Within 30 min |
| P2 | Medium | Degraded performance, non-blocking errors, admin tools down | Within 2 hours |
| P3 | Low | Cosmetic issues, minor bugs, monitoring alerts without customer impact | Next business day |

**P0 examples:** `figurio.cz` unreachable, Stripe webhook endpoint returning 500,
K8s cluster fully unavailable.

**P1 examples:** AI pipeline producing invalid 3D models, order status not updating
in DB, Sentry error rate spike > 5% of requests.

**P2 examples:** Traefik returning intermittent 503s, slow API response times
(> 3s p95), Docker Hub push failing in CI.

**P3 examples:** Minor UI glitch on a single browser, non-critical alert in Sentry,
stale cache on a product page.

---

## 2. Escalation Path

```
DevOps Engineer
    │
    ├─ P2/P3 → Handle independently, notify CTO async
    │
    ├─ P1 → Notify CTO immediately (Slack/call), loop in relevant engineer
    │           (backend-engineer, ml-engineer) if domain-specific
    │
    └─ P0 → Notify CTO + CEO immediately, all hands
```

**Contacts:**
- CTO: primary technical escalation for P0/P1
- CEO: business impact decisions (customer comms, refunds, press) — P0 only
- Backend Engineer: API / DB issues
- ML Engineer: 3D pipeline issues
- Head of Operations: order fulfillment impact (inform, do not escalate to for technical issues)

For P0, escalation is synchronous (call, not message). For P1, async message
with a 10-minute acknowledgement expectation.

---

## 3. Response Steps

### Detect

- Sentry: monitor `cellarwood/figurio` project for error rate spikes
- K8s: `kubectl get pods -n figurio` for CrashLoopBackOff or Pending pods
- Traefik dashboard: check for unhealthy backends
- GitHub Actions: CI/CD failure emails

### Assess

1. Determine affected service and scope (how many users/orders impacted)
2. Assign a severity level (P0–P3)
3. Open an incident channel or thread (Slack `#incidents` or equivalent)

### Contain

```bash
# Check pod health
kubectl get pods -n figurio
kubectl describe pod <pod-name> -n figurio
kubectl logs <pod-name> -n figurio --previous

# Check recent deployments
helm history <service> -n figurio

# Rollback if a bad deploy caused the incident
helm rollback <service> <last-good-revision> -n figurio --wait
```

See `deployment-runbook` skill for full rollback steps.

### Resolve

- Apply fix or rollback
- Verify pod readiness: `kubectl rollout status deployment/<service> -n figurio`
- Confirm Sentry error rate returns to baseline
- Confirm Stripe webhooks healthy (check Stripe Dashboard → Webhooks)
- Mark incident resolved in incident thread

### Close

- Notify all escalated stakeholders that the incident is resolved
- Send customer-facing communication if P0/P1 (see templates below)
- Schedule postmortem within 48 hours for P0/P1

---

## 4. Communication Templates

### Internal (Slack / team thread)

**Incident open:**
```
[INCIDENT P{level}] {short description}
Time detected: {HH:MM CET}
Affected: {service/feature}
Customer impact: {yes/no — description}
IC (Incident Commander): {name/agent}
Status: Investigating
```

**Update (every 15 min for P0, 30 min for P1):**
```
[UPDATE] {HH:MM CET}
Status: {Investigating / Mitigating / Resolved}
Latest: {one sentence on what was found / done}
ETA to resolve: {estimate or "unknown"}
```

**Resolved:**
```
[RESOLVED] {HH:MM CET}
Duration: {X min}
Root cause (preliminary): {one sentence}
Postmortem: scheduled for {date}
```

### Customer-facing (P0/P1 only)

Post on `figurio.cz` status page or send to affected order emails:

```
We are currently experiencing issues with {checkout / order processing / our website}.
Our team is actively working on a fix. We apologize for the inconvenience.
Existing orders are safe and will be processed as soon as service is restored.
Updates will be posted here every 30 minutes.
— The Figurio Team
```

Resolution notice:
```
Service has been fully restored as of {HH:MM CET}.
All pending orders are being processed. Thank you for your patience.
— The Figurio Team
```

---

## 5. Postmortem Format

File postmortems at `docs/postmortems/YYYY-MM-DD-<slug>.md` within 48 hours of
a P0 or P1 incident.

```markdown
# Postmortem: <Short Title>

**Date:** YYYY-MM-DD
**Severity:** P{level}
**Duration:** X minutes
**Services affected:** figurio-api / figurio-frontend / ml-pipeline
**Author:** devops-engineer

## Summary

One paragraph: what happened, customer impact, how it was resolved.

## Timeline (CET)

- HH:MM — {event}
- HH:MM — {event}
- HH:MM — Incident resolved

## Root Cause

Technical explanation of why the incident occurred.

## Contributing Factors

- {factor 1}
- {factor 2}

## Resolution

What was done to restore service.

## Action Items

| Action | Owner | Due |
|--------|-------|-----|
| {fix / prevention measure} | {agent/role} | {date} |

## Lessons Learned

What we learned and how we prevent recurrence.
```

---

## Checklist

- [ ] Severity assigned within 5 minutes of detection
- [ ] CTO notified for P0/P1
- [ ] CEO notified for P0
- [ ] Incident thread opened
- [ ] Updates posted on cadence (15 min P0, 30 min P1)
- [ ] Customer communication sent if P0/P1
- [ ] Postmortem filed within 48 hours for P0/P1
- [ ] Action items tracked to completion
