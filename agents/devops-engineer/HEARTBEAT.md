# HEARTBEAT.md -- DevOps Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, and chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.
- If woken by a mention or alert, read the triggering comment in full before proceeding.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan and any carry-over items.
- Review open blockers noted in previous sessions.
- Record any new context or decisions at the top of today's note.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- read the approval and linked issues.
- Close resolved issues or comment clearly on what remains open.
- If a deploy approval was granted, proceed to the deployment runbook steps.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: active incidents first, then `in_progress`, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Infrastructure and Deployment Workflow

### Active Incident
- If an incident is open, follow `$AGENT_HOME/SOUL.md` principles: contain first, diagnose second, communicate always.
- Triage: identify blast radius, check Traefik logs, pod status (`kubectl get pods -A`), and recent deployments.
- Mitigation options in order: rollback deployment, scale down faulty pod, redirect traffic via Traefik middleware.
- Comment on the incident issue after every material action. Never go silent during an active incident.
- Open a postmortem issue before closing the incident.

### Deployment Work
- Follow the deployment runbook (`deployment-runbook` skill) for every deploy — no ad-hoc pushes.
- Sequence: build Docker image (multi-stage) → tag with git SHA and semver → push to `lukekelle00` on Docker Hub → apply Helm chart update → verify rollout → update runbook if procedure changed.
- Validate Traefik ingress routing and TLS certificate validity after any ingress change.
- Confirm Sentry is receiving events from the newly deployed version before marking a deploy complete.

### CI/CD Maintenance
- Review any failed GitHub Actions runs in `cellarwood/figurio`.
- Fix flaky steps, update pinned action versions, and document pipeline changes in the issue.

### Cluster Health Check (on every heartbeat unless actively blocked on higher priority)
- Verify all pods are `Running` or `Completed` — investigate any `CrashLoopBackOff` or `Pending`.
- Check resource utilization; flag if any namespace is approaching limits.
- Verify TLS certificate expiry is not within 14 days.
- Confirm Sentry integrations are active for both frontend and backend.

## 7. Fact Extraction

- Extract durable facts (new infra decisions, runbook changes, Helm chart versions, credential rotation events) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with end-of-session status.

## 8. Exit

- Comment on any `in_progress` issue before exiting with a status line, what was done, and what remains.
- If leaving a deploy mid-flight, clearly document the exact next step so the work can be resumed safely.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- No silent failures — every error gets a comment and a follow-up action.
- Production changes require a checkout; never mutate production without an associated issue.
