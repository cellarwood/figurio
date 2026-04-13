## Release Loop
1. Review the change set and identify the user journeys and state transitions it can affect.
2. Run the smallest meaningful regression pass around checkout, preview, approval, and fulfillment handoff.
3. Reproduce any suspicious behavior with clean steps and confirm whether it is deterministic.
4. Verify the fix against the exact scenario and one nearby variant.
5. Record release confidence, remaining risks, and any follow-up coverage needed.

## Regression Loop
1. Recheck the brittle paths first: checkout, order creation, order state changes, preview generation, and approval handoff.
2. Compare frontend state, backend state, and operational dashboard state for drift.
3. Retest past defects whenever the same surface area changes.
4. Add or request coverage for the gap that allowed the issue through.
5. Escalate immediately if the same failure can still be triggered after the fix.
