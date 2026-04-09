---
name: incident-response
description: >
  Incident response playbook for the Figurio platform —
  severity classification, triage procedures, communication templates,
  and post-incident review process.
---

# Incident Response

## Severity Levels

| Severity | Definition | Response Time | Example |
|----------|-----------|---------------|---------|
| P1 - Critical | Storefront down, payments failing, data loss | Immediate | 503 errors on all pages, Stripe webhooks failing |
| P2 - Major | Degraded functionality, partial outage | < 1 hour | 3D viewer broken, search not working, slow checkout |
| P3 - Minor | Cosmetic issues, non-critical feature broken | < 24 hours | Styling bug, analytics not tracking, minor UI glitch |

## Triage Procedure

1. **Assess impact**: How many customers affected? Is money involved (payments, refunds)?
2. **Classify severity**: Use the table above
3. **Communicate**: Notify CTO immediately for P1/P2
4. **Investigate**: Check pod logs, Traefik access logs, Stripe dashboard
5. **Fix or mitigate**: Apply fix if quick, rollback if not, enable maintenance mode if critical
6. **Verify**: Confirm the fix with health checks and a test order flow
7. **Document**: Write a brief incident report

## Communication Template

```
**Incident: {title}**
Severity: P{n}
Status: Investigating / Mitigating / Resolved
Impact: {who is affected and how}
Cause: {root cause or "under investigation"}
Action: {what we're doing about it}
ETA: {when we expect resolution}
```

## Post-Incident Review

After every P1/P2 incident:
- What happened?
- What was the root cause?
- How did we detect it?
- How long was the impact?
- What will prevent recurrence?
