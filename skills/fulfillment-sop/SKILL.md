---
name: fulfillment-sop
description: "Write and operate Figurio's fulfillment SOPs for order release, packaging, shipping, tracking, exceptions, and support handoff."
---

# Figurio Fulfillment SOP

Use this skill when documenting or executing the end-to-end fulfillment process for Figurio: from paid order release through packaging, shipment, tracking updates, exception handling, and support follow-up.

## Core Rule

Fulfillment is a controlled operational sequence. Every order should have one owner, one current state, one next action, and one record that support and operations can trust.

## Standard Fulfillment Flow

1. Confirm the order is ready for fulfillment.
1. Validate production details, shipping address, and packaging requirements.
1. Send the release or handoff package to MCAE or the relevant fulfillment partner.
1. Track production progress and flag delays before the promised date slips.
1. Confirm the item is packed correctly and branded according to standard.
1. Obtain shipment confirmation and carrier tracking.
1. Update the order record and customer-facing status.
1. Watch for delivery exceptions, damage, or lost parcel signals.
1. Close the order only after delivery is confirmed or the issue path is resolved.

## Before Release

Check all of the following before a fulfillment handoff:

- Payment status is correct.
- Customer address is complete and usable.
- Product variant, size, and quantity match the order.
- Any approval gate is complete for custom work.
- Packaging instructions are present.
- Shipping method matches the service promise.
- No unresolved exception is attached to the order.

If any item is missing, stop the release and resolve it first.

## Production Handoff

- Use a consistent handoff record with order ID, item details, shipping destination, and special instructions.
- Keep the handoff concise, complete, and free of internal jargon the vendor does not need.
- Include only the information required to produce, package, and ship correctly.
- Record the time the handoff was sent and who approved release.
- If the vendor confirms receipt, store that confirmation in the shared record.

## Packaging SOP

- Use branded packaging that matches Figurio's premium positioning.
- Protect the figurine so transit damage is unlikely under the selected shipping method.
- Confirm inserts, labeling, and any gift or note materials before packing.
- Check that the final package matches the order variant and customer address.
- Treat packaging defects as real customer issues, not cosmetic annoyances.

## Shipping SOP

- Select the shipping method that matches the promise, not just the cheapest option.
- Attach tracking to the order record as soon as it exists.
- Trigger customer notification only after shipment is real and traceable.
- Keep carrier names, tracking numbers, and shipment dates in a shared system.
- If a shipment is delayed, stolen, returned, or damaged, classify the issue immediately and assign an owner.

## Exception Handling

Use these standard paths:

- Delayed production: notify operations, update promise status, and decide whether to wait, escalate, or re-promise.
- Address issue: pause shipment until the address is corrected and confirmed.
- Damage in transit: document the evidence, assess replacement or refund, and preserve the claim trail.
- Lost parcel: verify tracking history first, then escalate through the carrier and support path.
- Wrong item or packaging error: stop further shipments from the same batch until the cause is understood.

Do not improvise customer promises during an exception. Use the approved support path and record the decision.

## Support Handoff

When an issue reaches support, provide:

- Order ID
- Current state
- What happened
- What has already been checked
- Next operational step
- Whether a refund, reshipment, or customer update is pending

Support should never need to reconstruct the order from scattered messages.

## Service Standards

- Be factual, timely, and specific.
- Never mark an order complete before it is actually complete.
- Keep customer updates aligned with the real production and shipping state.
- Escalate anything that threatens the promised ship date or delivery experience.
- Record the decision trail for refunds, reships, and compensation.

## Daily Operating Routine

- Review the queue for orders at risk.
- Check for missing addresses, unresolved approvals, delayed handoffs, or shipping exceptions.
- Confirm that tracking exists for shipments that should already be in transit.
- Reconcile payment, production, and shipment states.
- Move any blocked order into an explicit exception state with an owner and next step.

## Output Format

When writing or updating a fulfillment SOP, include:

- Purpose
- Scope
- Trigger
- Preconditions
- Step-by-step procedure
- Exception paths
- Owner / handoff points
- Customer communication rule
- Recordkeeping requirement
- Escalation trigger

## Do Not

- Do not let orders move forward on assumptions.
- Do not bury exceptions in private messages.
- Do not close the loop without tracking or delivery evidence.
- Do not create a separate unofficial process for high-priority orders.
- Do not allow support, operations, and production to maintain conflicting versions of the truth.
