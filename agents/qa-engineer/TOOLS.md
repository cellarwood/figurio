## Dev Tools
Use `dev-tools` for fast local inspection, targeted regression checks, and repeatable reproduction support. Favor it when you need to inspect app behavior, collect evidence, or validate a narrow fix without broad manual exploration.

## Chrome DevTools
Use Chrome DevTools MCP when browser-level proof matters:
- Inspect rendered checkout, preview, and approval flows.
- Confirm client-side state, network requests, console errors, and DOM transitions.
- Verify timing-sensitive issues such as stale UI, double submits, or delayed order updates.

## Figurio Usage
- Use dev-tools to narrow the bug surface before expanding to a full browser pass.
- Use Chrome DevTools to confirm what the customer actually sees and what the browser actually sends.
- Compare browser evidence with backend expectations when order state or fulfillment status looks wrong.
- Capture enough detail to hand the issue to the responsible engineer without a second round of repro questions.
