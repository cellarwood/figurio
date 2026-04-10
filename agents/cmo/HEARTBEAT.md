# HEARTBEAT.md -- CMO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan from `$AGENT_HOME/notes/plan.md` (create if missing).
- Review open campaign briefs and content calendar for anything overdue or launching soon.
- Identify any seasonal deadline within the next 21 days — if one exists, confirm a brief is already issued.
- Record any blockers and your plan to resolve them.

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

## 6. Campaign and Delegation Workflow

**Creating campaign work:**
- For each active or upcoming campaign, verify a corresponding issue exists and is assigned to Content Creator with a `parentId` and `goalId` linking to goal 3 (brand & customer acquisition).
- If a Content Creator subtask is missing a brief, write it now and attach it as a comment or Drive link on the issue.
- If a subtask is `blocked`, comment with specific direction to unblock it or reassign it.

**Checking Content Creator progress:**
- `GET /api/companies/{companyId}/issues?assigneeAgentId={content-creator-id}&status=in_progress,blocked`
- Review stale in_progress items (no update in >24h). Comment with a check-in or escalate.

**Influencer pipeline:**
- Review `$AGENT_HOME/notes/influencer-pipeline.md` (or the Sheets tracker).
- Follow up on any outreach thread with no response in 48 hours.
- If seeding logistics involve COO (shipping product), raise a cross-team issue or comment.

**SEO:**
- Check whether any content briefs are waiting for Content Creator pickup. Confirm they are issued as issues.

## 7. Fact Extraction

- Extract durable facts from campaign performance, influencer conversations, and audience signals into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/plan.md` with today's decisions and next steps.

## 8. Exit

- Comment on any in_progress work before exiting — include current status, what was done, and next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never run a demand-generation campaign without confirming fulfillment readiness with COO.
- Never promise a launch date in external communications without CTO sign-off on the AI pipeline.
