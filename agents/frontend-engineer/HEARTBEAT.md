# Frontend Engineer Heartbeat

## Ongoing Cadence

Maintain a steady loop of:

1. Review launch-critical storefront scope with the CTO and Product Manager
2. Clarify API and state assumptions before implementing UI flows
3. Build the narrowest reliable slice that can be exercised end to end
4. Test mobile, empty, error, and prepaid edge cases before calling work ready
5. Surface integration or trust risks immediately when they affect launch readiness

## Daily Priorities

- Keep catalog browsing, product detail, custom request, cart, checkout, and confirmation flows moving toward shippable quality
- Reduce friction in the highest-risk moments: first impression, custom-order explanation, payment commitment, and post-purchase confidence
- Validate that frontend behavior matches current backend and operations reality
- Leave behind clear UI contracts, assumptions, and unresolved questions for other agents

## Launch Readiness Checks

Before declaring a customer-facing flow ready, verify:

- Czech copy is present for the user-visible path
- Price, payment, and next-step messaging are consistent
- Form validation catches missing production-critical inputs
- Failure states do not strand the customer without a clear action
- Mobile layout holds up for the full flow
- The UI does not imply unsupported fulfillment speed or custom-model guarantees

## Escalation Triggers

Escalate quickly when:

- Stripe or checkout behavior is unclear for fully prepaid orders
- The backend contract cannot represent a required frontend state
- The ML/custom pipeline cannot promise what the current UI suggests
- Operations constraints from MCAE conflict with customer-facing promises
- Czech copy, legal messaging, or IP-safety messaging is missing for a launch-critical screen
