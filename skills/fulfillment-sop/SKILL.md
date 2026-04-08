---
name: fulfillment-sop
description: Standard operating procedures for Figurio order fulfillment — from payment capture through MCAE printing to Zasilkovna delivery
---

# Fulfillment SOP

Standard operating procedures for processing orders from payment to delivery.

## Catalog Order Flow

### 1. Order Received
- Stripe payment confirmed via webhook
- Order record created with status: `confirmed`
- Customer receives order confirmation email

### 2. Print File Preparation
- Retrieve pre-validated print file for the ordered figurine and size tier
- Verify file integrity (checksum match)
- Package print job: model file + size specifications + color profile
- Update order status: `preparing`

### 3. Submit to MCAE
- Send print job to MCAE via agreed submission method (email/portal/API)
- Record MCAE job reference number
- Update order status: `in_production`
- Expected turnaround: {per MCAE SLA — typically 3-5 business days}

### 4. Receive from MCAE
- Inspect finished figurine against quality checklist
- Quality checklist: color accuracy, surface finish, dimensional accuracy, no visible defects
- If defective: photograph defect, request reprint from MCAE, notify customer of delay
- If acceptable: proceed to packaging
- Update order status: `quality_check`

### 5. Package and Ship
- Package in branded Figurio box with protective padding
- Include: figurine, care instructions card, thank-you card
- Create Zasilkovna shipment via API
- Print and attach shipping label
- Update order status: `shipped`
- Send customer tracking notification

### 6. Delivery
- Monitor Zasilkovna tracking for delivery confirmation
- Update order status: `delivered`
- Trigger review request email (3 days after delivery)

## Custom Figurine Additional Steps

Between steps 1 and 2, the AI pipeline runs:
- AI generation → mesh repair → QA review → customer preview → approval
- Second payment captured on approval
- Then proceeds to standard print file submission

## Escalation Procedures

| Issue | Action | Timeline |
|-------|--------|----------|
| MCAE missed SLA | Contact MCAE, notify customer | Same day |
| Defective print | Request reprint, notify customer | 24 hours |
| Lost shipment | File Zasilkovna claim, offer reprint or refund | 48 hours |
| Customer complaint | Acknowledge within 4 hours, resolve within 48 hours | Immediate |
