---
name: incident-response
description: Incident response playbook for the Figurio platform
---

# Incident Response

## Severity Levels

| Level | Description | Examples | Response Time |
|-------|-------------|----------|---------------|
| **P1** | Service down, orders failing | API unreachable, Stripe webhooks failing, DB down | Immediate |
| **P2** | Degraded, some features broken | AI pipeline failing, slow responses, partial outage | Within 1 hour |
| **P3** | Minor issue, workaround exists | UI glitch, non-critical API error, monitoring gap | Within 1 day |

## Response Procedure

### 1. Detect
- Grafana alert fires, Sentry error spike, or manual report
- Confirm the issue is real (not a false alarm)

### 2. Communicate
- Post in #alerts Slack channel: "Investigating [brief description]"
- For P1: notify CEO and CTO immediately

### 3. Mitigate
- **First priority: restore service**, not find root cause
- Rollback if deployment-related: `helm rollback`
- Scale up if load-related: `kubectl scale deployment`
- If DB issue: check connections, restart if needed

### 4. Diagnose
- Check logs: `kubectl logs -n figurio-prod deployment/figurio-api`
- Check metrics: Grafana dashboards for the affected time window
- Check recent changes: `git log --oneline -10`

### 5. Resolve
- Apply fix
- Verify fix in dev/staging before production
- Deploy to production

### 6. Post-Mortem
- Only for P1 and P2 incidents
- Format:

```markdown
## Incident: [title]
**Date:** [date]
**Duration:** [start - end]
**Severity:** P1/P2
**Impact:** [what customers experienced]

### Timeline
- HH:MM — [event]

### Root Cause
[What actually caused the issue]

### Resolution
[What fixed it]

### Action Items
- [ ] [preventive measure] — owner: [agent]
```
