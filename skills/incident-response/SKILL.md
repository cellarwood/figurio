---
name: incident-response
description: Incident response playbook for Figurio infrastructure — detection, triage, resolution, and post-mortem for the e-commerce platform on microk8s-local.
---

# Incident Response Playbook

## Purpose

Define how the Figurio team detects, triages, resolves, and learns from incidents on the e-commerce platform. Fast, structured response minimizes customer impact and revenue loss.

## Severity Levels

### P1 — Critical

**Definition**: Site is completely down, payments are broken, or customer data is at risk.

Examples:
- Storefront returns 5xx for all users.
- Stripe payment processing is failing (orders cannot be completed).
- Database is unreachable or corrupted.
- Security breach or data leak suspected.

**Response time**: Immediate (within 15 minutes).
**Resolution target**: 1 hour.
**Who is paged**: DevOps Engineer, CTO, CEO.

### P2 — Major Degradation

**Definition**: Core functionality is degraded but the site is partially usable.

Examples:
- 3D model viewer not loading (product pages work but no preview).
- Custom order AI generation pipeline is failing.
- Slow response times (>5 seconds for page loads).
- Shipping integration down (orders accepted but cannot generate labels).
- One product category returns errors.

**Response time**: Within 1 hour.
**Resolution target**: 4 hours.
**Who is paged**: DevOps Engineer, CTO.

### P3 — Minor Issue

**Definition**: Non-critical feature is broken, no immediate revenue impact.

Examples:
- Email notification delivery is delayed.
- Order tracking page shows stale data.
- Admin dashboard widget broken.
- Non-critical background job failing.

**Response time**: Within 4 hours.
**Resolution target**: Next business day.
**Who is paged**: DevOps Engineer.

## Detection

### Automated Monitoring

- **Uptime check**: HTTP probe to `/health` every 30 seconds.
- **Pod health**: Kubernetes liveness and readiness probes.
- **Error rate**: Alert when 5xx responses exceed 1% of traffic over 5 minutes.
- **Response time**: Alert when p95 latency exceeds 3 seconds.
- **Stripe webhooks**: Alert when webhook delivery failure rate exceeds 5%.
- **Disk usage**: Alert at 80% capacity (especially 3D model storage).
- **Pod restarts**: Alert when any pod restarts more than 3 times in 10 minutes.

### Manual Detection

- Customer complaint via email or social media.
- Team member notices issue during routine use.
- Stripe Dashboard shows failed payments.

## Triage Checklist

When an incident is detected, run through this checklist in order:

### 1. Confirm the Incident

```bash
# Check if the site is reachable
curl -s -o /dev/null -w "%{http_code}" https://figurio.cz/health

# Check pod status
microk8s kubectl -n figurio-prod get pods

# Check recent events
microk8s kubectl -n figurio-prod get events --sort-by='.lastTimestamp' | tail -20
```

### 2. Check Application Logs

```bash
# API logs (last 100 lines)
microk8s kubectl -n figurio-prod logs deploy/figurio-api --tail=100

# Web frontend logs
microk8s kubectl -n figurio-prod logs deploy/figurio-web --tail=100
```

### 3. Check Database

```bash
# Verify database connectivity
microk8s kubectl -n figurio-prod exec deploy/figurio-api -- \
  python -c "from app.db import engine; engine.connect(); print('DB OK')"

# Check active connections
microk8s kubectl -n figurio-prod exec deploy/figurio-db -- \
  psql -U figurio -c "SELECT count(*) FROM pg_stat_activity;"
```

### 4. Check External Dependencies

- **Stripe**: Check https://status.stripe.com/ for outages.
- **AI generation service**: Test API endpoint manually.
- **Docker Hub**: Check https://status.docker.com/ if image pulls fail.
- **MCAE**: Not real-time critical, but note if their API/portal is down.

### 5. Check Resource Usage

```bash
# Node resources
microk8s kubectl top nodes

# Pod resources
microk8s kubectl -n figurio-prod top pods
```

## Common Failure Modes

### Pod OOM (Out of Memory)

**Symptoms**: Pod restarts, `OOMKilled` in pod status.
**Cause**: Memory leak or insufficient resource limits.
**Fix**: Increase memory limit in Helm values, investigate leak.

```bash
microk8s kubectl -n figurio-prod describe pod ${POD_NAME} | grep -A5 "Last State"
```

### Database Connection Exhaustion

**Symptoms**: API returns 500 errors, logs show "too many connections."
**Cause**: Connection pool misconfigured or connection leak.
**Fix**: Restart API pods (short term), fix pool settings (long term).

```bash
microk8s kubectl -n figurio-prod rollout restart deploy/figurio-api
```

### Stripe Webhook Failures

**Symptoms**: Orders stuck in "pending" status, Stripe Dashboard shows failed deliveries.
**Cause**: Webhook endpoint down, signature verification failing, or timeout.
**Fix**: Check API logs for webhook handler errors. Resend failed events from Stripe Dashboard.

### 3D Model Storage Full

**Symptoms**: Custom order generation fails, upload errors in logs.
**Cause**: Orphaned files from failed/cancelled orders accumulating.
**Fix**: Run cleanup job, increase volume size if needed.

```bash
# Check disk usage
microk8s kubectl -n figurio-prod exec deploy/figurio-api -- df -h /data/models
```

### Certificate Expiry

**Symptoms**: Browser shows SSL warning, API calls fail with TLS errors.
**Cause**: Let's Encrypt certificate not auto-renewed.
**Fix**: Force certificate renewal, check cert-manager logs.

## Resolution Steps

1. **Identify** the root cause using the triage checklist.
2. **Communicate** severity and ETA to the team.
3. **Fix or mitigate**: Apply the fix, or if the fix requires time, apply a mitigation (e.g., rollback, feature flag off, redirect to maintenance page).
4. **Verify**: Run post-deploy verification from the deployment runbook.
5. **Monitor**: Watch logs and metrics for 30 minutes after resolution.
6. **Communicate**: Confirm resolution to the team and affected customers.

## Post-Mortem Template

Every P1 and P2 incident requires a post-mortem within 48 hours:

```markdown
# Post-Mortem: {Incident Title}

**Date**: YYYY-MM-DD
**Severity**: P1 / P2
**Duration**: HH:MM (detection to resolution)
**Impact**: What customers experienced and for how long.

## Timeline
- HH:MM — Incident detected by [method].
- HH:MM — Triage started by [person/agent].
- HH:MM — Root cause identified.
- HH:MM — Fix deployed.
- HH:MM — Incident resolved, monitoring stable.

## Root Cause
What broke and why.

## Resolution
What was done to fix it.

## Lessons Learned
- What went well.
- What went poorly.
- Where we got lucky.

## Action Items
- [ ] Action 1 — Owner — Due date.
- [ ] Action 2 — Owner — Due date.
```

## Communication During Incidents

- P1: Notify CEO and CTO immediately. Post status update on site if outage exceeds 15 minutes.
- P2: Notify CTO. Update team in Slack.
- P3: Log in issue tracker. No immediate notification needed.
- Customer-facing communication: honest, brief, no technical jargon. "We're experiencing issues with [feature]. Our team is on it. We expect to resolve this within [timeframe]."
