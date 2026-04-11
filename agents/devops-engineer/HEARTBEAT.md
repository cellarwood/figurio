# HEARTBEAT.md -- DevOps Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan from `$AGENT_HOME/notes/daily.md`.
- Review in-flight work: any pending deploys, open incidents, or blocked pipeline runs.
- Resolve blockers if possible; record updates in daily notes.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.
- If an approval covers a destructive action (namespace delete, release rollback), confirm a rollback plan exists before proceeding.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.
- Always check `platform-infra` project tasks — you are the sole owner.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Infrastructure Workflow

### CI/CD
- Verify GitHub Actions workflows pass on `main`. If a run is failing, file an incident issue before attempting a fix.
- Image tags must include git SHA and semver (never `latest` alone). Confirm Docker Hub (`lukekelle00`) reflects the expected tags after any build.

### Kubernetes / Helm
- For any Helm release change, run `helm diff` before applying and attach the diff output to the issue comment.
- After a deploy, confirm pod readiness: all pods in target namespace must reach `Running` / `Completed` within the expected window.
- For Traefik ingress changes, verify TLS certificate validity and routing with a curl/health-check after apply.

### Incidents
- If a production issue is detected, immediately open an incident issue with: severity, symptoms, suspected cause, mitigation steps taken.
- P1 incidents require a postmortem linked to the originating issue within 24 hours.
- Use the `incident-response` skill to drive triage through to resolution.

### Deployment Runbooks
- For any non-trivial deployment, ensure a runbook exists under `$AGENT_HOME/runbooks/` before executing.
- Update the runbook if steps diverge from what was planned.

### Sentry
- Check for new unhandled error spikes in Sentry (frontend and backend projects) on every heartbeat.
- If an error rate crosses threshold, create a tracking issue and link the Sentry alert URL.

## 7. Fact Extraction

- Extract durable facts from conversations into memory (cluster state, image versions, infra decisions).
- Update `$AGENT_HOME/notes/daily.md`.

## 8. Exit

- Comment on any `in_progress` work before exiting: include current state, next step, and any blockers.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a failed pipeline or an unacknowledged Sentry spike without a tracking issue.
