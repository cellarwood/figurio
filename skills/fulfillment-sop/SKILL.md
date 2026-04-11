---
name: fulfillment-sop
description: >
  Standard operating procedures for Figurio order fulfillment end-to-end.
  Covers MCAE print file handoff, quality inspection criteria, branded packaging
  assembly, shipping label generation via Zasilkovna and DHL, and returns and
  refund handling for both catalog and AI-custom figurine orders.
allowed-tools:
  - Read
  - Write
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - fulfillment
      - sop
---

# Fulfillment SOP

This SOP covers the full lifecycle of a Figurio order from payment confirmation to delivery. It applies to both catalog figurines and AI-custom figurine orders. Custom orders have additional steps noted inline.

---

## Step 1 — Print File Handoff to MCAE

**Trigger:** Stripe payment confirmed, order status set to `PAID`.

### Catalog Orders

1. Retrieve the pre-approved print file for the SKU from the print file library (Google Drive → Operations/Print Files/Catalog).
2. Verify file version matches the current approved revision (check filename suffix, e.g., `figurine-knight-v3.stl`).
3. Bundle the print file with the MCAE order form (template: Operations/Templates/MCAE-Order-Form.xlsx), filling in:
   - Order ID
   - SKU and quantity
   - Requested delivery date (today + 5 business days)
   - Finish: PolyJet full-color, no post-processing
4. Send to MCAE via email to `production@mcae.cz` with subject: `[FIGURIO] Order {ORDER_ID} — Print Request`.

### AI-Custom Orders

1. Confirm the AI-generated 3D model has passed automated geometry validation (watertight mesh, no inverted normals). If validation failed, escalate to the backend engineer before proceeding.
2. Run a brief manual check: correct figurine identity, no obvious artifacts, appropriate scale for the selected size tier.
3. Store the approved model in Google Drive → Operations/Print Files/Custom/{ORDER_ID}/.
4. Proceed with MCAE order form as above, noting "CUSTOM — do not reuse file" in the comments field.

**MCAE SLA:** 5 business days from file receipt. If no acknowledgment within 4 business hours, follow up by phone.

---

## Step 2 — Quality Inspection

**Trigger:** MCAE delivers print(s) to Figurio (or to the designated QC address).

Inspect each figurine against the following checklist. Fail any unit that does not meet all criteria:

| Check | Pass Criteria |
|-------|--------------|
| Color fidelity | No visible banding; colors match reference render within reasonable tolerance |
| Surface finish | No layer artifacts, no support marks on visible surfaces |
| Dimensional accuracy | Height within ±2 mm of spec for the size tier |
| Structural integrity | No cracks, warping, or brittle joints |
| Base stability | Figurine stands upright unaided on flat surface |

- **Pass:** proceed to Step 3.
- **Fail (single unit in batch):** set aside, reorder replacement from MCAE referencing the same order ID with suffix `-R1`. Do not delay shipping of passing units if the order contains multiple items and at least one is passing.
- **Fail (full batch):** escalate to MCAE with photos. Pause shipment. Notify customer with a delay email (template: Operations/Templates/Email-Delay-Custom.txt). Do not issue refund until MCAE root cause is confirmed.

---

## Step 3 — Branded Packaging Assembly

All figurines ship in Figurio-branded packaging regardless of order type.

### Assembly Steps

1. Wrap figurine in acid-free tissue paper (white).
2. Place in the appropriately sized box:
   - S tier: 120×120×120 mm box
   - M tier: 180×120×120 mm box
   - L tier: 250×180×150 mm box
3. Fill void with biodegradable packing peanuts — figurine must not shift when box is shaken.
4. Insert the branded thank-you card (pre-printed, stored in ops stock). For AI-custom orders, use the custom variant card which includes a note about the personalized process.
5. Seal box with Figurio-branded tape.
6. Affix the printed packing slip (generated from the order system) inside the lid.

---

## Step 4 — Shipping Label Generation

### Zasilkovna (domestic CZ and parcel shop delivery)

Use the Zasilkovna Shipper API or portal:

1. Log in to Zasilkovna Shipper (credentials in 1Password → Operations).
2. Create shipment with:
   - Recipient name, address, and phone from order data
   - Parcel shop ID if the customer selected pickup (field: `pickup_point_id` in order record)
   - Weight: weigh the packed box on the ops scale; enter in grams
   - COD: leave blank (Figurio uses Stripe — no COD)
3. Download the label PDF and print on label printer (Dymo LabelWriter 4XL).
4. Affix label to top face of box.
5. Update order status to `LABEL_CREATED` in the backend admin panel.

### DHL (EU international orders)

1. Log in to DHL Express portal (credentials in 1Password → Operations).
2. Create shipment using DHL MyDHL+ or the DHL API integration (if automated pipeline is active).
3. Select service: **DHL Express Worldwide** for non-CZ EU orders.
4. Enter customs data for non-EU shipments: commodity description "Decorative figurine — 3D printed", HS code `9505.90.80`, value from order total in EUR.
5. Print label and affix to box.
6. Update order status to `LABEL_CREATED`.

---

## Step 5 — Handoff to Carrier

- **Zasilkovna:** Drop parcels at the designated Zasilkovna pickup point by 14:00 for same-day dispatch. Collect the drop-off receipt and photograph it.
- **DHL:** Schedule DHL pickup (daily standing pickup booked for 15:00) or drop at DHL ServicePoint.

Update order status to `SHIPPED` and trigger the shipping confirmation email with tracking number (automated from order system on status change).

---

## Returns and Refund Handling

### Customer-Initiated Return

1. Customer submits return request via the Figurio website or emails support.
2. Ops reviews eligibility:
   - **Eligible:** damaged on arrival, wrong item, print quality failure. Window: 30 days from delivery.
   - **Not eligible:** AI-custom orders where the 3D model was customer-approved before printing (unless defect is Figurio's fault).
3. For eligible returns: send the customer a prepaid Zasilkovna return label (generated in Shipper portal, cost charged to Figurio account).
4. On return receipt, inspect the item:
   - Confirmed defect: issue full refund via Stripe (Refunds API or Stripe dashboard). Update order status to `REFUNDED`.
   - No defect found: contact customer, offer store credit or re-shipment. Escalate disputes to Head of Operations.

### Stripe Refund Process

- Full refund: `POST /v1/refunds` with `payment_intent` from order record.
- Partial refund: specify `amount` in CZK smallest unit (haléře).
- Refunds typically appear within 5–10 business days depending on customer bank.
- Log all refunds in the Refunds sheet (Google Sheets → Operations/Finance/Refunds-{YEAR}.xlsx) with order ID, reason, and amount.

---

## Order Status Reference

| Status | Meaning |
|--------|---------|
| `PAID` | Payment confirmed, awaiting print handoff |
| `IN_PRINT` | Sent to MCAE |
| `QC` | Print received, under inspection |
| `PACKING` | Passed QC, being packaged |
| `LABEL_CREATED` | Shipping label generated |
| `SHIPPED` | Handed to carrier |
| `DELIVERED` | Carrier confirmed delivery |
| `REFUNDED` | Refund issued |
| `ON_HOLD` | Issue requiring manual resolution |

---

## Anti-patterns

- Do not ship an AI-custom order without confirming geometry validation passed — a failed print wastes MCAE capacity and delays the customer.
- Do not generate a Zasilkovna label without the customer's `pickup_point_id` if they selected parcel shop delivery — the parcel will be undeliverable.
- Do not issue a Stripe refund before the return is physically received and inspected, except in cases of clear non-delivery confirmed by carrier.
