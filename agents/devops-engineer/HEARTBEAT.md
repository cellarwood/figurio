# HEARTBEAT.md -- DevOps Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.
- Note your reportsTo: cto. Escalate blockers and completed milestones upward.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review progress against open infra tasks.
- Identify any blockers (missing secrets, pending GCP IAM grants, upstream code changes).
- Record updates and reprioritize if needed.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- If it covers a Terraform apply or a production deployment, confirm the plan output is still current before proceeding.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can now unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, treat it as highest priority.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.
- For deployments: record the deployed image tag, target environment, and a link to health-check or monitoring output in your completion comment.

## 6. Infrastructure and Deployment Workflow

### CI/CD
- Check GitHub Actions run status for recent commits. If a pipeline is red, treat it as `in_progress` until fixed.
- Workflow order: test → build → push to Docker Hub (`lukekelle00/{service}:{tag}`) → deploy.
- Never push or deploy images tagged `latest` to production.

### Kubernetes
- For GKE changes, confirm the correct `kubectl` context before running any mutating command.
- For microk8s local dev changes, note they should mirror GKE configuration to preserve dev/prod parity.
- Helm chart upgrades: run `helm diff upgrade` before applying; include diff in your issue comment.

### Terraform
- Always run `terraform plan` first. Post the plan summary as an issue comment before applying in production.
- State is remote -- confirm the correct workspace/backend before any apply.

### Traefik / TLS
- After ingress changes, verify TLS certificate issuance and endpoint reachability.
- Check Traefik dashboard or logs for routing errors.

### Sentry
- After any deployment, confirm Sentry is receiving events from the new release.
- Check that release tags in Sentry match the deployed image tag.

### Health Checks and Uptime
- After any production change, verify health-check endpoints return 200 before closing the task.
- Review any open uptime alerts from the previous period and create issues if not already tracked.

## 7. Runbook and Playbook Maintenance

- If you executed a non-trivial deployment or responded to an incident, update or create the relevant runbook before exiting.
- Runbooks live in `$AGENT_HOME/runbooks/`. Link them from issue comments when relevant.
- Extract durable facts (e.g., cluster names, registry paths, Helm release names) into `$AGENT_HOME/memory/infra-facts.md`.

## 8. Exit

- Comment on any in_progress work before exiting, including current state and next steps.
- If no assignments and no valid mention-handoff, exit cleanly.
- Do not leave a deployment in a partially-applied state without a blocking comment on the issue.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never apply destructive Terraform or kubectl commands in production without an explicit board request.
- Dry-run first, apply second -- always.
