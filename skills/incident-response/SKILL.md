---
name: incident-response
description: >
  Incident handling for Figurio — severity classification (P1: checkout/Stripe
  down, P2: AI custom figurine pipeline degraded, P3: cosmetic issues),
  escalation paths, communication templates, and postmortem format.
allowed-tools:
  - Read
  - Grep
  - Bash
metadata:
  paperclip:
    tags:
      - engineering
      - devops
      - operations
---

# Incident Response

Structured process for detecting, triaging, resolving, and reviewing incidents
affecting Figurio's production services.

## Severity Levels

### P1 — Critical (respond immediately)

The business is losing revenue or customer trust cannot be restored without
urgent action.

Examples:
- Stripe checkout flow is returning errors or is unreachable
- `api.figurio.cz` is down (5xx or no response)
- `figurio.cz` frontend is inaccessible
- Customer payment data may be at risk

Target response: acknowledge within **5 minutes**, start remediation within
**15 minutes**.

### P2 — High (respond within 30 minutes)

Core service is degraded but a workaround or partial functionality exists.

Examples:
- AI custom figurine pipeline (`ai.figurio.cz`) is down or returning errors
  (catalog orders still work)
- Order confirmation emails are delayed or failing
- Elevated error rate (>2% of requests) in Sentry without full outage
- Slow response times (p95 > 5s) for checkout or catalog endpoints

Target response: acknowledge within **15 minutes**, start remediation within
**30 minutes**.

### P3 — Low (respond within 2 business hours)

Cosmetic or non-blocking issues that do not affect revenue or order processing.

Examples:
- UI rendering glitch on a non-critical page
- Broken image in the catalog for a single product
- Minor copy errors on static pages
- Non-critical Sentry noise below error budget threshold

Target response: triage within **2 hours**, fix in next sprint unless trivial.

## Detection Sources

- **Sentry** — primary error alerting; P1 triggers page immediately
- **Kubernetes pod health** — `CrashLoopBackOff` or OOMKilled pods
- **Traefik** — 5xx response rate spike visible in logs
- **Stripe Dashboard** — webhook delivery failures or payment decline spike
- **Customer report** — escalated via support email to devops-engineer

## Escalation Path

| Severity | On-call DevOps | CTO | CEO |
|----------|---------------|-----|-----|
| P1 | Immediate page | Notify within 15 min | Notify if >30 min unresolved |
| P2 | Immediate page | Notify if >1 hour unresolved | Not required |
| P3 | Normal queue | Not required | Not required |

For P1 Stripe issues, also notify the backend-engineer — they own the Stripe
integration code.

For P1 data-risk incidents, CTO and CEO are notified immediately regardless of
resolution time.

## Response Steps

### 1. Acknowledge

Claim the incident so the team knows someone is on it. Post in the engineering
channel:

```
[INCIDENT P<N>] <short description> — acknowledged, investigating
```

### 2. Assess

```bash
# Check pod state
microk8s kubectl get pods -n figurio

# Check recent events
microk8s kubectl get events -n figurio --sort-by='.lastTimestamp' | tail -20

# Check Traefik logs for 5xx spike
microk8s kubectl logs -n kube-system -l app=traefik --tail=100 | grep " 5[0-9][0-9] "

# Check Sentry for top errors
# (open Sentry dashboard — filter to last 30 min)
```

### 3. Mitigate

Prefer the fastest path to restoring service over the cleanest fix:

- **Pod crash / bad deploy** → roll back via Helm (see deployment-runbook skill)
- **Stripe webhook failure** → check secret rotation, restart backend deployment
- **AI pipeline down** → restart `ai-pipeline` deployment; catalog orders
  continue to function — communicate P2 status to customers if >15 min
- **Infrastructure issue** → check microk8s node health, Traefik pod, PVC
  mounts

### 4. Resolve

Confirm resolution:

```bash
microk8s kubectl rollout status deployment/<service> -n figurio
curl -sf https://api.figurio.cz/health | jq .status   # "ok"
curl -sf https://figurio.cz/                           # HTTP 200
```

Post resolution message in engineering channel:

```
[RESOLVED P<N>] <short description> — resolved at <HH:MM UTC>.
Duration: <X> min. Root cause: <one sentence>. Postmortem: <yes/no — schedule if P1 or P2>
```

## Communication Templates

### Customer-facing status update (P1 — checkout down)

> We are currently experiencing an issue with our checkout process. Our team is
> actively investigating and working to restore service. We apologize for the
> inconvenience. Orders placed before this notice have been received. We will
> update this page as soon as the issue is resolved.

### Customer-facing status update (P2 — AI pipeline degraded)

> Our AI custom figurine tool is currently unavailable. Standard catalog orders
> are processing normally. Our team is working to restore the AI feature. We
> will update here shortly.

### Internal escalation message (P1 to CTO)

> P1 INCIDENT: <service> is down as of <HH:MM UTC>. Impact: <revenue-affecting
> description>. DevOps investigating. ETA unknown — looping you in per P1
> protocol.

## Postmortem Format

Required for all P1 incidents. Recommended for P2 incidents lasting >1 hour.

```
## Postmortem — <Incident Title>

**Date:** YYYY-MM-DD
**Duration:** X hours Y minutes
**Severity:** P1 / P2
**Author:** <devops-engineer or CTO>

### Summary
One paragraph describing what happened and the customer impact.

### Timeline (UTC)
- HH:MM — first alert / detection
- HH:MM — incident acknowledged
- HH:MM — root cause identified
- HH:MM — mitigation applied
- HH:MM — service restored

### Root Cause
Technical explanation of what failed and why.

### Contributing Factors
Conditions that made the incident worse or detection slower.

### Resolution
What was done to restore service.

### Action Items
| Action | Owner | Due |
|--------|-------|-----|
| <preventive fix> | <engineer> | <date> |
| <monitoring improvement> | <engineer> | <date> |
```

Postmortems are blameless. Focus on process and system improvements.
File them in the shared engineering folder within 48 hours of resolution.
