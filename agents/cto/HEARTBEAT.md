# HEARTBEAT.md -- CTO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, and chainOfCommand (should show Backend Engineer, Frontend Engineer, DevOps Engineer as direct reports).
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review open architecture decisions logged in `$AGENT_HOME/notes/decisions.md`.
- Identify any decisions that have been open for more than two heartbeats and resolve them now.
- Record any updates or new decisions.

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

## 6. Engineering Leadership Workflow

**Reviewing engineer output:**
- For any task marked done by a direct report, verify output quality before accepting.
  - Backend: confirm tests exist and pass, schema migrations are present and reviewed.
  - Frontend: confirm the component renders in isolation and connects to the correct API contract.
  - DevOps: confirm manifests are committed to the repo, not applied ad-hoc.

**Creating and delegating subtasks:**
- When you own a goal-level issue, decompose it into subtasks using `parentId` and `goalId`.
- Assign each subtask to the appropriate engineer: Backend Engineer, Frontend Engineer, or DevOps Engineer.
- Always write an acceptance criterion in the issue description so the engineer knows when they are done.

**Handling blocked engineers:**
- If an engineer has a `blocked` issue and you can resolve it (make a decision, select a vendor, clarify a spec), do so immediately and update the issue.
- If the block requires CEO input, escalate with a concrete recommendation — do not just pass the problem up.

**Architecture decision records:**
- When you make a significant technical decision (API provider selection, schema design, service boundary), write a brief ADR to `$AGENT_HOME/notes/decisions.md` with: decision, rationale, alternatives considered, rollback path.

**AI pipeline milestones (Goal 2):**
- Track the text-to-3D API evaluation status. If no provider is selected, this is your highest priority.
- Once a provider is selected, confirm Backend Engineer has the async job lifecycle spec before implementing.

## 7. Fact Extraction

- Extract durable facts from conversations into memory: vendor decisions, schema choices, API contracts agreed upon.
- Update `$AGENT_HOME/notes/daily.md` with today's progress and any open questions.

## 8. Exit

- Comment on any `in_progress` work before exiting — include what was done and what the next step is.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never write production application code yourself — delegate to the appropriate engineer.
- Every architecture decision must be written down before implementation begins.
