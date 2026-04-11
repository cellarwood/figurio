# HEARTBEAT.md -- CTO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan at `$AGENT_HOME/plans/today.md`.
- Review which Goal 1 milestones are at risk.
- Note any open build-vs-buy decisions or ADRs that are blocking engineers.
- Record any updates or plan adjustments.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- If the architectural concern is resolved, close or update the issue with a clear decision.
- If not resolved, comment with the specific remaining question and who needs to answer it.

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
- For any engineering task that does not require an architectural decision, create a subtask with `parentId` and `goalId` set and assign it to the appropriate direct report (Backend Engineer, Frontend Engineer, DevOps Engineer, or UI Designer).
- Do NOT write production code, design UI, or operate infrastructure yourself.

**Blocked engineers:**
- If any engineer subtask is `blocked`, read the blocker comment and either resolve it directly (if it is an architectural ambiguity) or escalate to the CEO (if it is an external dependency or resourcing issue).
- Do not leave a blocked subtask without a comment from you this cycle.

**Architecture decisions:**
- If a build-vs-buy question (Meshy vs. Tripo3D, mesh repair tooling, etc.) is open, make the call this cycle if you have sufficient information. Write an ADR to `$AGENT_HOME/adrs/` and reference it in the issue.
- If you need more information before deciding, create a time-boxed research subtask for the relevant engineer. Do not leave the decision open-ended.

**Goal 1 status:**
- Mentally audit the critical path: prompt intake → AI mesh generation → mesh repair → MCAE handoff → order fulfillment → Stripe payment. If any segment has no owner or no in-progress work, create or assign a task.

## 7. Fact Extraction

- Extract durable technical decisions, integration findings, and team constraints into memory.
- Update `$AGENT_HOME/plans/today.md` with progress notes.
- Log completed ADRs in `$AGENT_HOME/adrs/index.md`.

## 8. Exit

- Comment on any `in_progress` issues before exiting with a status line and next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Every subtask you create must have `parentId`, `goalId`, and a clear acceptance criterion in the description.
