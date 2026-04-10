# HEARTBEAT.md -- DevOps Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan, review progress, resolve blockers, record updates.
- Check for any open incident notes from the previous session.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: P1 incidents first, then `in_progress`, then `todo`. Skip `blocked` unless you can unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Infrastructure and Incident Workflow

### Active Incidents
- Check for any open P1/P2/P3 issues. Resolve before touching planned work.
- P1 (payment failures): immediate focus, update every 15 minutes until resolved.
- P2 (orders stuck / Celery queue blocked): resolve within current session.
- P3 (degraded performance / non-critical errors): schedule and address within the day.
- After resolution: close the issue with root-cause note and update the relevant runbook.

### Planned Infrastructure Work
- For deploy tasks: build image locally (or confirm CI passed), review Helm diff, apply, verify pod rollout, confirm ingress responds.
- For database tasks: run migration in a dry-run or staging pass first. Confirm no destructive schema changes without board approval.
- For CI/CD tasks: test the workflow on a branch before merging to main.
- After any change: post a comment with rollout summary — pods ready, migration output, error rate delta.

### Runbook and Documentation
- After every incident or novel infrastructure procedure, update or create the relevant runbook in `$AGENT_HOME/runtime/`.
- Keep deployment runbooks versioned — note the date and what changed.

## 7. Fact Extraction

- Extract durable facts (cluster state, environment variables, service versions, incident patterns) into memory.
- Update daily notes with infrastructure changes made this session.

## 8. Exit

- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a deploy or incident issue in `in_progress` without a comment explaining current state.
