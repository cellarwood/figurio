---
name: vendor-evaluation
description: >
  Evaluate and manage Figurio's sole printing partner MCAE (mcae.cz), which
  produces all 3D-printed figurines on Stratasys J55 PolyJet. Covers per-unit
  pricing across small/medium/large size tiers, turnaround SLAs, quality
  acceptance standards, and the two shipping providers (Zásilkovna, DHL).
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - vendor
      - fulfillment
---

# Vendor Evaluation — MCAE (mcae.cz)

## Overview

MCAE is Figurio's exclusive outsourced printing partner. All figurines are
produced on the Stratasys J55 PolyJet printer, which delivers full-color,
multi-material output without post-processing painting. Because MCAE is a
single-source supplier, evaluations focus on SLA adherence, per-unit cost
tracking, and quality consistency rather than comparative vendor scoring.

---

## Size Tiers

Figurio defines three production tiers. All pricing and SLA discussions with
MCAE must reference these tiers explicitly:

| Tier   | Nominal height | Typical volume range |
|--------|---------------|----------------------|
| Small  | ~8 cm         | Low material use     |
| Medium | ~15 cm        | Mid material use     |
| Large  | ~25 cm        | High material use    |

When requesting quotes or reviewing invoices, verify line items map to one of
these three tiers. Any MCAE proposal that introduces a fourth tier or bundles
tiers must be flagged for COO review before acceptance.

---

## Per-Unit Pricing

- Negotiate and lock pricing per tier on a quarterly basis.
- Track actual invoiced cost per unit in the fulfillment cost sheet alongside
  Stripe revenue per order to maintain margin visibility.
- Watch for material surcharges — J55 PolyJet resin prices fluctuate. MCAE may
  request mid-quarter adjustments; these require COO sign-off.
- Volume discounts apply when monthly unit count crosses agreed thresholds.
  Confirm thresholds are documented in the current MCAE contract addendum.

---

## Turnaround SLAs

Standard MCAE turnaround commitments (business days from confirmed print file
receipt):

| Tier   | Standard SLA | Rush SLA (if offered) |
|--------|-------------|----------------------|
| Small  | 3 BD        | 1–2 BD               |
| Medium | 4 BD        | 2–3 BD               |
| Large  | 5–6 BD      | 3–4 BD               |

- SLA clock starts when MCAE confirms the print file is print-ready (not on
  file upload).
- Track SLA adherence monthly. If MCAE misses SLA on more than 5% of units in
  a rolling 30-day window, escalate via formal notice per contract terms.
- Holiday closures at MCAE's facility (Czech public holidays) must be factored
  into customer-facing delivery estimates.

---

## Quality Standards

Figurio accepts a figurine from MCAE only if it meets all of the following:

1. **Color accuracy** — visible colors match the submitted 3D model within
   acceptable tolerance (no washed-out or shifted hues on skin tones or
   clothing).
2. **Surface finish** — no visible layer lines, delamination, or support
   artifact scars on front-facing surfaces.
3. **Dimensional accuracy** — height within ±2 mm of nominal tier size.
4. **Structural integrity** — no cracks, brittle joints, or broken extremities
   (fingers, accessories).
5. **Base stability** — figurine stands unsupported on a flat surface.

Any unit failing one or more criteria is a **reject**. Log rejects by order ID
and tier, and request MCAE reprint at no additional charge per SLA terms.
Sustained reject rates above 2% trigger a formal quality review meeting with
MCAE.

---

## Shipping Providers

Figurio ships finished figurines via two carriers. MCAE hands off to the
carrier after packaging at their facility.

### Zásilkovna
- Used for domestic Czech Republic orders and select CEE destinations.
- Lower cost, extensive parcelshop pickup network.
- Preferred for small and medium tiers where delivery speed is less critical.

### DHL
- Used for international orders outside Zásilkovna's network and for customers
  selecting express delivery.
- Higher cost; justified for large-tier orders (higher AOV) and international.
- Track DHL invoices separately — surcharges (fuel, remote area) can erode
  margin on small international orders.

When evaluating MCAE performance, include carrier handoff timing: MCAE must
dispatch to the carrier on the same business day the print is completed and
QA-passed.

---

## Periodic Evaluation Cadence

| Review type        | Frequency | Owner       |
|--------------------|-----------|-------------|
| SLA adherence      | Monthly   | COO         |
| Per-unit cost audit | Quarterly | COO + Finance |
| Quality reject rate | Monthly   | COO         |
| Contract renewal   | Annual    | COO + Legal |

Maintain a running MCAE scorecard. Use it as the primary input for annual
contract negotiations.
