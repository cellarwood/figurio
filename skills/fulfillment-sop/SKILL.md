---
name: fulfillment-sop
description: >
  Standard operating procedures for Figurio order fulfillment — from Stripe
  payment confirmation through order routing to MCAE, print file preparation,
  QA checks, branded packaging, shipping handoff via Zásilkovna or DHL, and
  customer notifications at each stage.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - fulfillment
      - sop
---

# Fulfillment SOP — Figurio Order Lifecycle

## Overview

Every Figurio order follows a linear pipeline from prepaid Stripe checkout to
doorstep delivery. All printing is outsourced to MCAE (mcae.cz). This SOP
defines the exact steps, responsible parties, and decision points at each
stage. Deviations from this process must be logged and reviewed by the COO.

---

## Stage 1 — Order Confirmation

**Trigger:** Stripe webhook fires `payment_intent.succeeded`.

Steps:
1. System creates an order record with status `CONFIRMED`.
2. Customer receives automated **Order Confirmation** email with order ID and
   expected delivery window.
3. 3D model file attached to the customer's order is validated:
   - File format accepted (STL or OBJ).
   - File is not corrupted or zero-byte.
   - Dimensions fall within the selected size tier tolerance.
4. If validation fails, flag order as `NEEDS_REVIEW` and notify the COO queue
   within 30 minutes. Do not route to MCAE until resolved.

---

## Stage 2 — Print File Preparation

**Owner:** Operations (COO agent or human ops)

Steps:
1. Export the validated 3D model as a print-ready file per MCAE's accepted
   format (confirm current spec with MCAE — typically `.wrl` or `.3mf` with
   embedded color).
2. Apply any scale correction to hit the nominal tier height:
   - Small: ~8 cm
   - Medium: ~15 cm
   - Large: ~25 cm
3. Attach a **print spec sheet** to the file bundle:
   - Order ID
   - Tier (small / medium / large)
   - Special instructions if noted by customer
4. Save the file bundle to the designated MCAE transfer folder.

---

## Stage 3 — Routing to MCAE

Steps:
1. Upload the print file bundle to the MCAE portal (or transfer via agreed
   SFTP path).
2. Send MCAE the print order confirmation with:
   - Figurio order ID
   - Tier and quantity
   - Required ship date (based on SLA: 3 BD small, 4 BD medium, 5–6 BD large)
   - Shipping carrier selection (Zásilkovna or DHL — see Stage 5)
3. Update order status to `IN_PRODUCTION`.
4. Send customer **In Production** notification with updated delivery estimate.
5. Log MCAE submission timestamp — this starts the SLA clock once MCAE
   confirms file is print-ready.

---

## Stage 4 — QA Check

**Owner:** MCAE performs primary QA; Figurio conducts spot-check audits.

MCAE responsibilities:
- Inspect each unit against Figurio's quality standards before packaging
  (color accuracy, surface finish, dimensional accuracy, structural integrity,
  base stability — see `vendor-evaluation` skill for full criteria).
- Photograph rejects and notify Figurio ops before reprinting.

Figurio audit process (sampled, not every order):
- Request MCAE to include a QA photo of the finished figurine for flagged
  orders (high-value, large tier, repeat-reject customer).
- Log any customer-reported quality issues back to MCAE with the order ID
  and photos within 24 hours of complaint receipt.

If MCAE flags a reject:
1. Update order status to `QA_FAIL`.
2. Notify customer of delay with revised delivery estimate.
3. Confirm MCAE reprint at no charge (covered under SLA terms).

---

## Stage 5 — Branded Packaging

MCAE packages each figurine in Figurio-supplied branded materials before
carrier handoff. Packaging spec:
- Rigid outer box with Figurio branding (supplied to MCAE in bulk).
- Interior foam insert sized per tier (three SKUs: S-INSERT, M-INSERT,
  L-INSERT).
- Printed packing slip inside box (generated per order, includes order ID,
  customer name, thank-you message).
- No plain brown box is acceptable — reject any MCAE shipment that leaves in
  unbranded packaging.

Monitor MCAE's branded packaging inventory. Reorder when stock at MCAE drops
below a 4-week buffer. COO is notified at 6-week buffer to initiate reorder.

---

## Stage 6 — Shipping Carrier Selection

Select carrier at order routing time (Stage 3) based on:

| Condition | Carrier |
|-----------|---------|
| Domestic Czech Republic | Zásilkovna |
| CEE countries in Zásilkovna network | Zásilkovna |
| International outside Zásilkovna network | DHL |
| Customer selected express delivery | DHL |
| Large tier, any destination | DHL (default unless customer chose standard) |

MCAE hands the packaged figurine to the selected carrier on the same business
day QA passes.

---

## Stage 7 — Dispatch and Customer Notification

Steps:
1. MCAE provides tracking number upon carrier pickup.
2. Update order status to `SHIPPED`.
3. Send customer **Shipped** notification with:
   - Carrier name
   - Tracking number and link
   - Estimated delivery date
4. Log dispatch timestamp. If dispatch is more than 1 BD after QA pass, flag
   as an MCAE handoff delay.

---

## Stage 8 — Delivery and Closure

1. Monitor carrier tracking. If no delivery scan within 2 BD of estimated
   delivery date, initiate carrier inquiry.
2. On confirmed delivery (carrier status = delivered), update order status
   to `DELIVERED`.
3. Send customer **Delivery Confirmation** email with a review request.
4. If customer reports non-delivery or damage within 14 days:
   - Domestic: raise Zásilkovna claim or DHL claim as appropriate.
   - Authorize reprint or refund per Figurio returns policy.
   - Log incident against MCAE if damage is production-origin.

---

## Status Reference

| Status | Meaning |
|--------|---------|
| `CONFIRMED` | Payment received, file validated |
| `NEEDS_REVIEW` | File validation failed, ops action required |
| `IN_PRODUCTION` | Routed to MCAE, printing |
| `QA_FAIL` | MCAE reject, reprint in progress |
| `SHIPPED` | Dispatched to carrier |
| `DELIVERED` | Carrier confirmed delivery |

---

## Escalation Contacts

- MCAE production queries: account manager contact on file with COO
- Zásilkovna claims: ops portal
- DHL claims: DHL business account portal
- Customer escalations exceeding standard resolution: COO
