---
name: incident-response
description: Incident response procedures for Figurio infrastructure — detection, triage, mitigation, resolution, and post-incident review
---

# Incident Response

## Severity Levels

| Level | Definition | Response Time | Example |
|-------|-----------|---------------|---------|
| **P1** | Service down, customers can't order | Immediate | Storefront unreachable, Stripe payments failing |
| **P2** | Major feature broken, workaround exists | 1 hour | AI pipeline stuck, order tracking not updating |
| **P3** | Minor feature broken, low impact | 4 hours | Image loading slow, search results inaccurate |
| **P4** | Cosmetic or non-urgent | Next business day | Styling bug, log noise |

## Incident Flow

### 1. Detect
- Health check alerts (K8s liveness/readiness probes)
- Error rate spike in application logs
- Customer report via support channel
- Stripe webhook failures

### 2. Triage
- Confirm the issue is real (not a monitoring false positive)
- Determine severity level
- Identify affected service (frontend, backend, database, infrastructure)
- Check: is this a deploy-related regression? (`kubectl rollout history`)

### 3. Mitigate
- **P1:** Rollback immediately if deploy-related. Redirect traffic if infrastructure.
- **P2:** Attempt quick fix. If not obvious in 15 minutes, rollback.
- **P3/P4:** Fix in normal workflow, no emergency action.

### 4. Resolve
- Apply fix and verify through normal deployment process
- Confirm health checks pass
- Monitor for 30 minutes after fix

### 5. Post-Incident
- Write incident report within 24 hours:
  ```
  ## Incident: {Title}
  **Severity:** P{N}
  **Duration:** {start} to {end}
  **Impact:** {what customers experienced}
  **Root cause:** {why it happened}
  **Fix:** {what was done}
  **Prevention:** {what changes prevent recurrence}
  ```

## Key Contacts

- **Infrastructure:** DevOps Engineer (primary)
- **Backend/API:** Backend Engineer
- **Frontend/UI:** Frontend Engineer
- **Payments:** Backend Engineer (Stripe) + Head of Operations
- **Escalation:** CTO → CEO

## Common Scenarios

| Scenario | First Action |
|----------|-------------|
| Pod CrashLoopBackOff | Check logs: `kubectl logs --previous` |
| Database connection refused | Check PG pod status, connection pool exhaustion |
| Stripe webhook 500s | Check webhook handler logs, verify secret |
| SSL certificate expired | Renew via Traefik / cert-manager |
| Disk full | Identify large files, clean up, expand PV if needed |
