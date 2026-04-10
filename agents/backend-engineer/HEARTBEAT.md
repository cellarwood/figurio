# HEARTBEAT.md -- Backend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review in-progress work from the previous cycle.
- Identify any blockers that emerged overnight (external API changes, failing CI, missing secrets).
- Record updates and next actions.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can now unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.
- Focus effort on the `mvp-backend` project unless the CTO explicitly redirects you.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.
- Include `X-Paperclip-Run-Id` on all mutating API calls.

## 6. Backend Engineering Workflow

For each task, follow this sequence:

**Schema / migration work:**
1. Draft or update the SQLAlchemy model in `models/`.
2. Generate an Alembic migration: `uv run alembic revision --autogenerate -m "<description>"`.
3. Review the generated migration SQL before applying.
4. Apply: `uv run alembic upgrade head`.
5. Write pytest tests covering the new schema paths.

**API endpoint work:**
1. Define Pydantic request/response schemas first.
2. Implement the route handler with proper dependency injection.
3. Write httpx-based async pytest tests (happy path + error cases).
4. Run `uv run pytest` -- all tests must pass before marking done.

**Stripe integration work:**
1. Verify webhook signature before any processing (`stripe.Webhook.construct_event`).
2. Make all webhook handlers idempotent -- check for duplicate event IDs.
3. For custom figurine two-stage payments: deposit at prompt submission, final capture only after customer approves the preview model.
4. Never log raw Stripe payloads.

**AI text-to-3D pipeline work:**
1. Submit job to Meshy or Tripo3D API and store the job ID in the database.
2. Poll for completion status -- use async background tasks, not blocking waits.
3. On completion: run mesh repair, generate preview image, store assets.
4. Advance the order state machine and notify the customer.

**All work:**
- Use `uv run` for every Python invocation -- never call `python` or `pip` directly.
- Add or update docstrings on public functions.
- Comment the issue with a concise summary: what changed, test results, any follow-up needed.

## 7. Fact Extraction

- Extract durable facts from conversations: API quirks, MCAE integration notes, Stripe event types used, Meshy/Tripo3D rate limits.
- Write them to `$AGENT_HOME/notes/facts.md`.
- Update `$AGENT_HOME/notes/daily.md` with today's progress.

## 8. Exit

- Comment on any in-progress work before exiting: current state, next step, any blocker.
- If blocked, set issue status to `blocked` and name the specific dependency needed.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- `uv` only -- never pip, never poetry, never bare `python -m pip`.
- A task is not done until tests pass.
