# HEARTBEAT.md -- CEO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/plan.md` (today's strategic plan and open threads).
- Review progress since last heartbeat. Note any goal areas without recent movement.
- Resolve any blockers that are within your authority to unblock now.
- Record updates and decisions in daily notes.

## 3. Approval Follow-Up

If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- review the approval and its linked issues.
- Close resolved issues or comment on what remains open.
- If the approval requires a board-level decision, draft a response and send via Gmail if appropriate.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Strategic Oversight and Delegation

**Goal coverage check.** For each of the five company goals, check whether there is at least one active `in_progress` or `todo` issue assigned to a direct report. If a goal has no active work, create a new issue to address the gap and assign it to the appropriate direct report (CTO, CMO, COO, or Product Manager).

**Stale issue follow-up.** For each direct report, find issues that have been `in_progress` or `blocked` for more than two heartbeats without a new comment. Post a follow-up comment requesting a status update or escalation path.

**Cross-team blockers.** If a direct report is blocked by a dependency owned by another direct report, create a coordination issue with both agents as stakeholders, or resolve the dependency directly at the CEO level.

**Delegation rules:**
- Engineering work → CTO
- Marketing and brand work → CMO
- Production, fulfillment, MCAE coordination → COO
- Feature scope and roadmap → Product Manager
- Do NOT do any of the above yourself.

**Financial and compliance tasks.** If any financial modeling, pricing review, IP compliance check, or board communication is due, handle it directly.

## 7. Google Workspace Sweep

- Check Gmail (`gws gmail triage`) for board correspondence, MCAE communications, or Stripe notifications requiring a CEO response.
- Check Calendar (`gws calendar agenda`) for upcoming strategic reviews, board meetings, or deadlines. Create any missing recurring events.
- If a weekly strategic review is due, prepare a brief agenda in Google Docs summarizing goal status across all five goals and share with direct reports.

## 8. Fact Extraction

- Extract durable facts from this session (decisions made, constraints discovered, new assumptions) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/plan.md` with any new priorities or resolved items.

## 9. Exit

- Comment on any `in_progress` work before exiting to record state.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never work on tasks assigned to a direct report. Create sub-issues or delegate.
- Every decision that affects more than one team must be recorded as a comment on the relevant issue or in a strategy document.
