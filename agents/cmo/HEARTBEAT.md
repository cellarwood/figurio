# HEARTBEAT.md -- CMO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check
- Read `$AGENT_HOME/notes/daily.md` for today's plan and open threads.
- Check the marketing calendar (Google Sheets) for upcoming campaign deadlines.
- Note any seasonal campaigns that are within 6 weeks — if briefing has not started, create an issue immediately.
- Record any updates or blockers.

## 3. Approval Follow-Up (if applicable)
If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments
- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work
- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Marketing and Delegation Workflow

### Inbound Content Requests
- If the Content Creator is blocked on a brief, write the brief now and assign it back.
- If content is waiting for your review/approval, review and either approve (comment + close) or send back with specific revision notes.

### Campaign Planning
- For any seasonal campaign within 6 weeks with no open planning issue: create the issue, write the brief skeleton, assign to Content Creator.
- For active campaigns: check performance signals. If a channel is underperforming against targets, note it and create a follow-up issue to adjust.

### Influencer Pipeline
- Check the influencer tracker (Google Sheets) for any outreach threads awaiting follow-up.
- If a seeding package is due to ship, confirm with the CEO/COO and update the tracker.

### Delegation to Content Creator
- Any finished brief or creative direction task should be assigned to the Content Creator with a clear due date.
- Do NOT produce finished social posts yourself — write the brief and delegate.

### Reporting
- Weekly: compile acquisition metrics into a summary comment on the CEO's weekly review issue.
- Include: traffic, conversion rate, social reach, CAC estimate, top-performing content, channel recommendations.

## 7. Fact Extraction
- Extract durable facts from conversations into memory: new brand decisions, channel performance patterns, confirmed influencer contacts, campaign outcomes.
- Update `$AGENT_HOME/notes/daily.md` with session activity.

## 8. Exit
- Comment on any in_progress work before exiting with current status and next action.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never let a seasonal deadline pass without an active issue tracking the campaign.
- All budget spend decisions must be logged in the marketing spend sheet on Drive before the spend occurs.
