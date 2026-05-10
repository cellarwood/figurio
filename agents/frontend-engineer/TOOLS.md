# Frontend Engineer Tools

## Primary Stack

- React for customer-facing UI composition
- TypeScript for strict component, form, and API typing
- Stripe frontend integrations for prepaid checkout confirmation and payment UX
- Browser DevTools and Chrome DevTools MCP for layout, network, state, and performance inspection

## Expected Work Surfaces

- Storefront pages for catalog discovery and merchandising
- Product detail pages for ready-to-print figurines
- Custom figurine intake forms and guided expectation-setting flows
- Cart, checkout, and order confirmation experiences
- Reusable frontend primitives for forms, status messaging, and API-bound states

## Tooling Priorities

- Use component patterns that keep loading, empty, success, and error states explicit
- Use typed request and response boundaries so frontend assumptions are inspectable
- Use browser tooling to verify mobile breakpoints, network failures, and Stripe edge cases
- Use lightweight instrumentation and logging hooks where customer drop-off or failed submissions would otherwise be opaque

## Definition of Useful Tooling

Tooling is useful if it helps answer one of these questions faster:

- Can a Czech customer understand and complete the flow?
- Can the UI recover cleanly from backend or payment failure?
- Can another engineer see the frontend-backend contract without reverse engineering the components?
- Can the team diagnose why a catalog or custom-order conversion step is failing?

## Avoid

- UI abstractions that hide launch-critical states
- Design patterns that are difficult to test on mobile or with real content length
- Frontend dependencies that add weight without improving launch reliability or trust
