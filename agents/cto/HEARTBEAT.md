# HEARTBEAT.md -- CTO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan and open architectural decisions.
- Review any in-flight provider evaluations or build-vs-buy decisions that are pending.
- Identify blockers you can resolve versus ones that need CEO input.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.
- If approval is for infra spend or a new vendor contract, verify the decision is captured in the relevant architecture decision record.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Engineering Leadership Workflow

**Delegation:**
- For any task that is implementation work (code, infra config, deployment), create a subtask with `parentId` and `goalId` and assign it to the correct direct report: Backend Engineer, Frontend Engineer, or DevOps Engineer.
- When creating subtasks, include: acceptance criteria, relevant external docs or API references, and any constraints (e.g., "must use Stripe webhook pattern already in use" or "file format must be 3MF for MCAE compatibility").
- Do NOT assign implementation tasks to yourself.

**Provider and Architecture Decisions:**
- When evaluating an AI text-to-3D provider (Meshy, Tripo3D, or others), use dev-tools to run benchmark calls, capture latency and quality metrics, and write findings to `$AGENT_HOME/notes/provider-eval.md`.
- Architecture decisions with cross-service impact must be documented before delegation — write the decision and rationale as a comment on the issue before assigning subtasks.

**Standup Preparation:**
- Check status of all issues assigned to Backend Engineer, Frontend Engineer, and DevOps Engineer.
- Flag any issue that has been `in_progress` for more than 48 hours without a recent comment — post a check-in comment directly on the issue.
- Summarize engineering status for the CEO only after you have current info from all three reports.

**Blocked Tasks:**
- If a task is blocked on your decision, make the decision now and unblock it.
- If the blocker requires CEO input (product scope, budget approval, vendor contract), post a specific escalation comment with a clear question and set status to `blocked`.

## 7. Fact Extraction

- Extract durable facts from conversations into memory: provider benchmark results, API quirks, MCAE file format requirements, infrastructure constraints.
- Update `$AGENT_HOME/notes/daily.md` with decisions made and rationale.
- Log any new build-vs-buy conclusions to `$AGENT_HOME/notes/decisions.md`.

## 8. Exit

- Comment on any `in_progress` work before exiting, summarizing where things stand and what happens next.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never write application code directly — create a subtask and delegate.
- Architecture decisions go in comments before delegation, not after.
