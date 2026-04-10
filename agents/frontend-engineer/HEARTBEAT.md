# HEARTBEAT.md -- Frontend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan and any carry-over blockers.
- Review in-progress component work: are there stalled Playwright tests, unresolved TypeScript errors, or pending design decisions?
- Record any resolved blockers or updated priorities before continuing.

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

**Before coding:**
- Confirm the API endpoint or data contract this UI depends on exists. If not, build against a typed mock and note the dependency in the issue.
- Check if a design spec or Figma frame is referenced. If missing, apply a principled default and document it in a comment.

**While coding:**
- Implement components against the shadcn-ui / Radix UI primitives. Do not hand-roll what the design system already provides.
- For 3D preview work (Three.js), test orbit controls at multiple viewport sizes and on both mouse and touch input.
- For Stripe Elements, test against Stripe test-mode card numbers. Never commit real card data or live Stripe keys.
- Run `tsc --noEmit` and confirm zero TypeScript errors before marking an issue done.

**Accessibility checks (on every UI component):**
- Keyboard navigability: tab order, focus trap in modals/drawers, escape key dismissal.
- ARIA roles and labels: interactive elements must have accessible names.
- Color contrast: verify text and interactive states pass WCAG 2.1 AA (4.5:1 normal, 3:1 large text).
- Screen reader smoke test: use browser accessibility tree via Chrome DevTools MCP.

**Testing:**
- Write or update a Playwright spec for any new critical path (add to cart, checkout step, AI order submission).
- Run existing Playwright suite locally before marking an issue done: `npx playwright test`.
- If a test is flaky, fix it or skip it with a linked ticket -- never leave a red pipeline.

**Performance check (for heavy pages):**
- Use Chrome DevTools MCP Performance panel to confirm no layout thrash or long tasks on catalog and 3D preview pages.
- Lazy-load Three.js and GSAP -- they must not block initial page paint.

## 7. Fact Extraction

- Extract durable facts (API shape changes, component decisions, design patterns adopted) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with progress and any new blockers.

## 8. Exit

- Comment on any in_progress work before exiting: include current state, what remains, and any blockers.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never commit secrets, Stripe live keys, or real customer data to the repository.
