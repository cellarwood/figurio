# HEARTBEAT.md -- Frontend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review in-progress work from last session.
- Identify any pending blockers (missing API endpoints, missing design assets).
- Record any updates or plan changes.

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

## 6. Frontend Engineering Workflow

### Component and Feature Work
- Identify which page or component the issue targets (catalog, checkout, Prompt to Print, account, landing).
- Check for an existing shadcn-ui primitive or shared component before writing new ones.
- Implement the feature in TypeScript with strict mode; no `any` without a documented reason.
- Apply Tailwind utility classes from the project theme; do not introduce ad-hoc color or spacing values.
- For animated sections, use GSAP; do not use raw CSS transitions for complex sequences.
- For 3D preview work, scope changes to the Three.js component and verify performance in Chrome DevTools.

### Accessibility Gate (run before marking any UI issue done)
- Confirm keyboard navigability: tab order, visible focus ring, no keyboard traps.
- Confirm ARIA roles and labels are correct on interactive elements.
- Run a contrast check on any new color usage — must pass WCAG 2.1 AA (4.5:1 normal text, 3:1 large text).
- Use Chrome DevTools MCP to inspect the accessibility tree if anything is unclear.

### Visual and Regression Testing
- Run Playwright visual tests for any page modified.
- If a visual diff is flagged, investigate before accepting it -- do not blindly update snapshots.
- Use the media-playwright tool for automated screenshot comparison when needed.
- Use Chrome DevTools MCP (`mcp__chrome`) for live page inspection, performance profiling, and layout debugging.

### API Dependency Handling
- If a backend endpoint is not yet available, create a local mock (`src/mocks/`) and note the dependency.
- Comment on the issue with the expected API contract so the Backend Engineer can align.

### SEO and Metadata (for landing/marketing pages)
- Verify `<title>`, `<meta name="description">`, Open Graph tags, and canonical URL are set.
- Confirm structured data (JSON-LD) is present on product detail pages.
- Check that images have descriptive `alt` text.

## 7. Fact Extraction

- Extract durable facts (API contracts discovered, design decisions made, component patterns established) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with a brief end-of-session summary.

## 8. Exit

- Comment on any `in_progress` issue before exiting with current state and next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Do not mark an issue done if Playwright visual tests or accessibility checks are outstanding.
- Do not introduce new npm dependencies without a comment noting why the existing stack is insufficient.
