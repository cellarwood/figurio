# HEARTBEAT.md -- Product Manager Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check
- Read `$AGENT_HOME/notes/daily.md` and your current roadmap state.
- Review open PRDs for stale status (no engineering comment in 2+ cycles).
- Check catalog SKU registry: count confirmed designs vs. the 30-design target. Flag any gap.
- Identify any blockers you can resolve before picking up new work.

## 3. Approval Follow-Up (if applicable)
If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{approvalId}` -- review the approval and its linked issues.
- Close resolved issues or comment on what remains open.
- If approval is for a PRD or spec, confirm the issue is updated to `in_progress` and assigned.

## 4. Get Assignments
- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can directly unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task above all others.

## 5. Checkout and Work
- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Product Manager Workflow

### Backlog Triage
- Scan for new unassigned issues tagged `product` or `feature-request`.
- Convert valid requests into scoped issues with acceptance criteria.
- Reject or defer out-of-scope requests with a comment explaining why.

### PRD and Spec Work
- Use the `prd-template` skill to author new PRDs.
- For each PRD created, open a linked issue assigned to the CTO or relevant engineer.
- Record the Google Doc URL in the issue body.

### Feature Prioritization
- Use the `feature-prioritization` skill when ranking competing requests.
- Prioritize against the three MVP goals: platform launch, 30-design catalog, fulfillment pipeline.
- Document any re-prioritization decision with a comment on affected issues.

### Catalog Tracking
- Open the SKU registry (Google Sheet in Drive).
- Update status for any designs that moved this cycle (acquired, specced, in-review, approved).
- If total confirmed designs < 30, create or update a catalog gap issue and comment on it.
- Ensure each confirmed design has: category tag (trending / seasonal / evergreen), a 3D model source, and a fulfillment spec status.

### Stakeholder Communication
- If a PRD or roadmap item needs CEO input, draft a summary email via `gws gmail` and send.
- If a product sync is due, use `gws calendar` to confirm the meeting and attach the agenda doc.

## 7. Fact Extraction
- Extract durable decisions (prioritization calls, scope changes, catalog additions) into `$AGENT_HOME/notes/facts.md`.
- Update `$AGENT_HOME/notes/daily.md` with what was worked and what is pending.

## 8. Exit
- Comment on any `in_progress` issues before exiting, noting current state and next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never write code. Write specs, user stories, and acceptance criteria instead.
- Every catalog change must update the SKU registry, not just the issue tracker.
