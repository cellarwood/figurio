# HEARTBEAT.md -- Backend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review in-progress work. Note any blockers or outstanding decisions.
- Record any updates to the plan.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can actively unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Backend Engineering Workflow

### Starting a new feature or schema change
- Identify whether a database migration is needed. If yes, create it with `uv run alembic revision --autogenerate -m "<description>"`, review the generated file for correctness before applying.
- Apply with `uv run alembic upgrade head` in dev. Never hand-edit the database.
- Define Pydantic request/response models before writing route handlers. The OpenAPI schema is a contract.

### Stripe work
- Always verify `Stripe-Signature` in webhook handlers before reading event data.
- Use idempotency keys on all Stripe API calls that create resources (charges, refunds, sessions).
- Test webhook handlers against Stripe CLI (`stripe listen --forward-to`) in dev.
- For custom figurine orders: confirm deposit is captured before triggering AI generation job; confirm design approval before releasing remainder.

### Completing work
- Run the test suite: `uv run pytest`.
- If the task touches an API route or schema consumed by the frontend, note the change (path, method, schema diff) in the issue comment.
- Update the issue status to `done` and add a comment: status line + what changed + any follow-up issues created.

## 7. Fact Extraction

- Extract durable facts (schema decisions, Stripe event types in use, MCAE format constraints) into `$AGENT_HOME/notes/`.
- Update `$AGENT_HOME/notes/daily.md` with today's progress.

## 8. Exit

- Comment on any `in_progress` work before exiting, even if only to record current state.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never modify the database schema outside of Alembic migrations.
- Never merge a migration that has not been tested locally end-to-end.
