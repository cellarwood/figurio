---
name: support-playbook
description: >
  Customer support procedures for Figurio — handling order status inquiries,
  AI custom figurine revision requests, print quality complaints, shipping delays,
  and refund/return processing. Covers both catalog and Prompt-to-Print orders.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - support
      - operations
---

# Support Playbook

Standard operating procedures for the Figurio customer support agent. All orders are prepaid via Stripe — no production begins without payment.

## Order Types

- **Catalog ("Ready to Print"):** Customer selects a pre-designed figurine, pays, enters production queue immediately.
- **Custom ("Prompt to Print"):** Customer submits a text prompt, AI generates a 3D model, a technician reviews printability, the customer approves a rendered preview, then pays and enters production.

---

## Order Status Inquiries

1. Ask the customer for their order ID or the email address used at checkout.
2. Look up the order and identify its current stage:
   - `awaiting_preview_approval` — custom order pending customer preview sign-off
   - `payment_pending` — Stripe two-stage hold awaiting capture after preview approval
   - `in_production` — sent to MCAE for printing
   - `shipped` — dispatched via Zásilkovna (CZ) or DHL (EU/world), tracking available
   - `delivered` — carrier confirms delivery
3. Share the current status in plain language and include the tracking number if available.
4. If the order has been `in_production` for more than 7 business days without shipping, flag to Head of Operations (see escalation-rules skill).

---

## AI Custom Figurine — Revision Requests

Customers may request changes before approving the rendered preview. After preview approval and payment, revisions are not available without extra charge.

### Pre-approval revisions (free)
- Customer has not yet approved the preview — revisions are standard.
- Collect specific change requests (pose, accessories, colors, scale).
- Log the revision request in the order notes and route to the technician queue.
- Inform the customer a new preview will be ready within 2 business days.
- Customers are entitled to **up to 2 free revision rounds**.

### Post-approval revision requests
- Politely explain that the model has entered production and changes are no longer possible for this order.
- If the customer is unhappy with the final result, handle as a quality complaint (see below).
- If they want a different version as a new order, offer to restart the Prompt-to-Print flow.

---

## Print Quality Complaints

1. Ask the customer to send photos clearly showing the defect.
2. Categorize the issue:
   - **Surface defects / color banding** — likely printing artifact; qualify for reprint or refund.
   - **Structural damage / breakage** — assess whether damage occurred pre-shipment or in transit.
   - **Wrong item shipped** — confirm against order details; expedite replacement immediately.
   - **Size mismatch** — verify against ordered size tier (Small ~8cm, Medium ~15cm, Large ~25cm).
3. For confirmed production defects (pre-shipment damage, color/surface issues, wrong item):
   - Offer a **free reprint** as the first resolution. Reprint ships within the standard production window.
   - If the customer declines reprint, issue a full refund (see Refund Processing below).
4. For transit damage:
   - Ask customer to retain packaging and photos.
   - File a carrier claim on their behalf (Zásilkovna or DHL depending on destination).
   - Offer reprint or refund while claim is in progress.
5. Escalate to Head of Operations if the same defect type appears in more than 2 orders in one week — may indicate a batch production issue at MCAE.

---

## Shipping Delays

### Zásilkovna (Czech Republic)
- Standard delivery: 1–3 business days after dispatch.
- Delay threshold: contact Zásilkovna support after 5 business days post-dispatch.

### DHL (EU / international)
- Standard delivery: 3–7 business days after dispatch (EU), 7–14 business days (world).
- Delay threshold: open a DHL inquiry after 10 business days (EU) or 18 business days (world).

### Response steps
1. Provide the customer with their tracking number and direct carrier tracking link.
2. If within the delay threshold, reassure the customer and ask them to wait.
3. If beyond the threshold, open a carrier inquiry and inform the customer. Keep them updated every 2 business days.
4. If the shipment is confirmed lost by the carrier, issue a full reprint or refund per customer preference. Escalate logistics claim to Head of Operations.

---

## Refund and Return Processing

### Eligibility
| Scenario | Resolution |
|---|---|
| Production defect confirmed | Full refund or free reprint |
| Wrong item shipped | Full refund or free reprint |
| Shipment confirmed lost | Full refund or free reprint |
| Customer dissatisfied (no defect) | Partial refund at agent discretion up to 50%; over 50% requires escalation |
| Custom order — post-approval, no defect | No refund; offer discount on next order |

### Process
1. Confirm eligibility using the table above.
2. For refunds within agent authority (up to 50% of order value, or full refund for defect/loss):
   - Log the refund decision in the order notes with reason code.
   - Process via Stripe refund on the original payment.
   - Notify the customer by email confirming the amount and expected processing time (5–10 business days).
3. For refunds above the agent authority threshold, escalate to CEO per the escalation-rules skill — do not issue until approved.
4. Returns: Figurio does not require physical returns for defective or lost items. Do not ask customers to ship back a defective print unless explicitly instructed by Head of Operations.

---

## Anti-patterns

- Do not promise specific reprint delivery dates — only quote standard production windows.
- Do not approve post-approval revisions on custom orders without checking with Head of Operations first.
- Do not issue refunds above the 50% threshold without CEO approval.
- Do not share internal MCAE contact details with customers.
