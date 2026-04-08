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

## 6. Frontend Engineering Workflow
- Before writing a new component: check if a similar component already exists in the component library.
- Use shadcn-ui and Radix UI primitives as the foundation — avoid building from scratch.
- Write TypeScript in strict mode. No `any` types, no `@ts-ignore` without a comment explaining why.
- Test components with unit tests. Test user flows with integration tests.
- After building a page or component, check for visual regressions against the existing UI.
- Review component library consistency: ensure new components follow existing patterns (naming, props API, styling approach).
- Test responsive layouts at mobile (375px), tablet (768px), and desktop (1280px+) breakpoints.
- For 3D viewer work: test model loading performance, check progressive rendering, verify camera controls work on touch devices.
- For checkout flow changes: test the full flow end-to-end with Stripe test mode.
- Run accessibility checks (axe-core or similar) on new pages and components.
- Run `npm run lint` and `npm run typecheck` before marking work complete.

## 7. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 8. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
