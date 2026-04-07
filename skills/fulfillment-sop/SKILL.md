---
name: Fulfillment SOP
description: Standard operating procedures for Figurio's order fulfillment from payment to delivery
---

# Fulfillment SOP

## Order Lifecycle

```
Customer places order → Payment captured (Stripe) → Order created (status: paid)
  → Print file prepared → Sent to MCAE (status: sent_to_printer)
    → MCAE prints (status: printing) → Quality check
      → Ship to Figurio or drop-ship (status: shipped)
        → Customer receives (status: delivered)
```

## Step-by-Step Procedure

### 1. Order Received
- **Trigger:** Stripe webhook `checkout.session.completed`
- **Action:** Create order record with status `paid`
- **Verify:** Payment amount matches order total, customer info complete

### 2. Print File Preparation
- **Catalog orders:** Retrieve pre-validated print file from model library
- **Custom AI orders:** Model must have passed QA review and customer approval
- **Verify:** File is manifold, meets minimum wall thickness, has correct color data
- **Output:** Print-ready file in format MCAE accepts (STL + color map, or 3MF)

### 3. MCAE Handoff
- **Delivery method:** [TBD — email, shared drive, or API]
- **Include:** Print file, size tier, quantity, priority level, order reference number
- **Expected response:** MCAE confirms receipt and provides estimated completion date
- **SLA:** MCAE acknowledges within 1 business day

### 4. Printing & Quality Check
- **MCAE prints and performs their quality check**
- **Figurio spot-checks:** When receiving prints, inspect 100% of orders initially, move to sampling once defect rate < 2%
- **Rejection criteria:** Visible layer lines, color mismatch, broken parts, wrong size

### 5. Packaging
- **Branded box** appropriate to figurine size (S/M/L)
- **Interior:** Foam insert or tissue paper for protection
- **Inserts:** Thank-you card, care instructions, social media CTA card
- **Gift option:** Premium wrapping if selected at checkout

### 6. Shipping
- **Czech Republic:** Zásilkovna (Packeta) — pickup point or home delivery
- **EU:** DHL Parcel — home delivery
- **Generate:** Shipping label, tracking number
- **Update:** Order status to `shipped`, send tracking email to customer

### 7. Delivery Confirmation
- **Trigger:** Carrier delivery confirmation or customer confirms receipt
- **Update:** Order status to `delivered`

## Escalation Procedures

| Issue | Action | Escalation |
|-------|--------|-----------|
| MCAE misses SLA by 2+ days | Contact MCAE, update customer with new estimate | CEO if pattern repeats |
| Print quality issue | Request reprint from MCAE, document defect | CEO if defect rate > 5% |
| Shipping damage | Send replacement, file claim with carrier | Head of Ops tracks claim |
| Customer doesn't receive | Trace with carrier, resend if confirmed lost | Head of Ops resolves |
