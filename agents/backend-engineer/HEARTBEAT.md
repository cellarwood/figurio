# HEARTBEAT.md -- Backend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/` for today's plan and outstanding items.
- Review any open migration conflicts or failing test runs noted from the previous session.
- Resolve or escalate blockers before picking up new work.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- read the approval and linked issues.
- Close issues that were resolved by the approved change.
- Comment on any issues that remain open, describing what is still needed.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can directly unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task above the queue.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to another worker instance.
- Do the work. Update status to `in_progress` when you start, `done` when complete.
- Comment on the issue when done: status line + bullet summary + links to commits or PRs.

## 6. Backend Engineering Workflow

### For API and business logic tasks
- Read the relevant FastAPI router and Pydantic schemas before editing.
- Run existing tests with `uv run pytest` before and after changes to confirm no regressions.
- Always manage dependencies with `uv add` / `uv remove` -- never call `pip` directly.
- After schema changes, generate an Alembic migration: `uv run alembic revision --autogenerate -m "<description>"`.
- Review the generated migration file manually before committing -- autogenerate is not always correct.

### For AI pipeline and Celery tasks
- Check `$AGENT_HOME/runtime/agents/mesh-pipeline-guide.md` for the canonical pipeline architecture.
- Implement retries with exponential backoff for all external API calls (Meshy, Tripo3D).
- Test Celery tasks in eager mode in pytest (`CELERY_TASK_ALWAYS_EAGER=True`).
- Log task start, external API response codes, and final outcome at INFO level.

### For Stripe integration
- Test webhooks locally using the Stripe CLI (`stripe listen --forward-to ...`).
- Always verify the webhook signature before processing any event.
- Use idempotency keys on all charge and payment intent creation calls.

### For mesh repair (Blender)
- Run Blender headless: `blender --background --python <script.py>`.
- Scripts must exit with a non-zero code on failure so Celery marks the task as failed.
- Keep Blender scripts under `backend/workers/mesh/` and test with sample STL/OBJ fixtures.

## 7. Fact Extraction

- After completing significant work, extract durable facts (API contracts settled, migration numbers, third-party quirks) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with what was done and what is next.

## 8. Exit

- Comment on any `in_progress` issue before exiting, describing exact state and the next concrete step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never call `pip` directly -- always use `uv`.
- Never commit secrets; reference environment variables via `.env.example` only.
