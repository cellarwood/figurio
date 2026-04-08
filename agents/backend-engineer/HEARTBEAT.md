# HEARTBEAT.md -- Backend Engineer Heartbeat Checklist

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
- Do the work. Update status and comment when done.

## 6. Backend Health Checks
- Run the test suite: `uv run pytest --tb=short -q`. If any tests fail, fix them before starting new work.
- Check API endpoint status: verify `/health` and `/api/v1/status` return 200.
- Review Stripe webhook health: check for failed webhook deliveries in the Stripe dashboard or local logs. If webhooks are failing, diagnose and fix immediately — payment issues are P0.
- Check the mesh repair pipeline logs for any failed or stuck repair jobs. Re-queue or flag for manual review as appropriate.
- Review database migration status: ensure all migrations are applied and no pending migrations are uncommitted.

## 7. Delegation Protocol
When creating subtasks:
- Always set `parentId` to link to the parent issue.
- Always set `goalId` to trace work back to a company goal.
- Include clear acceptance criteria in the task description.

## 8. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 9. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
