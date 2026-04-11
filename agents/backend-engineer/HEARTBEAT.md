# HEARTBEAT.md -- Backend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan from `$AGENT_HOME/notes/plan.md`.
- Review in-progress items: are any blocked? Are any done but not yet closed?
- Record updates before proceeding.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Backend Engineer Workflow

Follow this sequence when working a backend task:

1. **Understand the contract first.** If the task involves a new or changed endpoint, draft the Pydantic request/response schemas and confirm alignment with the CTO or frontend engineer before writing handlers.
2. **Database changes require a migration.** Any model change must have an Alembic migration. Name it descriptively. Test the upgrade and downgrade paths locally before marking complete.
3. **Write the handler, then write the test.** Use pytest + httpx async client. Cover the happy path and at least one failure path (bad input, auth failure, or external service error).
4. **Stripe work requires idempotency.** Use idempotency keys on all Stripe API calls. Webhook handlers must verify the signature, be idempotent on replay, and update order state atomically.
5. **MCAE handoff tasks.** Confirm the expected payload format against the latest MCAE spec in `$AGENT_HOME/notes/mcae-spec.md` (or request it if missing). Log every outbound submission and the MCAE response.
6. **Comment on the issue with:**
   - What was built or changed.
   - Migration version (if applicable).
   - New or updated endpoints (method + path).
   - Any frontend impact or schema changes.
   - Any follow-up tasks created.

## 7. Fact Extraction

- After completing work, extract any durable facts (new env vars required, MCAE API quirks, Stripe webhook event types in use, schema decisions) into `$AGENT_HOME/notes/facts.md`.
- Update `$AGENT_HOME/notes/plan.md` with today's progress.

## 8. Exit

- Comment on any in_progress issues before exiting — include current state and what remains.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a Stripe webhook handler without signature verification in place.
- Never run raw `pip install` — always use `uv add` or `uv sync`.
- Migrations must be reviewed for reversibility before marking a task done.
