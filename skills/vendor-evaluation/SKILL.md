---
name: vendor-evaluation
description: >
  Evaluate and compare 3D printing vendors for Figurio's figurine production.
  MCAE (mcae.cz) is the primary vendor using Stratasys J55 PolyJet. Covers
  per-unit pricing across small/medium/large size tiers, print quality
  standards, turnaround time, volume capacity, and drop-ship capability for
  assessing backup or alternative vendors.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - procurement
      - vendors
---

# Vendor Evaluation

## When to Use

Use this skill when:
- Assessing a new vendor as a backup or replacement for MCAE
- Renegotiating terms with MCAE
- Comparing quotes from multiple vendors
- Auditing vendor performance against Figurio's quality and delivery standards

## Figurio Production Context

Figurio produces full-color 3D-printed figurines in three size tiers:

| Tier   | Approx. Height | Key Consideration          |
|--------|----------------|----------------------------|
| Small  | ~8 cm          | High volume, detail-critical|
| Medium | ~15 cm         | Core product, balance of cost and quality |
| Large  | ~25 cm         | Lower volume, premium margin |

**Technology requirement:** PolyJet (Stratasys J55 or equivalent). Alternatives using FDM or SLA are disqualifying — full-color photopolymer jetting is non-negotiable for Figurio's product quality.

**Current primary vendor:** MCAE Systems (mcae.cz), Stratasys authorized partner, Czech Republic.

## Evaluation Criteria

### 1. Per-Unit Pricing by Size Tier

Request itemized quotes for each tier at representative volumes (e.g., 10, 50, 100 units/month). Capture:

- Base print cost per unit (CZK or EUR)
- Material cost (PolyJet support + model resin)
- Post-processing cost (cleaning, support removal, surface finish)
- Setup/plate fee per batch
- Volume discount thresholds

Flag any vendor that cannot quote per-tier — bundled pricing obscures true cost at scale.

### 2. PolyJet Print Quality

Figurio figurines require:
- Full CMYK+W color fidelity (no color approximation or segmented coloring)
- Resolution: minimum 14 micron layer thickness (J55 standard)
- Surface smoothness adequate for unpainted figurines
- Accurate detail at 8 cm scale (fine facial features, text, logos)

Evaluation steps:
1. Request sample print of a standard Figurio test file (small-tier reference model)
2. Inspect color accuracy, layer visibility, and edge sharpness
3. Confirm J55 or equivalent machine — do not accept vendor claims without machine model verification

### 3. Turnaround Time

Measure from print file submission to goods ready for shipping:

| Acceptable | Marginal | Disqualifying |
|------------|----------|---------------|
| ≤ 5 business days | 6–8 business days | > 8 business days |

Confirm whether turnaround includes post-processing and QA, or print-only. Ask about rush capacity and associated surcharges.

### 4. Volume Capacity

Assess monthly throughput across all three tiers combined. Minimum acceptable capacity for a backup vendor: 200 units/month. For primary vendor consideration: 500+ units/month.

Ask explicitly:
- Max units/month on J55 (or equivalent) machines dedicated to Figurio-style work
- Lead time impact at 80% vs. 100% capacity
- Ability to scale up within 2 weeks for seasonal spikes (e.g., gift season Q4)

### 5. Drop-Ship Capability

Figurio's preferred model: vendor ships directly to end customer, bypassing Figurio warehouse.

Evaluate:
- Can vendor pack orders individually with Figurio's branded packaging inserts?
- Can vendor print Zásilkovna or DHL shipping labels on Figurio's account?
- Does vendor support per-order shipment or only batch pallet delivery?
- API or CSV-based order submission for drop-ship workflows?

Drop-ship capability is highly desirable but not disqualifying — vendors without it require Figurio to manage a receiving and re-ship step.

## Scoring Template

Rate each vendor 1–5 per criterion. Minimum acceptable total: 18/25.

| Criterion             | Weight | Score (1–5) | Weighted |
|-----------------------|--------|-------------|---------|
| Pricing competitiveness | 5x  |             |         |
| PolyJet quality         | 5x  |             |         |
| Turnaround time         | 5x  |             |         |
| Volume capacity         | 5x  |             |         |
| Drop-ship capability    | 5x  |             |         |
| **Total**             | **25** |             |         |

## MCAE Baseline (Reference)

Use MCAE's current terms as the benchmark when evaluating alternatives:
- Technology: Stratasys J55 PolyJet confirmed
- Location: Czech Republic (low shipping distance to CZ customers)
- Relationship: established, NDA in place, familiar with Figurio file formats

Any alternative vendor must score within 3 points of MCAE's total to justify a transition.

## Anti-Patterns

- Do not evaluate vendors based on FDM or SLA capability alone — full-color PolyJet is required
- Do not accept sample prints of the vendor's own demo models — always test with a Figurio reference file
- Do not compare pricing without normalizing to the same size tier and volume — raw quotes are misleading
- Do not onboard a backup vendor without a completed sample evaluation and signed NDA
