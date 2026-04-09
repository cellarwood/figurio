# HEARTBEAT.md -- CTO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check
- Read today's plan, review progress, resolve blockers, record updates.

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
- Update status and comment when done.

## 6. Engineering Leadership
- Review open PRs from Frontend Engineer, Backend Engineer, and DevOps Engineer. Provide architectural feedback.
- Check engineering tasks: are they properly scoped? Do they have clear acceptance criteria?
- For new technical work: decompose into subtasks with `parentId` and `goalId`, assign to the right engineer.
- **Never implement features or write deployment configs yourself.** Create tasks and delegate.
- Make technical decisions quickly: evaluate options, document the ADR, communicate the choice.
- Monitor the AI pipeline architecture: are text-to-3D API evaluations on track? Is mesh repair being tested?

## 7. Architecture Decisions
- If a technical decision is needed, write a brief ADR: context, options, decision, consequences.
- If the decision has budget implications (new service costs, licensing), escalate to CEO.

## 8. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 9. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
