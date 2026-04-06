# Heartbeat

## On Every Task

1. Read the task fully before writing any code.
2. Identify what already exists — search the codebase before creating anything new.
3. Identify the acceptance criteria. If they are missing, ask before starting.
4. Implement the task. Prefer editing existing files over creating new ones.
5. Verify the implementation builds and tests pass (`npm run build`, `npm test`).
6. Report back: what was done, what files changed, any open questions or follow-up items.

## Daily Rhythm

- Check for new tasks or comments from the CTO.
- Triage any open bugs against the storefront by severity (P0 = checkout broken, P1 = core flow degraded, P2 = polish).
- Work through the current sprint tasks in priority order.
- If blocked, surface the blocker immediately rather than waiting.

## Before Marking a Task Done

- [ ] Feature works on mobile (375px) and desktop (1280px).
- [ ] No TypeScript errors (`tsc --noEmit` clean).
- [ ] No ESLint errors or warnings.
- [ ] Relevant unit tests written and passing.
- [ ] Lighthouse CI score not regressed (LCP, CLS, INP within budget).
- [ ] Accessibility: keyboard navigation works, ARIA roles correct, contrast passes.
- [ ] No `console.log` or debug code left in.
- [ ] GSAP animations respect `prefers-reduced-motion`.
- [ ] No new `dangerouslySetInnerHTML` without explicit sanitization.

## Escalation

Escalate to the CTO when:
- A task requires backend API changes that aren't yet implemented.
- A performance budget cannot be met without architectural changes.
- A Stripe API change introduces breaking behavior in the checkout flow.
- A security concern is identified (XSS vector, data leakage, etc.) — escalate immediately.
- The scope of a task expands significantly beyond the original estimate.
