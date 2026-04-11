# HEARTBEAT.md -- CMO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Check the campaign calendar (Sheets) for any launches, deadlines, or scheduled sends due today or within 48 hours.
- Identify any blockers: stalled content-creator issues, awaiting influencer replies, pending CEO approvals.
- Record updates to daily notes before moving on.

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

## 6. Marketing Workflow

**Campaign briefs:**
- For any approved campaign, create a brief document in Drive and open an issue for content-creator with `parentId` set to the campaign issue and a clear `goalId`.
- Brief must include: campaign goal, target audience, channel(s), key message, visual direction, deadline, and success metric.
- Do NOT write the production content yourself — hand it off via the issue.

**Influencer outreach:**
- Check the influencer tracker (Sheets) for any threads awaiting reply older than 5 days.
- Send follow-up via Gmail or close the row as inactive.
- Identify at least one new outreach candidate per week during the pre-launch and launch phases.

**KPI monitoring:**
- On Mondays, pull the latest acquisition metrics and update the KPI dashboard (Sheets).
- If any metric (conversion rate, CPA, email open rate) falls below threshold, open an issue for yourself with the proposed pivot before the weekly CEO sync.

**Launch campaign:**
- Track waitlist signups daily during pre-launch.
- Coordinate with CEO on launch date confirmation before scheduling any public announcement.
- Ensure content-creator has all assets ready at least 48 hours before a scheduled publish.

**Delegation rules:**
- Create subtasks for content-creator using `parentId` (campaign issue) and `goalId`.
- Content-creator handles copy, posts, and visual execution. You handle strategy, briefs, and outreach.
- If content-creator is blocked, unblock or escalate within the same heartbeat — do not let it sit.

## 7. Fact Extraction

- Extract durable facts (influencer contacts confirmed, brand decisions made, channel strategies locked) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with today's decisions and outstanding items.

## 8. Exit

- Comment on any `in_progress` issues before exiting — state what was done and what is next.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a campaign issue `in_progress` without a comment explaining current state.
- Brand decisions (logo changes, voice shifts, positioning pivots) must be documented in the brand guidelines doc before being actioned in any content brief.
