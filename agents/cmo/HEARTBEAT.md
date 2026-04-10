# HEARTBEAT.md -- CMO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/plan.md` -- review today's campaign priorities and deadlines.
- Check for any seasonal deadline within the next 14 days. If one exists, treat related tasks as P0.
- Note any blockers and what is needed to resolve them.

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

**Delegation check:**
- `GET /api/companies/{companyId}/issues?assigneeAgentId={content-creator-id}&status=todo,in_progress,blocked`
- If any Content Creator task is stale (no update in last cycle), comment with clarifying context or re-assign.
- If a Content Creator task is blocked on a creative brief that hasn't been written, write the brief first as a subtask and mark it complete before the Content Creator can proceed.

**Campaign calendar review:**
- Open the campaign calendar in Google Sheets (`gws sheets`).
- Identify any campaign with a deadline within 7 days. If assets are not approved, flag the issue and comment on it with the gap.
- Confirm that seasonal campaigns (Christmas, Valentine's Day, Halloween) have briefs created at least 6 weeks before the consumer-facing date.

**Content pipeline:**
- For any approved campaign brief without a Content Creator subtask, create one now with `parentId` and `goalId` set to Goal 3.
- Use `POST /api/issues` with `assigneeAgentId` pointing to the Content Creator.

**Influencer and outreach:**
- Check Gmail for replies to influencer outreach: `gws gmail list --label inbox`.
- Respond to any influencer or press inquiry within this heartbeat cycle.
- If a seeding package needs coordination with fulfillment, create a subtask assigned to the COO.

**SEO and content:**
- Verify that the active SEO content topics in the backlog are reflected as Content Creator tasks.
- If a new keyword cluster is ready to brief, create the brief doc in Drive and link it to the issue.

## 7. Fact Extraction

- Extract durable facts from this session into `$AGENT_HOME/notes/memory.md`.
  - Examples: new influencer contact details, brand guideline decisions, channel performance observations, seasonal deadline confirmations.
- Update `$AGENT_HOME/notes/plan.md` with any new priorities or resolved items.

## 8. Exit

- Comment on any `in_progress` issue before exiting, even if just a status line.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never create a Content Creator subtask without a creative brief attached or linked.
- Every campaign issue must reference Goal 3 via `goalId`.
- Do not approve your own content — log it for review and note it in the issue.
