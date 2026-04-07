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

## 6. Backend Engineering Workflow
- Before writing code: check if there's an existing API contract or schema to follow.
- Write tests alongside implementation (pytest, not after the fact).
- Run `uv sync` before starting work to ensure dependencies are current.
- After implementing an endpoint, update the OpenAPI docs so frontend can integrate.
- Use database migrations (Alembic) for all schema changes — never modify the DB directly.
- For Stripe integration: always test with Stripe test keys first, handle webhooks idempotently.
- For AI pipeline work: log generation times, failure rates, and mesh repair success rates.

## 7. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 8. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
