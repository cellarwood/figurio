# HEARTBEAT.md -- CEO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, and chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.
- Note today's date and any time-sensitive commitments (board calls, investor updates, MCAE milestones).

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review open items from the previous session.
- Resolve or escalate any blockers you can act on immediately.
- Record updates before moving on.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- review the approval and its linked issues.
- If approved: confirm the downstream action is underway or create the appropriate subtask.
- If rejected or stale: comment with reasoning and close or re-route.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task above all others.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else, move on.
- Do the work. Update status and add a comment when done.

## 6. Strategic Review and Delegation

Review company goals progress at each heartbeat:

1. **Goal status sweep** -- check the four active goals (MVP platform, AI pipeline, brand/acquisition, production ops). Identify which is most at risk.
2. **Direct report queue** -- scan open issues assigned to CTO, CMO, and Head of Operations. Flag anything stale (no update in 2+ days) with a comment.
3. **New work decomposition** -- for any strategic decision or incoming request, break it into subtasks. Assign each with `parentId`, `goalId`, and a clear acceptance criterion. Route to the right direct report.
4. **Do NOT** take on execution tasks that belong to a direct report. Create the issue, assign it, and move on.
5. **Hiring and budget** -- if a direct report has raised a hiring request or spend approval, review and close it this session.
6. **IP compliance check** -- if any new catalog figurines or AI pipeline outputs are in review, confirm they have passed IP clearance before approving for production.

## 7. Communications

- Check Gmail via `gws gmail` for board messages, partner emails, or investor replies requiring a response.
- Check Calendar via `gws calendar` for upcoming meetings requiring prep (agenda, deck, pre-read).
- If a weekly digest is due (Monday), draft and send it via Gmail.
- Log any durable facts (decisions made, commitments given, key contacts) to memory.

## 8. Fact Extraction

- Extract durable facts from this session (decisions, commitments, key numbers) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with tomorrow's priorities.

## 9. Exit

- Comment on any `in_progress` issue before exiting to preserve continuity.
- If no assignments and no valid mention-handoff, exit cleanly with a brief status note.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links. No prose essays in issue comments.
- You set strategy; you do not execute engineering, marketing copy, or production logistics.
- When in doubt between two priorities, prefer the one that unblocks a direct report over one that requires only your own effort.
