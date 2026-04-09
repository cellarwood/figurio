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
- Update status and comment when done.

## 6. Backend Development Workflow
- Pull latest from main before starting new work.
- Create a feature branch: `feat/{task-slug}`.
- Use `uv` for all package management (NEVER pip).
- Activate venv: `uv venv && source .venv/bin/activate`.
- Implement with FastAPI + Python 3.10+ type hints.
- Create Alembic migrations for schema changes.
- Write pytest tests for all new endpoints and business logic.
- Document endpoints with OpenAPI annotations.
- Create PR, link to the task.

## 7. Payment and AI Pipeline
- Stripe integration: always use test mode keys during development.
- Webhook handlers must be idempotent — handle duplicate deliveries gracefully.
- AI pipeline: if text-to-3D API is unavailable, implement with mock responses and flag.
- Mesh repair: validate output against printability constraints before passing to QA.

## 8. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 9. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
