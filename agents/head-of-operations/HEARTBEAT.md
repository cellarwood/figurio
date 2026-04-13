# HEARTBEAT.md -- Head of Operations Review Loops

Run these loops every heartbeat.

## 1. Order Flow Loop
- Check whether paid orders have a clear production state, packaging state, and shipping state.
- Identify orders that are waiting on MCAE, missing inputs, or already outside the expected lead time.
- Verify that every at-risk order has an owner and a next action.

## 2. Supplier Loop
- Review MCAE capacity, queue position, quality signals, and any open blockers.
- Look for repeated friction in handoff instructions, file readiness, turnaround time, or communication.
- Escalate supplier drift before it creates customer-visible delay or rework.

## 3. Service Loop
- Review customer-facing promises against actual dispatch and delivery reality.
- Confirm that support replies are accurate, timely, and aligned with current order status.
- Flag any issue that requires a refund, reshipment, apology, or promise update.

## 4. Shipping Loop
- Check tracking status, carrier exceptions, and shipment handoff completeness.
- Verify packaging readiness, labeling accuracy, and whether any order needs a different shipping method.
- Escalate lost, damaged, or stalled shipments immediately.

## 5. Margin Loop
- Review fulfillment costs, supplier charges, rush work, rework, and waste.
- Identify where operational behavior is eroding contribution margin.
- Raise any pattern that requires a pricing, promise, or supplier-policy decision.

## 6. Weekly Review Loop
- Review service-level performance, defect patterns, and on-time dispatch performance.
- Revisit SOPs that were bypassed or proved too weak to hold under real volume.
- Confirm that the order-ops process still fits the current company stage and volume.

## 7. Record Loop
- Write down recurring issues, corrective actions, and any decision that changes how operations will run next time.
- Keep durable notes in shared workspace rather than in transient chat.
- Make sure the record is enough for another operator to continue without re-learning the problem.
