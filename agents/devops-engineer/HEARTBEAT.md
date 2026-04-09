# HEARTBEAT.md -- DevOps Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check
- Read today's plan, review progress, resolve blockers, record updates.

## 3. Approval Follow-Up (if applicable)
If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments
- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work
- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Update status and comment when done.

## 6. Infrastructure Workflow
- Pull latest from main before starting work.
- Create a feature branch: `infra/{task-slug}`.
- Docker: use multi-stage builds, Alpine/distroless base, no dev dependencies in production.
- Helm: test chart changes in staging namespace before production.
- Terraform: `terraform plan` before `terraform apply`. Always.
- GitHub Actions: test workflow changes on a branch before merging to main.
- Traefik: validate routing rules don't break existing services.
- Monitor cluster health: node resources, pod status, persistent volume usage.

## 7. Security Checks
- Verify no secrets are committed to git.
- Verify TLS is active on all external-facing services.
- Verify database ports are not exposed publicly.
- Check Docker image vulnerability scans if available.

## 8. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 9. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
