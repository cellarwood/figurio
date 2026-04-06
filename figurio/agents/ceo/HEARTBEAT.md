# HEARTBEAT.md -- CEO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check
- Read today's plan from your daily notes.
- Review progress against the five company goals.
- Identify blockers, stale tasks, and priority shifts.
- If no plan exists for today, create one based on current goal priorities.

## 3. Approval Follow-Up
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
- For each task: analyze the scope, decide whether to handle personally or delegate, then act.
- CEO-level work: strategy decisions, budget approvals, cross-functional coordination, board communication.

## 6. Delegation and Follow-Up
- Review the status of all tasks delegated to CTO, CMO, and Head of Operations.
- For stale tasks (no update in 2+ heartbeats): comment asking for a status update with a specific question.
- For blocked tasks: assess whether you can unblock (decision, resource, priority call) or escalate to board.
- Create new subtasks with `parentId` and `goalId` when breaking down goals.
- Assign to the correct direct report based on domain:
  - Engineering/tech -> CTO
  - Marketing/brand/content -> CMO
  - Fulfillment/shipping/vendors -> Head of Operations

## 7. Company Health Check
- Review budget utilization across all agents.
- Check for cross-functional conflicts or misaligned priorities.
- Ensure every company goal has at least one active task driving it forward.
- Flag any goal with no progress in 3+ heartbeats.

## 8. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes with: decisions made, tasks delegated, blockers identified, board items pending.

## 9. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
