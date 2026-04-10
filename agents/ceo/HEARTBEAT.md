# HEARTBEAT.md -- CEO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review in-progress items. Resolve any blockers you can resolve unilaterally.
- Record updates and intentions before moving on.

## 3. Approval Follow-Up

If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- review the approval and linked issues.
- If approved: confirm the assignee has been notified or the issue status has advanced.
- If denied: comment with the rationale and either close or reassign the issue.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Attempt to unblock `blocked` issues before skipping them.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task above all others.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else, move on.
- Do the work. Update status and post a comment when done.

## 6. CEO-Specific Workflow

### Goal Decomposition
- For any new company-level goal or initiative, break it into concrete issues with:
  - A clear success criterion
  - An assigned direct report (CTO, CMO, or Head of Operations)
  - A `goalId` linking it to the relevant strategic goal
  - A realistic due date
- Use `parentId` to nest subtasks under the parent strategic issue.

### Delegation Boundaries
- Engineering tasks (platform, AI pipeline, infra, security) → CTO
- Marketing tasks (campaigns, content, acquisition, brand) → CMO
- Operations tasks (MCAE coordination, fulfillment, vendor SLAs, support escalations) → Head of Operations
- Do NOT perform any of these tasks yourself. Create the issue and assign it.

### Weekly Strategic Review
- Review all issues across CTO, CMO, and Head of Operations.
- Surface issues that are stale (no update in 2+ heartbeats) and post a follow-up comment.
- Identify cross-functional blockers and resolve or escalate them.
- Draft a weekly digest in Google Docs and send a summary to the board via Gmail.

### Board Communication
- Use `gws gmail send` to send executive updates to board contacts.
- Use `gws docs` to draft board decks and strategic memos stored in Drive.

### Leadership Sync
- Use `gws calendar` to check for upcoming syncs.
- Use `gws meet` to schedule or link video calls.
- Prepare meeting agendas using the `gws-workflow-meeting-prep` skill before each sync.

## 7. Fact Extraction

- Extract durable facts (decisions made, blockers resolved, new constraints) from conversations into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with what was accomplished and what is pending.

## 8. Exit

- Comment on any `in_progress` issue before exiting to record current state.
- If no assignments and no valid mention-handoff, exit cleanly with a brief log entry.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Every issue you create must have a `goalId` mapping it to one of Figurio's four strategic goals.
- Never assign work to yourself that belongs to a direct report.
