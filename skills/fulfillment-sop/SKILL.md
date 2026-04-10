---
name: fulfillment-sop
description: >
  Standard operating procedures for Figurio's end-to-end order fulfillment —
  from Stripe payment confirmation through print file preparation, MCAE submission,
  quality inspection of received prints, branded packaging, and shipping dispatch
  via Zásilkovna (CZ) or DHL (EU) with tracking updates to the customer.
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

## Overview

All Figurio orders are prepaid via Stripe. No order enters production until
payment is confirmed. The fulfillment pipeline has six stages:

1. Order Intake
2. Print File Preparation
3. MCAE Submission
4. Quality Inspection
5. Packaging
6. Shipping & Tracking

---

## Stage 1 — Order Intake

**Trigger:** Stripe `payment_intent.succeeded` or `checkout.session.completed` event.

**Steps:**

1. Confirm Stripe payment status is `succeeded`. Do not proceed on `processing`.
2. Pull order details: customer name, delivery address, figurine size tier
   (Small / Medium / Large), and any customisation notes.
3. Log order in the fulfillment tracker (Google Sheet: *Orders Master*) with status `INTAKE`.
4. Retrieve the customer's uploaded 3D model file (STL, OBJ, or 3MF) from the
   order record.
5. Send automated order confirmation email to customer with estimated dispatch date:
   - Small: +4 business days
   - Medium: +5 business days
   - Large: +6 business days

**Blockers:** If payment status is ambiguous, hold the order and notify the
Head of Operations immediately — do not guess.

---

## Stage 2 — Print File Preparation

**Owner:** Operations (file checks) — no external tooling required for checks.

### Mandatory Checks (run in order)

| Check | Requirement | Action if Failed |
|-------|-------------|-----------------|
| File format | STL, OBJ, or 3MF only | Request re-upload from customer |
| Manifold (watertight) | Zero non-manifold edges | Auto-repair with Meshmixer; if repair fails, contact customer |
| Wall thickness | ≥ 1.5 mm on all faces | Notify customer; offer paid repair service |
| Minimum feature size | ≥ 0.8 mm (PolyJet limit) | Flag thin features; customer approval required before continuing |
| Print volume fits tier | Small: ≤ 8 cm tall, Medium: ≤ 15 cm, Large: ≤ 25 cm | Confirm actual bounding box matches ordered tier |
| Support accessibility | No fully enclosed cavities > 5 mm | Flag to customer; may affect surface finish |

### Orientation

Orient the model to minimise support contact on display surfaces (typically
the figurine face and front torso). Document the chosen orientation in the
order record.

### File Naming Convention

```
FIGURIO-{ORDER_ID}-{SIZE}-v{N}.{ext}
```

Example: `FIGURIO-10482-MED-v1.stl`

Increment `v{N}` for each revision. Always send the latest version to MCAE.

Update order status to `FILE_READY`.

---

## Stage 3 — MCAE Submission

**Contact:** MCAE (mcae.cz) — use the designated account manager contact.

**Steps:**

1. Email the prepared file to MCAE using the subject line format:
   `[FIGURIO] Order {ORDER_ID} — {SIZE} — {QUANTITY}x`
2. Confirm the committed completion date in writing (email reply).
3. Log confirmed completion date in *Orders Master* under column `MCAE_COMMIT`.
4. Update order status to `IN_PRODUCTION`.
5. If MCAE does not confirm within 4 business hours, follow up once; escalate to
   Head of Operations if no response by end of day.

**Rush Orders:** Notify MCAE at least 24 hours before end-of-day cutoff (17:00 CET).
Rush surcharge applies — confirm cost before committing to customer.

---

## Stage 4 — Quality Inspection

**Trigger:** Figurines received from MCAE.

**Inspect every unit before packaging.** Do not skip even if MCAE confirms
their own QC.

### Inspection Checklist

| Item | Pass Criteria |
|------|--------------|
| Surface finish | No visible layer lines; smooth on display faces |
| Color accuracy | Visually matches reference render (customer-supplied or generated preview) |
| Support marks | No marks deeper than 0.3 mm on display faces |
| Dimensional integrity | No warping; base sits flat on a level surface |
| Structural completeness | No broken parts, missing features, or voids |
| Wall integrity | No cracks along thin features |

**Outcomes:**

- **Pass:** Proceed to packaging. Log `QC_PASS` in *Orders Master*.
- **Fail — reprint required:** Photograph defect(s). Email MCAE with photos and
  defect description. Request priority reprint at no charge if defect is
  production-side. Update status to `QC_FAIL_REPRINT`. Notify customer of delay.
- **Fail — acceptable with customer consent:** For minor cosmetic issues that
  do not affect display quality, contact customer with photos and offer
  acceptance at discount or free reprint. Document outcome.

---

## Stage 5 — Packaging

### Materials

- Figurio-branded outer box (size-matched: S / M / L)
- Foam insert cut to figurine profile
- Tissue paper wrap (branded)
- Thank-you card (pre-printed, signed by operations)
- Certificate of authenticity insert (for custom orders)

### Steps

1. Wrap figurine in tissue paper; place in foam insert.
2. Place foam insert in branded box; close and seal with Figurio sticker.
3. Print shipping label (see Stage 6) and attach to outer box.
4. Log `PACKED` in *Orders Master*.

**Fragile sticker:** Always apply a FRAGILE sticker on all four vertical faces
of the outer box for Medium and Large tiers.

---

## Stage 6 — Shipping and Tracking

### Carrier Selection

| Destination | Carrier | Service |
|-------------|---------|---------|
| Czech Republic | Zásilkovna | Standard parcel (pickup point or home delivery per customer preference) |
| EU countries | DHL | Standard tracked export |

### Steps

1. Generate shipping label via carrier portal:
   - Zásilkovna: use the Zásilkovna Sender portal; select the customer's chosen
     pickup point if applicable.
   - DHL: use DHL business account; select "DHL Paket International".
2. Record tracking number in *Orders Master* under `TRACKING_NUMBER`.
3. Send dispatch confirmation email to customer with:
   - Tracking number and carrier tracking URL
   - Estimated delivery window
4. Update order status to `SHIPPED`.
5. Monitor tracking for delivery confirmation. If no delivery scan within:
   - Zásilkovna: 5 business days — initiate inquiry
   - DHL: 8 business days — initiate inquiry

### Delivery Confirmation

Once carrier marks `Delivered`, update *Orders Master* status to `COMPLETE`.
No follow-up email is sent unless the customer contacts support.

---

## Status Flow Summary

```
INTAKE → FILE_READY → IN_PRODUCTION → QC_PASS → PACKED → SHIPPED → COMPLETE
                                    ↘ QC_FAIL_REPRINT → IN_PRODUCTION (loop)
```

---

## Escalation Contacts

| Issue | Escalate To |
|-------|-------------|
| Payment anomaly | Head of Operations + Finance |
| MCAE unresponsive > 4 h | Head of Operations |
| QC failure rate > 5% in one batch | Head of Operations + CTO |
| Carrier damage claim | Head of Operations; file claim within 48 h of receipt |
