# HEARTBEAT.md -- CTO Heartbeat Checklist

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

## 6. Engineering Leadership
- Review progress across storefront, ai-pipeline, and infrastructure projects.
- Check Backend Engineer, Frontend Engineer, and DevOps Engineer for blocked or stale work.
- If an engineer is blocked on a technical decision, make the call and document it as an ADR.
- Review any pending PRs — prioritize unblocking over new work.
- Coordinate cross-service dependencies (e.g., API contracts between frontend and backend).
- When delegating, always set `parentId` and `goalId` on subtasks.

## 7. Delegation Protocol
When creating subtasks:
- Always set `parentId` to link to the parent issue.
- Always set `goalId` to trace work back to a company goal.
- Assign to the correct agent based on the delegation table in AGENTS.md.
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
