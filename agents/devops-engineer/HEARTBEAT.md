# HEARTBEAT.md -- DevOps Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.
- If `PAPERCLIP_WAKE_REASON` is `mention`, locate the comment that triggered the wake and read it fully before doing anything else.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's date entry.
- Review any in-flight work: open deploys, pending rollouts, active incidents, scheduled maintenance.
- If an incident is open, skip to step 6 immediately.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- review what was approved and the linked issue.
- If the approval gates a deploy, execute the deploy now and update the issue with the result.
- Close resolved issues or comment on what still blocks closure.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Touch `blocked` only if you can immediately unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, treat it as highest priority.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else right now.
- Work the task. When done, update status to `done` and post a completion comment.

## 6. Infrastructure and Deploy Workflow

### Active Incident
- If an incident is active, all other work pauses.
- Assess impact: which service, which users, what is the blast radius.
- Decide: roll forward with a fix or roll back to last known good image.
- Default to **rollback** if the root cause is unknown.
- Execute: `kubectl rollout undo deployment/{name} -n {namespace}` or `helm rollback {release}`.
- Post a status update to the incident issue every 15 minutes until resolved.
- Write a post-mortem comment when closed: timeline, root cause, remediation, prevention.

### Routine Deploy
- Verify the GitHub Actions workflow completed successfully for the target commit.
- Check image exists in Docker Hub: `lukekelle00/{service}:{tag}`.
- Apply via Helm: `helm upgrade --install {release} ./charts/{chart} -f values/{env}.yaml --set image.tag={tag}`.
- Monitor rollout: `kubectl rollout status deployment/{name} -n {namespace}`.
- Confirm Sentry shows no new error spike in the 5 minutes post-deploy.
- Comment on the issue with: deploy tag, rollout status, Sentry check result.

### CI/CD Pipeline Health
- Spot-check recent GitHub Actions runs for failures or unusual durations.
- If a workflow is consistently failing on a step unrelated to application code, investigate and fix the workflow file.

### Cluster Health Check (when no active incident or deploy)
- `kubectl get nodes` -- confirm all nodes are Ready.
- `kubectl get pods -A | grep -v Running | grep -v Completed` -- flag any CrashLoopBackOff or Pending pods.
- Check PVC health: `kubectl get pvc -A` -- all should be Bound.
- Review resource pressure: `kubectl top nodes` and `kubectl top pods -A`.
- Confirm PostgreSQL backup CronJob last run succeeded: `kubectl get jobs -n {db-namespace}`.

### Traefik and SSL
- If any TLS certificate is within 14 days of expiry, trigger renewal or investigate cert-manager.
- Verify IngressRoute entries match currently deployed services.

## 7. Fact Extraction

- Extract durable facts from this session: new config values, decisions made, runbook changes, lessons from incidents.
- Append to `$AGENT_HOME/notes/daily.md` under today's date.
- Update relevant runbook files in `$AGENT_HOME/runbooks/` if procedures changed.

## 8. Exit

- Comment on any `in_progress` issue before exiting, even if work is not complete.
- Record what is left to do and any context the next run needs.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a cluster in a degraded state without an open issue tracking it.
- Secrets are never logged, printed, or included in comments.
