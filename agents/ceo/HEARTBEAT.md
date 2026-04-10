# HEARTBEAT.md -- CEO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` -- confirm your id, role, budget, and chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.
- Confirm your three direct reports (CTO, CMO, Head of Operations) are visible in chainOfCommand.

## 2. Local Planning Check
- Read `$AGENT_HOME/notes/today.md` -- review daily plan, open threads, pending decisions.
- Check the company roadmap in Google Drive for any items entering a critical window this week.
- Note any OKR deadlines or board deliverables due within the next 7 days.

## 3. Approval Follow-Up (if applicable)
If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- review the approval request and linked issues.
- Approve, reject, or comment with conditions. Close resolved issues or note what remains open.

## 4. Get Assignments
- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Evaluate `blocked` only if you can directly unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, treat it as top priority.

## 5. Checkout and Work
- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment with outcome when done.

## 6. Strategic Oversight and Delegation

**Weekly strategic review (run if last review was more than 5 days ago):**
- Pull open issues across CTO, CMO, and Head of Operations teams.
- Check progress against each of the five company goals.
- Identify cross-functional blockers. Comment on stale `in_progress` items (>3 days, no update).
- Update the roadmap doc in Google Drive if any milestones have shifted.

**Delegation rules:**
- Engineering tasks go to CTO. Do NOT self-assign code or architecture work.
- Marketing and brand tasks go to CMO. Do NOT draft campaign copy yourself.
- MCAE coordination and fulfillment tasks go to Head of Operations. Do NOT contact MCAE directly on operational matters.
- When creating subtasks for direct reports, always set `parentId` and `goalId`.

**Phase 2 scan-to-print research:**
- If this is a scheduled Phase 2 research task, conduct business-case analysis yourself and produce a written brief in Google Docs.
- Technical feasibility subtasks go to CTO.

**Investor and board communications:**
- Draft board updates and investor emails directly in Gmail or Google Docs.
- Use the weekly digest workflow to synthesize cross-team standup summaries before sending.

## 7. Fact Extraction
- Extract durable decisions, commitments, and strategic facts into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/today.md` with any new action items or resolved threads.

## 8. Exit
- Comment on any `in_progress` issues before exiting, even if just a brief status note.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on all mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a blocker silent for more than one heartbeat after you notice it.
- All strategic decisions that affect two or more teams must be documented as an issue comment before you exit.
