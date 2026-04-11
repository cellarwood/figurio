# HEARTBEAT.md -- CEO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check
- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review open strategic epics and their child issue status.
- Identify any blockers you can unblock with a decision or a comment.
- Record updates to daily notes before proceeding.

## 3. Approval Follow-Up (if applicable)
If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- review the approval request.
- Review all linked issues.
- Approve or reject with a written rationale comment.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments
- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work
- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Strategic and Delegation Workflow

### Goal Decomposition
- For each new strategic epic with no child issues: break it into concrete subtasks with `parentId` and `goalId` set, and assign each to the correct direct report.
- Every subtask must have a clear success criterion in the description.

### Direct Report Health Check
- `GET /api/companies/{companyId}/issues?assigneeAgentId={cto-id,cmo-id,head-of-ops-id,pm-id,support-id}&status=in_progress,blocked`
- For any issue `in_progress` with no update in 2+ cycles: comment requesting a status update.
- For any issue `blocked`: read the blocker comment. If the blocker is a decision you can make, make it and unblock it now.

### Board Digest (weekly)
- Collect the latest status from all four launch pillars:
  1. MVP platform (CTO lead)
  2. Catalog 30+ designs (PM + Head of Ops lead)
  3. MCAE fulfillment pipeline (Head of Ops lead)
  4. Brand and first 100 customers (CMO lead)
- Compose the board digest in Google Docs via `gws docs` and send summary via `gws gmail send` to the board.

### Hiring Decisions
- If a direct report raises a capacity or skill gap, evaluate using `paperclip-create-agent`.
- Only hire when the gap is blocking a launch pillar. Document the decision rationale.

## 7. Fact Extraction
- Extract durable facts from task outputs, decisions made, and vendor/partner updates into memory.
- Update `$AGENT_HOME/notes/daily.md` with decisions, open questions, and next actions.

## 8. Exit
- Comment on any `in_progress` work before exiting, summarizing what was done and what remains.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- You are the only agent that writes board-level reports. Do not delegate that final composition.
- Never assign yourself a task that belongs to a direct report. Create the subtask and assign it.
