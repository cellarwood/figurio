# HEARTBEAT.md -- DevOps Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.
- If woken by an incident mention, treat this as P1 — skip to Step 5 immediately.

## 2. Local Planning Check

- Read today's plan at `$AGENT_HOME/notes/daily.md`.
- Review in-progress infrastructure changes and confirm they completed cleanly.
- Note any pipelines currently red, pods not ready, or secrets nearing rotation.
- Record plan updates before proceeding.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.
- If the approval concerns a destructive operation (PV deletion, DB drop, namespace removal), confirm board authorization is explicit before acting.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first (finish what you started), then `todo` by priority label.
- Skip `blocked` unless you can directly unblock it this session.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- For incident tasks: diagnose first, document findings in a comment, then remediate.
- For deployment tasks: confirm image tag, run pipeline or apply Helm chart, verify pod health.
- Update issue status and leave a comment with evidence when done.

## 6. Infrastructure and CI/CD Workflow

### Pipeline failures
- Identify the failing step (build, test, push, deploy) from the Actions run log.
- Fix the root cause — do not just re-run flaky pipelines without investigation.
- Comment with the run URL and the fix applied.

### Deployment tasks
- Confirm the Docker image is published to `lukekelle00` with the correct tag.
- Apply the Helm chart or trigger the deployment Action.
- Verify pods reach `Running` state and pass readiness probes.
- Check Traefik routing returns a healthy response on the expected endpoint.
- Leave pod status and endpoint evidence in the issue comment.

### Secret management
- When rotating secrets, update Kubernetes secrets and restart affected deployments atomically.
- Never log secret values in comments or issue bodies.

### Incident response
- Assess blast radius: which services and customers are affected?
- Check Sentry for error spikes and the microk8s cluster for unhealthy pods.
- Roll back if the cause is a recent deployment: `helm rollback <release> <revision>`.
- Comment with incident timeline, root cause, and remediation steps.
- File a follow-up issue for any permanent fix needed after the hotfix.

### Runbook and playbook updates
- After any novel incident or deployment pattern, update or create a runbook in `$AGENT_HOME/runbooks/`.
- Cross-reference the runbook from the issue comment.

## 7. Fact Extraction

- Extract durable facts (new secrets locations, cluster quirks, pipeline gotchas) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with session summary.

## 8. Exit

- Comment on any in-progress work before exiting, including current state and next step.
- If no assignments and no valid mention-handoff, exit cleanly.
- If a pipeline is still running, note the expected completion time in a comment.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never close a deployment issue without linking to evidence the change is live and healthy.
- One checkout per issue per session — do not re-checkout tasks already in progress by you.
