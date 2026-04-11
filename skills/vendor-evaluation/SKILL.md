---
name: vendor-evaluation
description: >
  Framework for evaluating 3D printing partners for Figurio's D2C figurine business.
  Covers MCAE pricing negotiation across Small (8cm), Medium (15cm), and Large (25cm) size
  tiers, quality benchmarks for PolyJet output, turnaround SLAs, and alternative vendor
  assessment criteria to maintain supply resilience.
allowed-tools:
  - Read
  - Write
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - vendor-management
      - printing
---

# Vendor Evaluation

## When to Use

Use this skill when:
- Negotiating pricing with MCAE or reviewing contract renewals
- A quality complaint signals a benchmark regression
- Evaluating a new 3D printing vendor as a backup or replacement for MCAE
- Assessing whether current SLAs are being met on a monthly/quarterly basis

## MCAE — Primary Vendor

MCAE (mcae.cz) prints all Figurio figurines on the Stratasys J55 PolyJet printer. This is the sole
active print partner. All negotiation and quality management targets MCAE first.

### Pricing Benchmarks by Size Tier

Negotiate per-unit pricing against these reference tiers. Costs include print material and
post-processing (support removal, surface cure); they exclude packaging and shipping.

| Tier   | Dimensions | Volume proxy | Target unit cost (CZK) | Walk-away ceiling (CZK) |
|--------|------------|--------------|------------------------|--------------------------|
| Small  | ~8 cm      | Low          | ≤ 290 CZK              | 360 CZK                  |
| Medium | ~15 cm     | Medium       | ≤ 680 CZK              | 820 CZK                  |
| Large  | ~25 cm     | High         | ≤ 1 450 CZK            | 1 750 CZK                |

Update these benchmarks after each signed contract. Volume discounts apply when monthly order
counts exceed: Small ≥ 150 units, Medium ≥ 60 units, Large ≥ 20 units.

### Negotiation Levers

- **Batch scheduling** — committing to weekly fixed print batches (rather than ad-hoc) reduces
  MCAE's setup cost; use as a trade for lower per-unit rates.
- **Forecast sharing** — provide a rolling 6-week demand forecast to justify volume discounts.
- **Payment terms** — standard is net-30; offering net-14 can unlock a 1–2% discount.
- **Exclusivity clause** — avoid committing to exclusivity; Figurio needs the right to qualify
  alternative vendors.

## Quality Benchmarks

All finished figurines must pass the following before shipment:

| Criterion              | Acceptable standard                                                      |
|------------------------|--------------------------------------------------------------------------|
| Surface resolution     | ≤ 0.1 mm layer lines visible to naked eye at 30 cm                      |
| Color accuracy         | ΔE ≤ 4 vs. approved digital reference (measured with colorimeter)        |
| Structural integrity   | No delamination, no warping beyond 0.5 mm deviation on base plane        |
| Support artifacts      | No visible support marks on front-facing surfaces                        |
| Dimensional tolerance  | ±1 mm on stated tier height (8 cm / 15 cm / 25 cm)                      |

Reject rates above 3% in any rolling 4-week window trigger a formal quality review with MCAE.

## Turnaround SLAs

| Event                          | SLA                           |
|--------------------------------|-------------------------------|
| MCAE confirms receipt of files | Within 4 business hours       |
| Small tier print completion    | 3 business days from file go  |
| Medium tier print completion   | 4 business days from file go  |
| Large tier print completion    | 5 business days from file go  |
| Replacement for rejected units | 3 business days, no charge    |

SLA breaches (>1 per calendar month) must be logged and raised formally. Three breaches in a
quarter trigger escalation to contract renegotiation or vendor switch assessment.

## Alternative Vendor Assessment

Maintain at least one qualified backup vendor to reduce single-source risk. Evaluate alternatives
annually or whenever MCAE breaches SLAs three times in a quarter.

### Qualification Criteria for Backup Vendors

1. **Technology match** — PolyJet or equivalent full-colour, multi-material inkjet process.
   FDM is not an acceptable substitute for figurine quality.
2. **Geographic proximity** — Preferably CZ/SK/PL to maintain shipping cost parity.
3. **Capacity** — Able to absorb at least 50% of Figurio's monthly volume on 2-week notice.
4. **Pricing** — Within 15% of MCAE rates at equivalent volume tiers.
5. **Sample run** — One approved sample batch (minimum 3 units per tier) before vendor is
   listed as qualified backup.

### Evaluation Scorecard

Score each candidate vendor 1–5 on each dimension:

| Dimension              | Weight |
|------------------------|--------|
| Print quality          | 30%    |
| Pricing vs. MCAE       | 25%    |
| Turnaround speed       | 20%    |
| Communication quality  | 15%    |
| Geographic proximity   | 10%    |

A weighted score below 3.5 disqualifies the vendor from backup status.

## Anti-patterns

- Do not accept verbal pricing agreements — all rates must be in writing before placing orders.
- Do not share Figurio customer data (names, addresses) with MCAE; send only print files and
  order reference IDs.
- Do not skip the sample run step when qualifying a new vendor, even under time pressure.
