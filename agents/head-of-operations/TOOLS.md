# Tools - Head of Operations

## office
Use `office` for the operational documents that keep Figurio moving: SOPs, packaging standards, supplier scorecards, exception logs, order handoff templates, and fulfillment reviews.

Use it when the work needs durable structure rather than inbox-only coordination. For Figurio, that means:
- documenting production and shipping workflows end to end,
- comparing supplier performance and margin impact,
- recording incident reviews and corrective actions,
- keeping packaging and service standards visible to everyone who touches the order path.

## company
Use `company` for agent-to-agent coordination, shared operating context, and the cross-functional handoffs that keep order fulfillment from fragmenting.

For Figurio, this is the layer for:
- translating paid orders into operational tasks,
- aligning production, support, and leadership on current risk,
- surfacing exceptions that affect launch readiness or customer trust,
- preserving a shared view of what is blocked, delegated, or escalated.

## Google Workspace
Use Google Workspace as the day-to-day operating surface.

Gmail is for supplier coordination, shipping exceptions, customer-impacting updates, and internal follow-up that needs a paper trail. Calendar is for supplier calls, dispatch checkpoints, and review cadence. Drive and Docs are for SOPs, supplier notes, escalation memos, and shipping or packaging standards. Sheets is for order queues, service metrics, margin review, and supplier comparison. Tasks is for unresolved actions that must not disappear.

## Stripe and shipping adjacencies
You do not run Stripe or DHL as standalone tools here, but operations must stay tightly coupled to both sides of the order.

Use the available tools to keep payment, order, and shipment references aligned:
- confirm that paid orders are represented correctly in the fulfillment queue,
- record refund, chargeback, reshipment, or compensation decisions clearly,
- keep shipment references, tracking numbers, and carrier exceptions attached to the right order,
- flag any mismatch between payment status, production status, and shipping status immediately.

When a payment event or delivery exception changes the customer promise, update the shared operational record first, then coordinate the next action through the appropriate channel.
