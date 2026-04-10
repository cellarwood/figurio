---
name: fulfillment-sop
description: >
  Figurio order fulfillment standard operating procedures. Covers print file
  preparation and submission to MCAE, QA checklist for received figurines across
  Small/Medium/Large tiers, shipping label generation for Zasilkovna (CZ/SK)
  and DHL (EU), branded packaging standards, and exception handling for damaged
  or defective prints.
metadata:
  paperclip:
    tags:
      - operations
      - fulfillment
      - shipping
      - quality
---

# Fulfillment SOP

## Overview

Figurio's fulfillment flow has four stages:

1. **File prep** — prepare and submit print-ready files to MCAE
2. **QA** — inspect received figurines before packaging
3. **Packaging** — apply branded packaging standards
4. **Shipping** — generate labels and dispatch via Zasilkovna or DHL

---

## Stage 1: Print File Preparation for MCAE

### File Format Requirements

- Export format: **3MF** (preferred) or **VRML 2.0 (.wrl)** with embedded textures
- Color space: **sRGB**, ICC profile embedded
- Resolution: texture maps at minimum **1024×1024 px** per 8 cm of height
- Units: millimeters
- Orientation: upright (base flat on Z=0), supports minimal-contact side facing up

### Pre-submission Checklist

- [ ] Geometry is manifold (watertight mesh, no open edges)
- [ ] Scale verified: Small = 80 mm ±1 mm, Medium = 150 mm ±1 mm, Large = 250 mm ±1 mm
- [ ] Color file matches approved customer render (for AI custom / scan-to-print orders)
- [ ] File named with order ID: `FIG-{order_id}-{tier}-{version}.3mf`
- [ ] No metadata or customer PII embedded in file
- [ ] File size under 150 MB (MCAE portal limit); decimate mesh if over

### Submission

- Upload via MCAE client portal at mcae.cz
- Select job type: **Catalog** or **Custom** (custom jobs trigger manual review at MCAE)
- Note submission timestamp in the order management system
- Expected file approval notification: within 1 business day

---

## Stage 2: QA Checklist for Received Figurines

Perform QA on every unit before packaging. Log pass/fail per item in the order system.

### Visual Inspection

- [ ] Color matches the approved render — no major hue shift or missing texture regions
- [ ] No visible support scarring on primary-view surfaces (face, front torso)
- [ ] No surface cracking, delamination, or incomplete cure patches
- [ ] No white/gray bleed where colored areas should be solid

### Dimensional Check (sample 1 in 10, all Large tier)

- [ ] Height within ±2 mm of nominal for tier
- [ ] Base is flat — figurine stands without rocking

### Structural Check

- [ ] No broken or cracked thin features (fingers, weapons, accessories)
- [ ] Joints/connectors (if applicable) fit correctly

### Packaging Readiness

- [ ] Surface is clean — no support material residue, dust, or fingerprints
- [ ] UV-resistant clear coat applied (MCAE applies by default; verify it is present)

**QA outcome codes:**

| Code | Meaning                          | Action                        |
|------|----------------------------------|-------------------------------|
| PASS | All checks passed                | Proceed to packaging          |
| MINR | Minor cosmetic defect            | Ops discretion; document      |
| FAIL | Structural or major color defect | Initiate reprint (see Exceptions) |

---

## Stage 3: Branded Packaging Standards

### Box Selection by Tier

| Tier   | Box Dimensions (mm) | Insert Type         |
|--------|---------------------|---------------------|
| Small  | 120 × 120 × 120     | Die-cut foam inlay  |
| Medium | 200 × 200 × 200     | Die-cut foam inlay  |
| Large  | 320 × 320 × 320     | Double-wall + foam  |

### Packaging Contents

1. Figurine in foam inlay, base centered and secured
2. **Figurio branded tissue paper** — wrap figurine before placing in inlay
3. **Thank-you card** — include correct language variant (CZ for CZ/SK orders, EN for EU)
4. **Care card** — UV sensitivity warning, cleaning instructions (pre-printed insert)
5. Seal box with Figurio branded tape

### Do Not Include

- No loose packing peanuts (customer complaint risk, brand inconsistency)
- No promotional flyers unless a campaign insert has been approved by marketing
- No invoice with pricing — order confirmation is sent digitally only

---

## Stage 4: Shipping Label Generation

### Carrier Selection

| Destination       | Carrier      | Service Level                    |
|-------------------|-------------|----------------------------------|
| Czech Republic    | Zasilkovna  | Standard (2–3 business days)     |
| Slovakia          | Zasilkovna  | Standard (3–4 business days)     |
| EU (excl. CZ/SK)  | DHL         | Express Worldwide (2–4 bus. days)|

### Zasilkovna (CZ/SK)

- Generate label via Zasilkovna API or Packeta client portal
- Select pickup point from customer's chosen branch at checkout (stored on order)
- Package weight: use tier defaults unless actual weight deviates by >50 g
  - Small: 200 g | Medium: 500 g | Large: 1 200 g
- Print label, affix to top of box — do not cover seams

### DHL (EU)

- Generate label via DHL Express API (business account)
- Declare contents: "Decorative figurine — 3D printed resin" — value as per order
- Select DHL Express Worldwide; enable delivery notification SMS/email
- Affix DHL label and customs invoice (CN22 for non-EU if applicable) to top of box

### Dispatch

- Hand off to carrier pickup by **14:00 local time** for same-day dispatch
- Log tracking number against order ID in the order management system
- Tracking number is auto-emailed to customer on label generation (verify integration)

---

## Exception Handling

### Damaged or Defective Prints (FAIL QA)

1. Photograph defect before any handling (for MCAE claim)
2. Log in order system: order ID, defect code, defect description, photo attached
3. Submit reprint request to MCAE via portal — reference original order ID and attach photos
4. Notify customer proactively: estimated reprint + re-ship date
5. MCAE reprint SLA: same as original (3/4/5 business days by tier)
6. If reprint also fails QA, escalate to MCAE account manager and issue customer refund

### Lost in Transit

- Zasilkovna: open claim after 7 business days past expected delivery; Zasilkovna
  compensates up to 1 000 CZK unless additional insurance was added at label creation
- DHL: open claim after 5 business days; DHL Express covers declared value up to €100
- Issue replacement shipment to customer once claim is opened (do not wait for resolution)

### Customer-Reported Damage on Arrival

- Request photo evidence within 48 hours of delivery
- If confirmed: issue reprint or refund per customer preference
- Use photo evidence for carrier claim if packaging failure is the cause
- Log all damage claims to track packaging adequacy by tier

### File Rejection by MCAE

- MCAE will notify via portal with rejection reason
- Fix the flagged issue (geometry, scale, file size) and resubmit within 1 business day
- If rejection reason is unclear, contact MCAE technical support directly
- Log rejection reason to identify recurring file prep issues
