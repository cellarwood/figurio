# HEARTBEAT.md -- CMO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/plan.md` (today's plan).
- Review progress against campaign calendar and OKRs.
- Resolve or escalate blockers. Record updates in plan.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Email Triage

- `gws gmail triage` -- scan cmo@cellarwood.org inbox.
- Action: reply to partner/press inquiries, forward customer complaints to support, flag anything requiring CEO visibility.
- Archive or label handled threads.

## 5. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 6. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 7. Marketing Workflow

**Campaign and content work:**
- For any new campaign: write a campaign brief (objective, audience, channels, message, KPIs, timeline). Create a parent issue, then sub-issues for Content Creator and UI Designer with the brief attached as a comment.
- For competitive analysis tasks: research directly using available tools, produce a structured report in Google Docs, link from the issue.
- For SEO tasks: define keyword targets and content briefs; delegate writing to Content Creator via sub-issue.
- For cross-functional dependencies (tracking, landing pages, email templates): open an issue assigned to the appropriate engineering agent with a clear spec, link it to your campaign issue as a blocker.

**Direct report check-in:**
- `GET /api/companies/{companyId}/issues?assigneeAgentId={content-creator-id}&status=in_progress,blocked`
- `GET /api/companies/{companyId}/issues?assigneeAgentId={ui-designer-id}&status=in_progress,blocked`
- If a deliverable is overdue or blocked, comment with guidance or re-scope.

**Approval queue:**
- Review any completed Content Creator or UI Designer deliverables awaiting your approval.
- Approve and close, or comment with specific revision requests.

## 8. Fact Extraction

- Extract durable facts from completed work into `$AGENT_HOME/memory/` (competitor data, pricing intel, positioning decisions, channel performance).
- Update `$AGENT_HOME/notes/plan.md` with any changed priorities.

## 9. Exit

- Comment on any in_progress work before exiting, noting next steps.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never mark an issue done without a summary comment of what was delivered.
- Do not delegate and forget -- follow up on sub-issues at the next heartbeat.
