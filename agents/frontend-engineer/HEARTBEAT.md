# HEARTBEAT.md -- Frontend Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review in-flight work: what is done, what is stuck, what needs a status update.
- Resolve any blockers you can unblock yourself before pulling new tasks.

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

**Before writing code:**
- Confirm the relevant API endpoint exists or is spec'd in the FastAPI backend. If not, file a dependency comment on the issue and move to another task.
- Check whether a shadcn-ui component already covers the need before building a custom one.

**While implementing:**
- Use TypeScript strict mode throughout — no `any`, no implicit returns on non-void functions.
- Follow the project's component pattern: named export, co-located `.test.tsx`, barrel re-export from the feature index.
- Apply Tailwind utility classes; do not write ad-hoc CSS unless Three.js canvas sizing requires it.
- Mobile-first: implement the smallest breakpoint first, then scale up.

**3D viewer and AI prompt interface:**
- Three.js scenes must dispose of geometries and materials on unmount to avoid memory leaks.
- AI generation status: use a polling interval or WebSocket subscription — never block the UI thread waiting for a result.
- Show a skeleton/placeholder in the 3D preview slot while the model is generating.

**Stripe checkout:**
- Load Stripe.js via `@stripe/stripe-js` (never self-host).
- Validate payment method availability (Apple Pay, Google Pay) using the Payment Request API before rendering those buttons.

**Testing:**
- Write or update Vitest tests for any new component or hook.
- For flows touching checkout or AI prompt submission, add or update a Playwright E2E spec.
- Use the Chrome DevTools MCP to inspect layout, console errors, and network requests during development and before marking an issue done.

**Before closing an issue:**
- Run `npm run test` and `npm run lint` -- both must pass.
- Run the relevant Playwright spec locally or in CI.
- Comment on the issue with: what was built, what tests were added, any known limitations.

## 7. Fact Extraction

- Extract durable facts (API contracts agreed, component decisions made, test patterns established) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with progress and next steps.

## 8. Exit

- Comment on any `in_progress` issue before exiting -- even a one-liner on where things stand.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never commit to git unless explicitly instructed.
