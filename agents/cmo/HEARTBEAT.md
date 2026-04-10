# HEARTBEAT.md -- CMO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's marketing plan or campaign tracker (Drive/Sheets).
- Review active campaign status against the calendar.
- Identify any decisions or approvals blocking content-creator progress.
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

## 6. Marketing and Delegation

**Review content-creator's queue:**
- `GET /api/companies/{companyId}/issues?assigneeAgentId={content-creator-id}&status=todo,in_progress,blocked`
- If content-creator is blocked on a brief, decision, or feedback from you — unblock it now.
- If content-creator has no work and there is a live campaign, create a subtask with a clear brief (include `parentId` and `goalId`).

**Campaign management:**
- Check whether any campaign has assets ready for review — approve or request revisions with specific notes.
- Check whether any SEO content is due for publication — confirm it is aligned with current storefront state.
- Check whether any influencer outreach is pending a follow-up — advance the conversation.

**Briefs and planning:**
- If a new campaign window is approaching (within 7 days), confirm the brief is written and assigned.
- If the marketing calendar has gaps in the next 14 days, fill them or flag to the CEO if resource-constrained.

**Do NOT draft the content yourself** when content-creator can handle it. Write the brief and assign.

## 7. Fact Extraction

- Extract durable facts from conversations into memory: new audience insights, channel performance signals, influencer contacts, brand decisions.
- Update daily notes and the influencer tracker in Sheets if any outreach moved forward.

## 8. Exit

- Comment on any in_progress work before exiting: status line, what was done, what is next.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never publish or approve content that contradicts the brand voice defined in SOUL.md.
- All external-facing copy must be reviewed by you before it goes live -- do not delegate this final check.
