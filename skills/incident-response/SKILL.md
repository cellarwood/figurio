---
name: Incident Response
description: Incident response playbook for Figurio's production infrastructure
---

# Incident Response

## Severity Levels

| Level | Description | Response Time | Example |
|-------|------------|---------------|---------|
| P1 | Service down, orders not processing | Immediate | API crash, Stripe webhook failing |
| P2 | Degraded service, partial functionality | < 1 hour | Slow 3D viewer, search broken |
| P3 | Minor issue, workaround available | < 1 day | Styling bug, non-critical API error |

## Incident Workflow

### 1. Detect
- Monitoring alert (Prometheus/Grafana)
- Error spike in Sentry
- Customer report via support
- CI/CD failure on main branch

### 2. Assess
```bash
# Quick health check
kubectl -n figurio-prod get pods
kubectl -n figurio-prod logs deploy/figurio-api --tail=50
kubectl -n figurio-prod top pods
```

### 3. Mitigate
- **If caused by recent deploy:** Rollback immediately (see Deployment Runbook)
- **If caused by external service (Stripe, 3D API):** Enable degraded mode, show user-friendly error
- **If caused by database:** Check connections, disk space, slow queries
- **If caused by traffic spike:** Scale pods: `kubectl -n figurio-prod scale deploy/figurio-api --replicas=3`

### 4. Communicate
- Update #alerts Slack channel with status
- If customer-facing: post status update (if status page exists)
- Notify CEO if P1 and lasting > 30 minutes

### 5. Resolve
- Fix root cause (not just symptoms)
- Verify fix in dev, then staging, then prod
- Confirm monitoring shows healthy metrics

### 6. Post-Incident
- Write incident report within 24 hours:
  - Timeline (detect → mitigate → resolve)
  - Root cause
  - Impact (orders affected, downtime duration)
  - Action items to prevent recurrence
- Share in #engineering

## Common Scenarios

| Scenario | First Action |
|----------|-------------|
| API pods CrashLoopBackOff | Check logs for startup error, rollback if recent deploy |
| Database connection errors | Check PG pod health, connection pool exhaustion |
| Stripe webhooks failing | Check webhook endpoint logs, verify secret key |
| 3D generation API timeout | Check external API status page, enable queue retry |
| High memory usage | Check for memory leaks in API, scale pods short-term |
