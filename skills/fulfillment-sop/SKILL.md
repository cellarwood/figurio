---
name: fulfillment-sop
description: Standard operating procedures for Figurio order fulfillment — from payment capture through MCAE printing to customer delivery via Zasilkovna/DHL.
---

# Fulfillment Standard Operating Procedures

## Purpose

Define the step-by-step process for fulfilling every Figurio order, from payment confirmation through delivery. Consistency in fulfillment ensures quality, speed, and customer satisfaction.

## Fulfillment Flow Overview

```
Order Received → Payment Verified → Print File Prepared → Sent to MCAE
    → QA Check on Delivery → Branded Packaging → Ship via Zasilkovna/DHL
    → Tracking Number to Customer → Delivery Confirmed
```

## Step-by-Step Procedures

### Step 1: Order Received

**Trigger**: Stripe `payment_intent.succeeded` webhook received.

- System automatically updates order status from `pending` to `paid`.
- Customer receives order confirmation email with order number and summary.
- Order appears in the fulfillment queue (sorted by date, then priority).

**Timing**: Automated, immediate.

### Step 2: Payment Verified

- Verify payment amount matches order total in the database.
- Confirm Stripe payment intent status is `succeeded` (not just `processing`).
- For orders over 5,000 CZK: manual review for fraud indicators before proceeding.
- Flag and hold: mismatched amounts, suspicious email patterns, multiple failed attempts before success.

**Timing**: Automated check, manual review within 2 hours for flagged orders.

### Step 3: Print File Prepared

#### Catalog Items
- Retrieve the production-ready STL file from object storage.
- Select the correct size tier file based on the ordered size (S/M/L/XL).
- Verify file integrity (checksum matches stored hash).

#### Custom Orders
- Retrieve the customer-approved 3D model from the custom order pipeline.
- Verify the model has passed mesh repair (watertight, correct wall thickness).
- Apply size scaling for the ordered tier.
- Run final printability check (automated script):
  - [ ] Watertight mesh.
  - [ ] Minimum wall thickness 0.8mm.
  - [ ] No inverted normals.
  - [ ] Triangle count within 50K-500K range.
  - [ ] File size under 50MB.

**Timing**: 15-30 minutes for catalog items, 1-2 hours for custom orders.
**Status update**: Order moves to `processing`.

### Step 4: Sent to MCAE

- Upload print file to MCAE ordering portal or via API.
- Specify print parameters:
  - Material: Vero (PolyJet full color).
  - Finish: Matte.
  - Orientation: optimized for surface quality on visible faces.
- Record MCAE order reference number in Figurio database.
- Request estimated completion date from MCAE.

**Timing**: Same business day for orders received before 14:00 CET.
**Status update**: Order moves to `printing`.
**Expected MCAE turnaround**: 5-7 business days standard, 2-3 express.

### Step 5: QA Check on Delivery from MCAE

When printed figurines arrive from MCAE, inspect each piece:

#### Visual Inspection Checklist

- [ ] **Color accuracy**: Compare to the approved digital preview. No visible color shifts.
- [ ] **Surface finish**: Smooth, matte. No visible layer lines, bumps, or rough patches.
- [ ] **Support material**: Fully removed, no residue on the figurine surface.
- [ ] **Structural integrity**: No cracks, chips, warping, or delamination.
- [ ] **Dimensional accuracy**: Spot-check height against expected measurement (+/- 1mm).
- [ ] **Detail preservation**: Fine features (facial details, small accessories) are intact.
- [ ] **Base stability**: Figurine stands upright on a flat surface without wobbling.

#### QA Outcomes

| Result    | Action                                                        |
|-----------|---------------------------------------------------------------|
| Pass      | Proceed to packaging.                                         |
| Minor flaw| Document with photo. If cosmetic-only and not customer-facing, proceed with note. |
| Major flaw| Reject. Submit reprint request to MCAE with defect photos.   |
| Damaged   | Reject. File damage claim with MCAE. Reorder immediately.    |

**Timing**: Same day as MCAE delivery.
**Status update**: Order moves to `quality_check`, then `packing` on pass.

### Step 6: Defect Handling (Reprint Request)

When a figurine fails QA:

1. Photograph the defect (minimum 3 angles + close-up of the issue).
2. Log the defect in the order notes with description and photos.
3. Submit reprint request to MCAE with:
   - Original order reference.
   - Defect description and photos.
   - Request for express turnaround if customer delivery is at risk.
4. Notify the customer if delivery will be delayed beyond the original estimate.
5. Offer the customer a choice: wait for reprint or full refund.
6. Track reprint separately; repeat QA on arrival.

**Target reprint rate**: Under 5% of all orders.

### Step 7: Branded Packaging

#### Packaging by Size Tier

| Tier | Box Dimensions    | Interior Protection           | Weight (packed) |
|------|-------------------|-------------------------------|-----------------|
| S    | 10 x 10 x 12 cm  | Foam insert, tissue wrap      | ~150g           |
| M    | 15 x 15 x 20 cm  | Foam insert, tissue wrap      | ~350g           |
| L    | 20 x 20 x 30 cm  | Custom foam cradle, tissue    | ~700g           |
| XL   | 25 x 25 x 35 cm  | Custom foam cradle, bubble    | ~1200g          |

#### Packaging Steps

1. Place figurine in the foam insert / cradle. Ensure no movement when box is shaken gently.
2. Wrap in branded tissue paper.
3. Place the "Share your figurine" photo card on top (includes #MyFigurio hashtag and 10% referral code).
4. Add the thank-you card with handwritten-style message.
5. Close and seal the branded box.
6. Apply the shipping label to the outside.
7. For L and XL: add "FRAGILE" sticker on two sides.

**Timing**: 10-15 minutes per order.
**Status update**: Order moves to `packing`.

### Step 8: Ship via Zasilkovna or DHL

#### Shipping Provider Selection

| Destination              | Default Provider | Alternative          |
|--------------------------|------------------|----------------------|
| Czech Republic           | Zasilkovna       | DHL (premium option) |
| Slovakia                 | Zasilkovna       | DHL                  |
| Poland, Hungary, Romania | Zasilkovna       | DHL                  |
| DACH (DE, AT, CH)        | DHL              | DPD (if available)   |
| Rest of EU               | DHL              | —                    |
| XL tier (any destination)| DHL              | — (size limit)       |

#### Shipping Label Generation

- **Zasilkovna**: Generate via Zasilkovna API. Include pickup point ID selected by customer at checkout.
- **DHL**: Generate via DHL API. Include full delivery address.
- Store tracking number in the order record.

#### Customer Notification

- Send "Your order has shipped!" email with:
  - Tracking number and link (Zasilkovna tracking URL or DHL tracking URL).
  - Estimated delivery date.
  - Care instructions for the figurine.

**Timing**: Ship same business day if packaging completed before 15:00 CET.
**Status update**: Order moves to `shipped`.

### Step 9: Delivery Confirmation

- Monitor tracking status via provider API.
- When delivery is confirmed:
  - Update order status to `delivered`.
  - Send "Your figurine has arrived!" email.
  - Include: care tips, link to leave a review, referral discount for next order.
- If delivery fails (returned to sender):
  - Contact customer to verify address.
  - Reship or refund based on customer preference.

## Fulfillment SLAs

| Metric                           | Target                    |
|----------------------------------|---------------------------|
| Order to MCAE submission         | Same business day         |
| MCAE print turnaround            | 5-7 business days         |
| QA inspection                    | Same day as MCAE delivery |
| Packaging and ship               | Same business day as QA   |
| Total order-to-delivery (CZ)     | 8-12 business days        |
| Total order-to-delivery (EU)     | 10-15 business days       |
| Customer communication on delay  | Within 24 hours of delay  |

## Peak Season Adjustments (Q4)

- Pre-stock top 20 catalog items with MCAE (buffer inventory of 10 units per SKU).
- Negotiate express turnaround with MCAE for the Nov-Dec period.
- Set order cutoff date for guaranteed Christmas delivery (typically Dec 10).
- Add temporary packaging capacity (hire or outsource).
- Communicate extended timelines on the website and at checkout.
