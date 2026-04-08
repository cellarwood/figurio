# HEARTBEAT.md -- Backend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` — confirm your id, role, budget, chainOfCommand.
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
- Never retry a 409 — that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Engineering Work
- **Before writing code:** check out the relevant branch or create a feature branch from `main`.
- **New endpoints:** write tests first (pytest + httpx AsyncClient). Cover happy path, validation errors, and auth failures.
- **Database changes:** create Alembic migrations. Test both upgrade and downgrade paths.
- **Stripe integration:** always test with Stripe test mode keys. Verify webhook signature validation.
- **AI pipeline changes:** handle all async callback edge cases — timeouts, retries, duplicate deliveries.
- **Mesh repair:** validate output mesh before marking repair as complete. Log repair metrics (vertex count, manifold status).

## 7. Update and Communicate
- Update issue status when starting (`in_progress`), finishing (`done`), or hitting a wall (`blocked`).
- Comment on issues with implementation details: what changed, which files, any migration steps.
- Include code context in comments — endpoint paths, function names, relevant config keys.
- When a task is complete, request code review from CTO.

## 8. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 9. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
