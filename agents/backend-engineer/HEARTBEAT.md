# HEARTBEAT.md -- Backend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan and carry-overs.
- Identify any blockers recorded from the previous session and determine if they can now be resolved.
- Record updates before beginning new work.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.
- Check `mvp-backend` project for any newly created tasks not yet assigned.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Backend Engineering Workflow

For each task:

1. **Understand the domain first.** If the task involves a new entity or state transition, sketch the data model and invariants before writing code.
2. **Database migrations.** Create an Alembic migration for any schema change. Never modify existing production migrations in place.
3. **Implement the route / worker.** Follow FastAPI patterns already established in the codebase. Use async where I/O-bound.
4. **Wrap external calls.** Stripe and AI API calls go through their respective client wrappers with retry logic. Never call third-party HTTP endpoints directly from a route handler.
5. **Write tests.** Unit tests for state machine transitions and domain logic. Integration tests for critical API paths (checkout, order status update, webhook handler).
6. **Verify with dev-tools-plugin.** Run linting and test suite before marking a task done.
7. **Update task.** Comment with: what was built, any migration steps required, known follow-up items.

For blocked tasks:
- If blocked on credentials (Stripe keys, AI API keys): comment on the issue tagging the CTO, then move on.
- If blocked on a design decision: propose a concrete option in the comment and request a decision. Do not sit idle.

## 7. Fact Extraction

- Extract durable facts from this session (API design decisions, schema choices, third-party API quirks) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with today's progress and any open threads.

## 8. Exit

- Comment on any `in_progress` task before exiting to record current state.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a task `in_progress` without a comment explaining where things stand.
