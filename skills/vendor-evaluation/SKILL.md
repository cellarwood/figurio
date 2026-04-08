---
name: vendor-evaluation
description: Vendor evaluation framework for Figurio operations — criteria for assessing printing partners, shipping providers, and packaging suppliers.
---

# Vendor Evaluation Framework

## Purpose

Standardize how Figurio evaluates and selects vendors for printing, shipping, and packaging. Every vendor decision must be data-driven, documented, and reviewed quarterly.

## General Evaluation Criteria

All vendors are assessed across these six dimensions:

| Criterion                    | Weight | Description                                              |
|------------------------------|--------|----------------------------------------------------------|
| Pricing per unit             | 25%    | Cost competitiveness at current and projected volumes.    |
| Quality consistency          | 25%    | Defect rate, color accuracy, surface finish reliability.  |
| Turnaround time              | 20%    | Order-to-delivery speed and predictability.               |
| Minimum order quantities     | 10%    | Flexibility for small batches and custom one-offs.        |
| Communication responsiveness | 10%    | Response time, escalation process, dedicated contact.     |
| Scalability                  | 10%    | Ability to handle 2x-5x volume during peak seasons.      |

## Scoring Matrix

Rate each criterion 1-5:

| Score | Meaning                                                 |
|-------|---------------------------------------------------------|
| 5     | Excellent — exceeds requirements significantly.          |
| 4     | Good — meets all requirements with minor extras.         |
| 3     | Acceptable — meets minimum requirements.                 |
| 2     | Below standard — requires workarounds or compromises.    |
| 1     | Unacceptable — does not meet minimum requirements.       |

**Weighted score** = sum of (criterion score x weight).
**Minimum threshold**: Weighted score of 3.0 to be considered.
**Target**: Weighted score of 3.8+ for primary vendors.

## Printing Partner Evaluation (MCAE Focus)

### MCAE-Specific Assessment

MCAE (Materialise Certified Additive Enterprise) is Figurio's primary printing partner for PolyJet technology.

#### PolyJet Quality Metrics

- **Color accuracy**: Compare printed output to digital preview using a standard color card. Acceptable delta-E variance: < 5.
- **Surface finish**: Smooth, matte finish with no visible layer lines at 30cm viewing distance.
- **Dimensional accuracy**: Within +/- 0.2mm of the specified dimensions.
- **Support material removal**: Clean removal with no residue or surface damage.
- **Structural integrity**: No warping, cracking, or delamination after 48 hours.

#### PolyJet-Specific Checklist

- [ ] Supports Stratasys J-series PolyJet (full color, multi-material).
- [ ] Can print minimum wall thickness of 0.8mm reliably.
- [ ] Color gamut covers Figurio's standard palette (skin tones, vibrant primaries, metallics).
- [ ] Accepts STL and OBJ file formats with color data (VRML or 3MF preferred).
- [ ] Provides test prints for new designs before batch production.
- [ ] Turnaround: standard 5-7 business days, express 2-3 business days.

#### Alternative Printing Partners

Evaluate backup printing vendors against these requirements:
- Must support full-color 3D printing (PolyJet, binder jetting, or equivalent).
- Located in EU (shipping cost and time constraint).
- Can handle one-off custom orders (no minimum batch).
- API or portal for order submission (manual email ordering is a fallback, not primary).

## Shipping Vendor Comparison

### Zasilkovna (Packeta)

| Aspect                | Details                                        |
|-----------------------|------------------------------------------------|
| Coverage              | Czech Republic (primary), Slovakia, Poland, Hungary, Romania |
| Delivery model        | Pickup points (Z-Box, partner locations)       |
| Typical delivery time | 1-3 business days (CZ domestic)                |
| Pricing               | Competitive for CZ domestic, moderate for cross-border |
| Integration           | REST API for label generation and tracking      |
| Tracking              | Real-time via API and customer-facing portal    |
| Best for              | CZ domestic orders, budget-conscious customers  |
| Limitations           | Size limits for Z-Box lockers, no door delivery |

### DHL

| Aspect                | Details                                        |
|-----------------------|------------------------------------------------|
| Coverage              | EU-wide, global capability                     |
| Delivery model        | Door-to-door delivery                          |
| Typical delivery time | 2-5 business days (EU), 5-10 (international)  |
| Pricing               | Higher than Zasilkovna, premium service        |
| Integration           | REST API, well-documented                      |
| Tracking              | Detailed tracking with SMS/email notifications |
| Best for              | EU orders outside CZ/SK, premium shipping option|
| Limitations           | Higher cost, overkill for CZ domestic          |

### DPD (Potential Addition)

| Aspect                | Details                                        |
|-----------------------|------------------------------------------------|
| Coverage              | EU-wide                                        |
| Delivery model        | Door-to-door + Pickup Shop network             |
| Typical delivery time | 2-4 business days (EU)                         |
| Pricing               | Mid-range between Zasilkovna and DHL           |
| Best for              | Balanced EU coverage at moderate cost           |

### Shipping Vendor Selection Rules

- CZ domestic: Default to Zasilkovna (pickup point). Offer DHL as premium option.
- SK, PL, HU: Zasilkovna cross-border if available, DHL as fallback.
- DACH, rest of EU: DHL.
- Oversized figurines (XL tier): DHL only (Zasilkovna size limits).

## Packaging Supplier Checklist

### Requirements

- [ ] Custom branded boxes (Figurio logo, brand colors).
- [ ] Size variants matching figurine tiers: S (10x10x12cm), M (15x15x20cm), L (20x20x30cm), XL (25x25x35cm).
- [ ] Interior protection: custom foam insert or molded pulp for figurine shape.
- [ ] Eco-friendly materials (recyclable cardboard, minimal plastic).
- [ ] Unboxing experience: branded tissue paper, thank-you card, photo prompt card.
- [ ] Minimum order quantity under 500 units per size.
- [ ] Reorder lead time under 2 weeks.
- [ ] Cost per unit under 15% of the figurine's retail price.

### Packaging Quality Test

Before selecting a packaging supplier, order samples and test:
- [ ] Drop test: 1 meter drop on each face, figurine survives without damage.
- [ ] Ship test: send 5 packages via each shipping provider, check arrival condition.
- [ ] Visual test: does the unboxing feel premium? Would a customer share it on social media?

## Vendor Review Process

### Quarterly Review

Every quarter, review all active vendors:
1. Pull data: defect rates, delivery times, costs, responsiveness.
2. Update scoring matrix with current data.
3. Identify vendors below 3.0 threshold — create improvement plan or start replacement search.
4. Negotiate pricing based on volume growth.
5. Document findings and share with CEO and Head of Operations.

### Vendor Onboarding

When adding a new vendor:
1. Request samples and pricing sheet.
2. Complete the scoring matrix.
3. Run a trial period (10-20 orders over 2-4 weeks).
4. Compare trial results against existing vendor benchmarks.
5. Decision: onboard as primary, secondary, or reject.
6. Sign agreement with clear SLA terms (quality, turnaround, communication).

### Vendor Exit Criteria

Terminate a vendor relationship when:
- Defect rate exceeds 10% over any 30-day period.
- Delivery time exceeds SLA by more than 50% for 3 consecutive orders.
- Unresponsive to critical issues for more than 48 hours.
- Pricing increase exceeds 20% without proportional quality improvement.
