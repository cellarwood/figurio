---
name: fulfillment-sop
description: >
  Standard operating procedure for Figurio's end-to-end order fulfillment:
  print file submission to MCAE, QA inspection on receipt, branded packaging,
  shipping via Zásilkovna (domestic CZ) and DHL (EU international), and
  tracking update delivery to the customer.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - fulfillment
      - shipping
---

# Order Fulfillment SOP

## When to Use

Use this skill when:
- Processing a new customer order end-to-end
- Troubleshooting a fulfillment step (QA failure, shipping delay, tracking issue)
- Onboarding a new ops team member to the fulfillment workflow
- Auditing fulfillment for a batch of orders

## Overview

All Figurio orders are prepaid via Stripe before production begins. Fulfillment follows five sequential stages:

```
1. Print File Submission → MCAE
2. QA Inspection on Receipt
3. Branded Packaging
4. Shipping (Zásilkovna or DHL)
5. Tracking Update to Customer
```

---

## Stage 1 — Print File Submission to MCAE

**Trigger:** Order marked `paid` in the order management system.

**Steps:**

1. Retrieve the customer's approved 3D model file (format: `.wrl` or `.obj` with texture maps, per MCAE's J55 requirements).
2. Confirm size tier from the order: small (~8 cm), medium (~15 cm), or large (~25 cm).
3. Complete the MCAE order form with:
   - Figurio order ID
   - Size tier and quantity
   - Material: PolyJet full-color (J55)
   - Requested completion date (allow standard turnaround + 1 buffer day)
   - Delivery address: Figurio receiving address (unless drop-ship is active)
4. Submit the file and form via the MCAE partner portal or agreed email channel.
5. Log submission timestamp and MCAE reference number in the order record.

**SLA:** Submit to MCAE within 1 business day of payment confirmation.

---

## Stage 2 — QA Inspection on Receipt from MCAE

**Trigger:** Parcel received from MCAE.

**Inspection checklist (per unit):**

| Check | Pass Criteria |
|-------|--------------|
| Color accuracy | No visible color banding or off-tone sections; matches approved render |
| Surface quality | No visible layer lines, support marks, or surface roughness on exposed areas |
| Geometry | No warping, cracks, or missing geometry |
| Size | Within ±2 mm of specified tier height |
| Quantity | Count matches MCAE packing slip and order |

**On pass:** Move units to packaging. Mark order as `QA passed` in order system.

**On fail:**

1. Photograph defects clearly against a white background.
2. Log defect type: color, geometry, surface, or size.
3. Contact MCAE with photos and request reprint or credit.
4. Do not ship failed units under any circumstances.
5. Mark order as `QA hold` and notify the customer of a delay if reprint will breach the promised ship date.

---

## Stage 3 — Branded Packaging

All shipments use Figurio's standard branded packaging regardless of carrier.

**Packaging components:**

- Outer box: size-matched (S / M / L box variant)
- Inner protection: custom foam insert molded to figurine tier size
- Branded tissue paper wrap around the figurine
- Figurio thank-you card (pre-printed, placed on top)
- Optional: promotional insert for referral program (include unless order notes say otherwise)

**Steps:**

1. Select the correct box size for the tier.
2. Place foam insert, wrap figurine in tissue paper, set in foam recess.
3. Place thank-you card face-up on top of wrapped figurine.
4. Add promotional insert if applicable.
5. Close and seal box with Figurio-branded tape.
6. Do not apply any MCAE branding or packing slips to the exterior.

---

## Stage 4 — Shipping

Carrier selection is determined by the delivery country on the order.

### Domestic (Czech Republic) — Zásilkovna

1. Log in to Zásilkovna business portal.
2. Create a new shipment: enter customer name, address, phone, and Figurio order ID as the reference.
3. Select the appropriate parcel size (S/M/L maps to Zásilkovna size categories — confirm current category limits in the portal).
4. Print the Zásilkovna label and affix to the outer box.
5. Drop parcel at the agreed Zásilkovna pickup point or schedule a courier collection.
6. Record the Zásilkovna tracking number in the order record.

### International (EU) — DHL

1. Log in to DHL business portal (MyDHL+).
2. Create shipment: enter sender (Figurio CZ address), recipient details from the order, and declared value (product value in EUR).
3. Select DHL Express or DHL Parcel Europe based on customer's chosen service at checkout.
4. Complete customs data if required (CN22/CN23 for non-EU destinations — note: Figurio currently ships EU only via DHL, so customs declarations are typically not required but confirm for edge cases).
5. Print DHL label and waybill; affix label to outer box.
6. Hand off to DHL courier at the scheduled pickup.
7. Record the DHL tracking number (AWB) in the order record.

**Prohibited:** Do not mix carriers for a single order (e.g., do not use DHL for a CZ domestic address or Zásilkovna for an EU address).

---

## Stage 5 — Tracking Update to Customer

**Trigger:** Shipment handed to carrier and tracking number confirmed active.

**Steps:**

1. In the order management system, update order status to `shipped`.
2. Enter the tracking number and carrier name.
3. Send the shipping confirmation email to the customer using the standard template:
   - Carrier name
   - Tracking number as a clickable link
   - Estimated delivery window (Zásilkovna: 1–2 business days; DHL: 2–5 business days depending on destination)
4. If using Zásilkovna, confirm the customer's preferred pickup point is included in the notification if they selected a pickup delivery type.

**SLA:** Tracking notification sent within 2 hours of carrier handoff.

---

## Order Status Lifecycle

```
paid → submitted_to_mcae → qa_passed / qa_hold → packaged → shipped → delivered
```

Every stage transition must be logged in the order management system with a timestamp and the responsible operator's name.

## Anti-Patterns

- Do not submit print files to MCAE before Stripe payment is confirmed — all orders are prepaid
- Do not ship any unit that failed QA inspection, even partially damaged units
- Do not use personal courier accounts — always use Figurio's business accounts for Zásilkovna and DHL
- Do not send tracking notifications before the tracking number is scannable/active in the carrier system
- Do not include MCAE packing materials or branding in customer shipments — Figurio is the seller of record
