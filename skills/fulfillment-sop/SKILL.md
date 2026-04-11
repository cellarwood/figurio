---
name: fulfillment-sop
description: >
  Standard operating procedure for end-to-end order fulfillment at Figurio. Covers order
  capture from Stripe, print file handoff to MCAE, quality inspection, branded packaging,
  carrier dispatch via Zásilkovna (Czech Republic) and DHL (EU and international), and
  customer-facing tracking updates.
allowed-tools:
  - Read
  - Write
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - fulfillment
      - shipping
---

# Fulfillment SOP

## When to Use

Use this skill whenever processing or auditing an order from payment through delivery. It is the
authoritative procedure for the Head of Operations and any fulfillment staff handling Figurio orders.

## Overview — Fulfillment Pipeline

```
Stripe payment confirmed
  → Order captured in OMS
    → Print file prepared & sent to MCAE
      → MCAE prints & ships to Figurio
        → Quality inspection
          → Branded packaging
            → Carrier handoff (Zásilkovna or DHL)
              → Tracking update to customer
```

---

## Step 1 — Order Capture from Stripe

- Stripe webhook fires on `payment_intent.succeeded`.
- OMS automatically creates an order record with: customer name, delivery address, size tier
  (Small / Medium / Large), figurine model reference, and Stripe payment ID.
- Verify the order record is complete within 15 minutes of webhook receipt.
- If the webhook fails, manually reconcile from the Stripe dashboard daily at 09:00.

**Flags to check at capture:**
- Address outside CZ/EU → route to DHL international; flag for possible customs documentation.
- Multiple size tiers in one order → create one MCAE job per tier; ship together.
- Rush orders (same-day flag) → contact MCAE immediately to request priority queue slot.

---

## Step 2 — Print File Handoff to MCAE

- Retrieve the approved `.3mf` or `.stl` print file from the asset library using the model
  reference on the order.
- Confirm file version matches the last QA-approved revision before sending.
- Send files to MCAE via the agreed secure transfer method (MCAE SFTP or email with password).
  Never attach customer PII — send only: order reference ID, size tier, quantity, and print file.
- MCAE must confirm receipt within 4 business hours (per vendor SLA). Log confirmation timestamp.
- Expected MCAE turnaround: Small 3 days, Medium 4 days, Large 5 days (business days from
  file confirmation).

---

## Step 3 — Quality Inspection on Receipt from MCAE

Inspect every unit before packaging. Use the checklist below — reject any unit that fails a
single criterion.

| Check                  | Pass condition                                              |
|------------------------|-------------------------------------------------------------|
| Dimensional accuracy   | Height within ±1 mm of stated tier (8 / 15 / 25 cm)        |
| Surface quality        | No visible layer lines at 30 cm; no support artefacts on front |
| Colour accuracy        | Visually consistent with reference render; no bleed or fade |
| Structural integrity   | No cracks, delamination, or base warping > 0.5 mm           |
| Cleanliness            | No residual support material, dust, or surface contamination|

**On rejection:** set unit aside, photograph defect, log in the reject tracker (date, order ref,
defect type, tier). Notify MCAE same day — replacements must arrive within 3 business days at
no charge per SLA. Update order status to "Pending Reprint" in OMS.

Reject rate above 3% in any rolling 4-week window triggers a formal quality review with MCAE
(see `vendor-evaluation` skill).

---

## Step 4 — Branded Packaging

All figurines ship in Figurio branded packaging. Match packaging to tier:

| Tier   | Box spec                      | Inner protection                        |
|--------|-------------------------------|-----------------------------------------|
| Small  | 120×120×120 mm white box      | Foam insert, tissue wrap                |
| Medium | 200×200×200 mm white box      | Foam insert, tissue wrap, cardboard tray|
| Large  | 300×300×300 mm white box      | Foam cradle, tissue wrap, cardboard lid |

Include in every parcel:
- Figurio thank-you card (current version from assets/packaging/)
- Care instructions insert
- Return address label (Figurio warehouse address)

Do not include invoices in the parcel — invoices are sent by email via Stripe.

---

## Step 5 — Carrier Dispatch

### Czech Republic — Zásilkovna

- Use Zásilkovna for all delivery addresses with CZ postal code.
- Generate label via Zásilkovna API or Packeta portal; attach to parcel.
- Drop parcels at the designated Zásilkovna drop-off point by 14:00 for same-day collection.
- Zásilkovna parcel ID must be written into the OMS order record immediately after label
  generation.
- Customer can choose home delivery or pickup point (Z-BOX / partner point) — honour the
  selection made at checkout.

### EU & International — DHL

- Use DHL Express for EU addresses (non-CZ) and all international destinations.
- Generate shipment via DHL MyDHL+ or API; use Figurio's account number.
- For destinations outside the EU, generate a commercial invoice (3 copies) with:
  - HS code: 9503.00 (toys/models — verify annually)
  - Declared value = Stripe order amount in EUR
  - Country of origin: CZ
- Attach DHL waybill and customs documents to parcel exterior in clear pouch.
- DHL tracking number must be entered into OMS immediately.

---

## Step 6 — Customer Tracking Update

- Once the carrier has the parcel, update the OMS order status to "Shipped".
- Trigger the transactional email (configured in Stripe/email platform) that sends the
  tracking number and carrier link to the customer.
- Expected delivery windows to communicate:
  - CZ (Zásilkovna): 1–3 business days
  - EU (DHL): 2–5 business days
  - International (DHL): 5–10 business days

---

## Escalation Paths

| Issue                              | Action                                                       |
|------------------------------------|--------------------------------------------------------------|
| MCAE misses receipt confirmation   | Chase by phone; log; escalate if unresolved in 8 hours       |
| Reject rate > 3% in 4-week window  | Formal quality review with MCAE (see vendor-evaluation skill)|
| DHL customs hold                   | Contact DHL proactively; resend commercial invoice if needed |
| Customer reports non-delivery      | Open carrier investigation; reship if unresolved in 10 days  |
| Zásilkovna parcel lost             | File claim via Packeta portal; reship within 3 business days |

---

## Anti-patterns

- Never send customer name or address to MCAE — use order reference IDs only.
- Never dispatch a unit that failed quality inspection, even under deadline pressure.
- Do not generate DHL labels for CZ addresses or Zásilkovna labels for international addresses.
- Do not skip the OMS status update steps — tracking records are the primary customer
  service evidence trail.
