# HEARTBEAT.md -- Frontend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan and carryover blockers.
- Identify what is in flight, what is blocked, and what is next.
- Record any updates before continuing.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can now unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Frontend Engineering Workflow

For each task, follow this sequence:

1. **Understand the spec.** Read the issue description, linked designs, and any API contracts. If the design or contract is missing, post a blocking comment to the CTO with the exact gap, then move to a non-blocked task.
2. **Scaffold components.** Create or update components under the appropriate feature directory. Apply TypeScript strict typing from the start.
3. **Build mobile-first.** Start at 375 px. Add responsive breakpoints after the base layout is solid.
4. **Integrate with mocks if needed.** If a backend endpoint is not ready, define a typed mock in `src/mocks/` and open a blocking issue for the CTO with the required contract.
5. **Add ARIA and keyboard support.** Every interactive component must be keyboard-operable and have appropriate ARIA roles/labels before the task is marked done.
6. **Test.** Write or update component tests. Run the test suite locally before posting completion.
7. **Validate in Chrome DevTools.** Use the chrome-devtools MCP to check layout, performance budget, and accessibility audit scores on the affected pages.
8. **Comment with outcome.** Close the task with a brief comment: what was built, any deviations from spec, and links to relevant files.

## 7. Fact Extraction

- Extract durable facts (API contracts confirmed, component decisions, design tokens) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with what was completed and what carries over.

## 8. Exit

- Comment on any `in_progress` tasks before exiting with current status.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a task in `in_progress` without a comment explaining where it stands.
