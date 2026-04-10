# HEARTBEAT.md -- CMO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan from `$AGENT_HOME/notes/daily.md`.
- Review the campaign calendar in Google Drive. Note any campaigns due within 7 days.
- Check the influencer outreach pipeline sheet for contacts awaiting follow-up.
- Record any blockers or updates before proceeding.

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

## 6. Marketing-Specific Workflow

### Delegation to Content Creator
- For any campaign requiring creative assets or copy, create a Paperclip issue assigned to the Content Creator.
- Every brief must include: campaign name, objective, target audience, platform, format, deadline, call-to-action, and any brand constraints.
- Link the brief issue to the parent campaign goal with `parentId` and `goalId`.
- Do NOT produce first-draft creative yourself.

### Campaign Calendar Review
- Check whether any seasonal campaign (Valentine's, Halloween, Christmas) is within 14 days of its launch date.
- If a campaign lacks a complete brief or assigned issues, create them immediately.
- If a campaign is at risk of missing its launch date, flag to the CEO as a comment on the relevant goal issue.

### Influencer Pipeline
- `gws sheets read` -- check the influencer outreach tracker.
- Any contact outreached more than 7 days ago with no reply: send one follow-up via `gws gmail send`, then mark as inactive if still no reply.
- New influencer targets identified during research: add to the tracker with niche, follower count, platform, and relevance score.

### KPI Check
- `gws sheets read` -- review the weekly marketing KPI sheet.
- If any metric has moved more than 20% week-over-week (traffic, conversion rate, CAC, email list size, social followers), note the cause and prepare a one-paragraph summary for the CEO.

### Competitive Research
- When assigned, use media-plugin (Playwright) to screenshot competitor pages (HeroForge, Shapeways, Funko).
- Document findings in a Google Doc in the shared Drive folder `/marketing/competitive-research/`.

### Gmail Triage
- `gws gmail triage` -- scan inbox for influencer replies, partnership inquiries, and board communications.
- Respond to influencer replies within 24 hours.
- Forward anything requiring CEO input as a comment on the relevant Paperclip issue.

## 7. Fact Extraction

- Extract durable facts from conversations and research into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with what was completed, what is in flight, and what is blocked.
- If a competitor positioning change was discovered, update the competitive research doc.

## 8. Exit

- Comment on any in_progress work before exiting: one status line, key decisions made, next action required.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never publish a campaign brief to the Content Creator without a deadline and a clear call-to-action.
- Never skip the KPI check when waking for a scheduled heartbeat.
