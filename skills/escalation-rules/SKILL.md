---
name: escalation-rules
description: >
  Escalation paths for Figurio customer support issues — technical bugs and platform
  errors to CTO, order and shipping problems to Head of Operations, refund requests
  over the agent authority threshold to CEO, and product feedback to Product Manager.
allowed-tools:
  - Read
metadata:
  paperclip:
    tags:
      - support
      - operations
---

# Escalation Rules

Defines when and to whom Figurio customer support issues must be escalated. When in doubt, escalate — do not attempt to resolve issues outside your authority.

---

## Escalation Matrix

| Issue Type | Escalate To | Trigger |
|---|---|---|
| Platform / technical bug | CTO | Customer cannot complete checkout, payment errors, AI pipeline failures, broken preview rendering |
| Order or production problem | Head of Operations | Orders stuck in production >7 business days, batch quality defects (2+ orders same issue), MCAE production errors, wrong items shipped in bulk |
| Shipping / logistics claim | Head of Operations | Confirmed lost shipment, carrier dispute, customs hold |
| Refund above threshold | CEO | Any refund or credit exceeding 50% of order value, or any refund on a disputed Stripe charge (chargeback) |
| Product feedback / feature requests | Product Manager | Recurring customer requests for new figurine types, catalog gaps, AI prompt limitations, site UX friction |
| Legal / IP complaint | CEO | Any claim of copyright or trademark infringement against a catalog design |

---

## CTO — Technical Bugs and Platform Errors

Escalate to the CTO when a customer reports (or you observe) a platform malfunction:

- Stripe checkout session not loading or payment rejected without clear reason
- AI Prompt-to-Print pipeline error: model generation failed, preview not rendering, stuck in processing
- Order status not updating after confirmed payment
- Account login issues or order history not visible
- Any error that affects multiple customers simultaneously

**How to escalate:**
1. Collect the customer's order ID, account email, browser/device info, and a description or screenshot of the error.
2. Post to the CTO with the above details. Tag as `[BUG]` in the subject line.
3. Inform the customer that the technical team has been notified and provide a 24-hour follow-up commitment.

---

## Head of Operations — Order and Shipping Problems

Escalate to Head of Operations for fulfillment and logistics issues:

- Order has been in `in_production` status for more than 7 business days without a shipping update
- Same print defect type reported on 2 or more orders in the same week (potential MCAE batch issue)
- Confirmed shipment lost by Zásilkovna or DHL — requires carrier claim filing
- Shipment held at customs (EU cross-border or international DHL)
- Request to authorize a post-approval revision on a custom order
- Bulk or wholesale order inquiries

**How to escalate:**
1. Provide the order ID(s), carrier tracking number (if applicable), and a summary of customer communication so far.
2. Flag urgency level: standard (within 1 business day) or urgent (same day, e.g., confirmed lost shipment).
3. Keep the customer informed — tell them operations has been looped in and you will follow up within 1 business day.

---

## CEO — High-Value Refunds and Chargebacks

Escalate to the CEO before issuing any refund or credit in these situations:

- Refund amount exceeds **50% of the original order value**
- Customer has filed a Stripe chargeback or payment dispute — do NOT issue a manual refund while a chargeback is open; route to CEO immediately
- Customer threatening legal action or public escalation (social media, consumer protection authority)
- Any goodwill credit offer above 500 CZK

**How to escalate:**
1. Do not communicate a refund decision to the customer until CEO approval is received.
2. Provide a summary: order ID, order value, refund amount requested, reason, and history of prior resolutions attempted.
3. Tell the customer their request is under review and you will respond within 1 business day.

---

## Product Manager — Feedback and Feature Requests

Escalate to the Product Manager (do not block the customer conversation on this):

- Customer requests a figurine category or style not in the catalog (e.g., "do you have wedding cake toppers?")
- Recurring AI prompt limitations: customers frequently unable to get desired results from Prompt-to-Print
- UX friction reported by multiple customers (e.g., confusing preview approval step, size tier descriptions unclear)
- Requests for product customization options not currently offered (e.g., custom bases, paint finishes)

**How to escalate:**
1. Log the feedback as a product note — include the customer's exact phrasing where possible.
2. Batch similar feedback and send a weekly digest to the Product Manager rather than escalating each instance individually.
3. Thank the customer for the suggestion and let them know it has been passed to the product team.

---

## Anti-patterns

- Do not escalate every unhappy customer to the CEO — exhaust standard resolution steps (reprint, partial refund within authority) first.
- Do not CC multiple escalation targets on the same issue — pick the single correct owner from the matrix above.
- Do not delay informing the customer while waiting for an escalation response — set a clear follow-up commitment.
- Do not share internal escalation threads or names with customers — communicate outcomes, not internal processes.
