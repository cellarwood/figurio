# HEARTBEAT.md -- Frontend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/plan.md` for today's plan.
- Review progress against open tasks; identify blockers.
- Update plan and daily notes before proceeding.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- `GET /api/approvals/{PAPERCLIP_APPROVAL_ID}` -- review the approval and linked issues.
- Close resolved issues or comment on what remains open.
- If a design review was approved, proceed to implement; if rejected, read feedback and revise.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can now unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Frontend Workflow

For each UI task:

1. **Understand the requirement** -- read the issue description, linked designs, and relevant API contracts in `/docs` or comments.
2. **Identify the component surface** -- which page, component, or flow is affected? Check `/frontend/src` for existing components before creating new ones.
3. **Implement** -- use shadcn-ui primitives and Tailwind utilities. Keep components composable and co-locate styles.
4. **Accessibility check** -- run `axe` or equivalent within Chrome DevTools MCP. All interactive elements must have labels, focus states, and correct ARIA roles.
5. **Responsive check** -- test at 320 px, 768 px, and 1280 px using Chrome DevTools device emulation via the `chrome` MCP.
6. **Visual review** -- use `media-playwright` or `webdesign-playwright` to capture screenshots for comparison against design specs.
7. **Write or update tests** -- Vitest unit tests for logic/hooks; Playwright e2e for critical flows (checkout, prompt submission).
8. **Stripe flows** -- always test checkout in Stripe test mode. Verify error states (declined card, network failure) render correctly.
9. **Three.js / 3D preview** -- after changes to the model viewer, confirm loading states, error states, and orbit controls work on both desktop and touch.
10. **Comment and close** -- post a summary comment with screenshot links (if visual), test results summary, and any follow-up issues created.

## 7. Fact Extraction

- Extract durable facts from conversations into `$AGENT_HOME/memory/`.
- Record design decisions, API contract details, and accessibility findings in daily notes.
- Update component inventory notes when new shadcn-ui components are introduced.

## 8. Exit

- Comment on any in_progress tasks before exiting — include current state, what was done, and what remains.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave the checkout flow or payment components in a broken state between sessions — note any partial changes explicitly.
- Do not merge or deploy — GitHub Actions handles CI/CD. Commit to a branch and open a PR if the task requires it.
