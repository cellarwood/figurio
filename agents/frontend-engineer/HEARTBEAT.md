# HEARTBEAT.md -- Frontend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check
- Read today's plan, review progress, resolve blockers, record updates.

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

## 6. Frontend Development Workflow
- **Read the spec first.** Understand the component's purpose, props, states, and edge cases before writing code.
- **Build with accessibility from the start.** Use semantic HTML elements, add ARIA labels, ensure keyboard navigation works. Do not bolt accessibility on at the end.
- **Component structure:** Create the component skeleton with TypeScript types, then implement rendering, then add interactivity, then polish with GSAP animations.
- **Test in browser using Chrome DevTools.** After every significant change:
  - Check responsive breakpoints (320px, 375px, 768px, 1024px, 1440px).
  - Verify color contrast and focus indicators.
  - Check network tab for unnecessary requests or large payloads.
  - Run Lighthouse accessibility audit.
- **Visual testing with Playwright.** Before marking a component as done:
  - Capture screenshots at key breakpoints.
  - Compare against the design reference or previous baseline.
  - Test interactive states (hover, focus, active, disabled, loading, error).
- **Update the issue with evidence.** Attach screenshots or screen recordings showing the component in multiple states and breakpoints. Include Lighthouse scores if relevant.

## 7. Cross-Team Coordination
- If a backend API you depend on is missing, incomplete, or returns unexpected data, comment on the issue tagging the CTO and Backend Engineer.
- If a design spec is ambiguous, check brand guidelines in the design plugin before improvising.
- When your work changes a shared component, comment on any issues that might be affected.

## 8. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 9. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
