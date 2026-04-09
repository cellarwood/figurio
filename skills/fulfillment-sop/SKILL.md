---
name: fulfillment-sop
description: >
  Standard operating procedures for Figurio's order fulfillment pipeline —
  from paid order to customer delivery, including MCAE print handoff,
  quality inspection, packaging, and shipping via Zasilkovna and DHL.
---

# Fulfillment SOP

## Order Fulfillment Flow

```
Order Paid → Print File Prep → MCAE Handoff → Production → QC Inspection → Packaging → Shipping → Delivery
```

### 1. Print File Preparation
- Verify the product model is print-ready (manifold, wall thickness, support structures)
- For custom AI figurines: confirm customer approval of preview
- Export print file in MCAE's required format (STL/OBJ with color data, or 3MF)
- Record file submission in order tracking system

### 2. MCAE Handoff
- Submit print file to MCAE via agreed delivery method
- Include order reference number, size tier, quantity, and any special instructions
- Log submission timestamp for SLA tracking
- Expected turnaround: [TBD - negotiate with MCAE]

### 3. Quality Inspection
- Inspect received prints against QC criteria:
  - [ ] Color accuracy matches preview/catalog image
  - [ ] Surface finish is smooth (no visible layer lines, supports removed)
  - [ ] Structural integrity (no cracks, broken parts, warping)
  - [ ] Correct size tier
  - [ ] No visible defects (bubbles, missing detail, color bleeding)
- Defective prints: photograph defect, log in QC tracker, request reprint from MCAE
- Target defect rate: < 2%

### 4. Packaging
- Branded packaging: box with Figurio logo, tissue paper, care card
- Secure figurine with foam insert or bubble wrap
- Include: packing slip, care instructions, thank-you card with social media handles
- For gift orders: optional gift wrapping (future upsell)

### 5. Shipping
- **Czech Republic:** Zasilkovna — create label, schedule pickup or drop at collection point
- **EU/International:** DHL — create label, schedule courier pickup
- Update order status to "shipped" with tracking number
- Send shipping notification email to customer with tracking link

### 6. Post-Delivery
- Monitor for delivery confirmation
- Update order status to "delivered"
- Send follow-up email: satisfaction check + review request + referral incentive
