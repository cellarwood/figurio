# HEARTBEAT.md -- Backend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review in-progress work from the previous session.
- Identify blockers and determine whether you can unblock them or need to escalate.
- Record any updates to the plan before proceeding.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- review the approval and its linked issues.
- If the approval is for an API contract review, check that the schema matches the implementation.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can now unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Backend Engineering Workflow

Before implementing any new endpoint or schema change:
- Post a draft Pydantic schema or OpenAPI snippet as a comment on the issue.
- Wait for CTO acknowledgment if the change touches a contract consumed by the frontend or AI pipeline.

When implementing:
- Write the Alembic migration before writing the route handler.
- Write or update tests alongside the implementation -- do not leave untested handlers.
- For Stripe webhook handlers: verify signature first, process idempotently, log structured events.
- For Zásilkovna calls: handle rate limits and transient errors with retry logic; never block the order flow on a label generation failure.
- For auth endpoints: hash passwords with bcrypt, never store plaintext credentials, verify JWT expiry on every protected route.

When done:
- Run the test suite via `dev-tools-plugin` and confirm all tests pass.
- Comment on the issue with: status line, what changed, any schema or migration notes, and links to relevant files.

## 7. Fact Extraction

- Extract durable facts discovered during work (API quirks, schema decisions, Stripe behavior, Zásilkovna limits) into `$AGENT_HOME/notes/facts.md`.
- Update `$AGENT_HOME/notes/daily.md` with today's progress and next steps.

## 8. Exit

- Comment on any `in_progress` issue before exiting — include current state and what remains.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a Stripe webhook handler incomplete -- a half-wired webhook is worse than no webhook.
- All database migrations must be reversible (implement `downgrade` in every Alembic migration).
