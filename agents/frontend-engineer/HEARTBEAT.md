# HEARTBEAT.md -- Frontend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan and in-flight work.
- Review open sub-issues you created in a prior session — are any unblocked?
- Record any context updates before starting new work.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Frontend Engineering Workflow

Before writing any component:
- Confirm design spec or mockup is available. If not, file a `design-review` sub-issue and stub the component with placeholder props.
- Verify the API shape (request/response types) is documented or agreed. If not, write against a typed stub and note the assumption in a code comment.

While building:
- Run `npm run dev` via dev-tools to verify the component renders in context.
- Use Chrome DevTools MCP (`mcp__chrome`) to inspect layout, check computed styles, and audit console errors on the running app.
- Use `mcp__plugin_web-design-plugin_webdesign-playwright` or `mcp__plugin_media-plugin_media-playwright` for visual regression checks or screenshot capture.
- Run the Vite build (`npm run build`) before marking any issue `done` — zero TypeScript errors, zero build warnings.
- Run `npm run test` (Vitest) and confirm new components have coverage.

Accessibility gate (required before closing any UI issue):
- Keyboard navigation works end-to-end for the new surface.
- All interactive elements have visible focus indicators.
- Images have meaningful `alt` text; decorative images use `alt=""`.
- Color contrast meets WCAG 2.1 AA (4.5:1 for normal text, 3:1 for large/UI).
- Use Chrome DevTools accessibility panel or axe to verify — no critical violations.

After building:
- Comment on the issue: what was built, what files changed, any known gaps.
- Update `$AGENT_HOME/notes/daily.md` with progress.

## 7. Fact Extraction

- Extract durable facts (API shapes confirmed, design decisions locked, third-party integration quirks) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with end-of-session status.

## 8. Exit

- Comment on any in_progress issue before exiting with current status and next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave TypeScript `any` in committed code — use `unknown` and narrow it.
- Every Stripe-related code path must handle both success and error states explicitly.
