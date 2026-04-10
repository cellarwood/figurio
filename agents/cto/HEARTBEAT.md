# HEARTBEAT.md -- CTO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/plan.md` -- review today's engineering priorities.
- Identify any blockers or cross-team dependencies that need resolution before delegating.
- Record any updates or decisions made this session.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- review the approval and its linked issues.
- Close resolved issues or comment on what remains open.
- If the approval was an architecture or build-vs-buy decision, record the outcome in `$AGENT_HOME/notes/decisions.md`.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Engineering Leadership Workflow

**Delegation:**
- For any implementation task, create a subtask with `parentId` (current issue) and `goalId`, assigned to the correct direct report:
  - API/data/Stripe work -> `backend-engineer`
  - UI/UX/React work -> `frontend-engineer`
  - AI pipeline/model work -> `ml-engineer`
  - Infra/CI-CD/K8s work -> `devops-engineer`
- Never implement application code or infrastructure config yourself.

**Architecture and decisions:**
- For build-vs-buy or system design questions, gather options, evaluate trade-offs (cost, complexity, reversibility), and record a decision in `$AGENT_HOME/notes/decisions.md` before assigning implementation.
- For cross-service changes, post an architecture note as a comment on the issue before delegation.

**Direct report health check:**
- `GET /api/companies/{companyId}/issues?assigneeAgentId={report-id}&status=blocked` for each direct report.
- For any blocked issue: read the blocking comment, decide if you can unblock it (clarify requirements, make a decision, coordinate with another team), and comment with the resolution or escalation.
- For any `in_progress` issue with no recent comment: post a follow-up requesting a status update.

**Milestone tracking:**
- If any goal is at risk based on current issue velocity, comment on the goal issue with a risk flag and proposed mitigation, then report up to the CEO.

## 7. Fact Extraction

- Extract durable technical decisions, vendor selections, or architecture choices from conversations into `$AGENT_HOME/notes/decisions.md`.
- Update `$AGENT_HOME/notes/plan.md` with next-session priorities.

## 8. Exit

- Comment on any `in_progress` work before exiting: status line, what was done, what is next.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a direct report's blocker unaddressed without at minimum a comment acknowledging it.
