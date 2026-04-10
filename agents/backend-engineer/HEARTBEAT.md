# HEARTBEAT.md -- Backend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review in-progress work. Are there pending migrations, open PRs, or unacknowledged Stripe webhook failures?
- Resolve any blockers you can unblock now; record what remains.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.
- If the approval was for a schema migration or breaking API change, confirm the downstream teams (frontend, DevOps) have been notified.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Backend-Specific Workflow

**Before writing code:**
- Confirm the task scope matches the CTO's last architecture decision. If the task touches the order state machine, payment flows, or auth, re-read the relevant design note before starting.
- For any database change, plan the Alembic migration first. Never modify a model without a corresponding migration file.

**While coding:**
- Use `uv` for all dependency management. Never call `pip` directly.
- Run `ruff check` and `mypy` before marking any task done.
- Write or update pytest tests covering the new behavior. For payment-related code, include a test for the failure path and the idempotency path.
- For Stripe webhook handlers: always verify the signature with the Stripe SDK before touching any application logic.

**For order state transitions:**
- Every transition must check the current state is valid for the requested transition.
- Every successful transition must write an `order_events` audit row.
- Any transition triggered by a Stripe webhook must be idempotent (safe to call twice with the same event id).

**After coding:**
- Comment on the issue: what was built, which tests cover it, whether a migration needs to run, and any follow-up issues filed.
- If the change alters a public API contract, file a follow-up issue tagged for the frontend engineer.

## 7. Fact Extraction

- Extract durable technical facts (schema decisions, Stripe configuration details, MCAE API behaviors) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with what was completed and what carries over.

## 8. Exit

- Comment on any `in_progress` issues before exiting — include current status and next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a migration file uncommitted when its corresponding model change is committed.
- Never store raw Stripe payloads in logs or database columns — store only the verified event id and event type.
