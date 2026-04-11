# HEARTBEAT.md -- Frontend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan and open threads.
- Review in-flight work: any unresolved visual bugs, blocked API dependencies, or pending QA items.
- Update daily notes with current status before proceeding.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Retrieve the approval record and its linked issues.
- If the approval was accepted, merge or apply the approved changes and close the issue.
- If rejected, read the rejection comment, update the implementation accordingly, and resubmit or comment with your plan.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task above all others.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Frontend Workflow

For each task:

1. Identify the page or component scope. Check whether a related shadcn-ui component already exists in the design system before building from scratch.
2. Implement the feature or fix in TypeScript. Use Tailwind utility classes; avoid inline styles.
3. Ensure all interactive elements are keyboard-accessible and have appropriate ARIA roles/labels (WCAG 2.1 AA).
4. Visual verify using Chrome DevTools MCP (`mcp__chrome`) or Playwright (`mcp__plugin_web-design-plugin_webdesign-playwright`) -- screenshot at minimum mobile (375px) and desktop (1280px) breakpoints.
5. If the task involves Stripe Elements (checkout, payment method updates), verify the payment flow in Stripe test mode before marking done.
6. If the task involves the 3D model viewer, confirm model loads, rotates, and renders correctly in Chrome.
7. If you need a backend endpoint that does not yet exist, comment on the issue with the exact route, method, request body, and expected response shape. Set status to `blocked` and note the dependency.
8. Mark task `done` and post a summary comment with a screenshot link or description of what changed.

## 7. Fact Extraction

- Extract durable facts (API shapes discovered, design decisions made, component naming conventions) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with what was completed and what is pending.

## 8. Exit

- Comment on any `in_progress` task before exiting, even if just a brief status note.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never commit secrets, API keys, or .env files to source.
- Stripe keys are always read from environment variables -- never hardcoded.
