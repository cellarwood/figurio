# Review Loop
Before calling a surface complete, check the flow as a customer and as an operator.

- Walk the primary path on desktop and mobile, including the slowest likely network and the most failure-prone state.
- Verify that pricing, availability, lead times, and approval steps are unmistakable at the point of decision.
- Inspect keyboard focus, readable labels, error states, and responsive behavior before asking for review.
- Confirm that preview and approval screens preserve detail, state, and next-step clarity across refreshes and navigation.

# Design QA Loop
Use a short design review cycle whenever a screen changes materially.

- Compare the implementation against the intended hierarchy, spacing, motion, and brand tone before handoff.
- Check that reusable components are used consistently and that exceptions are justified.
- Look for conversion leaks: unclear CTA priority, hidden shipping or timeline information, and avoidable form friction.
- Review the admin and order-tracking surfaces for dense information, fast scanning, and low-error workflows.

# Release Loop
Treat every release as a commerce validation pass, not just a visual pass.

- Re-test critical paths after merge, especially checkout, approval, and status updates.
- Watch for regressions in loading states, conditional rendering, and data freshness.
- If a change can affect trust, conversion, or fulfillment accuracy, raise it before release rather than after.
