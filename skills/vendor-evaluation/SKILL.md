---
name: vendor-evaluation
description: >
  MCAE vendor management for Figurio's 3D-printed figurine production. Covers
  Stratasys J55 PolyJet pricing negotiation across Small/Medium/Large size tiers,
  SLA and quality metric tracking, volume discount trigger thresholds, and
  evaluation criteria for alternative PolyJet printing partners.
metadata:
  paperclip:
    tags:
      - operations
      - vendor
      - procurement
---

# Vendor Evaluation

## When to Use

Use this skill when:
- Reviewing or renegotiating the MCAE printing contract
- Tracking MCAE's SLA compliance or quality scores over a period
- Evaluating whether volume discount thresholds have been reached
- Assessing alternative PolyJet printers as backup or replacement vendors

---

## MCAE as Primary Vendor

Figurio's exclusive printing partner is **MCAE Systems (mcae.cz)**, operating
Stratasys J55 PolyJet printers. The J55 is required for full-color, high-detail
figurine output — vendor alternatives must support PolyJet or equivalent
full-color resin multi-material technology.

---

## Size Tiers and Pricing Structure

Figurio uses three standard size tiers. Pricing is negotiated per tier:

| Tier   | Approx. Height | Key Cost Drivers                         |
|--------|---------------|------------------------------------------|
| Small  | ~8 cm         | Material volume, support material waste  |
| Medium | ~15 cm        | Material volume, print time              |
| Large  | ~25 cm        | Material volume, print time, tray usage  |

When negotiating with MCAE:
- Request itemized breakdown per tier (material cost, machine time, setup fee)
- Benchmark against published Stratasys J55 material consumption rates
- Push for fixed per-unit pricing per tier rather than time-based billing
- Negotiate separate rates for standard catalog prints vs. AI custom/scan-to-print
  jobs (custom jobs carry higher complexity and may require pre-flight review)

---

## Volume Discount Triggers

Track cumulative monthly unit volumes across all tiers. Proposed discount brackets:

| Monthly Units (all tiers combined) | Target Discount vs. Base Rate |
|------------------------------------|-------------------------------|
| 50–99                              | 5%                            |
| 100–199                            | 10%                           |
| 200+                               | 15–20% (negotiate annually)   |

- Review volume against thresholds at the end of each calendar month
- Flag to MCAE when a new threshold is first crossed to trigger renegotiation
- Document agreed discount rates and effective dates in the vendor contract log

---

## SLA Tracking

Key SLAs to track per order batch submitted to MCAE:

| Metric                        | Target                          |
|-------------------------------|---------------------------------|
| Print turnaround (Small)      | ≤ 3 business days from file approval |
| Print turnaround (Medium)     | ≤ 4 business days               |
| Print turnaround (Large)      | ≤ 5 business days               |
| File rejection rate           | < 5% of submitted files         |
| Reprint request rate          | < 3% of units shipped           |
| On-time delivery to Figurio   | ≥ 95% of batches                |

- Log each batch: submission date, file approval date, ship date from MCAE
- Calculate rolling 30-day averages for all metrics
- Escalate to MCAE account manager if any metric misses target for 2 consecutive weeks

---

## Quality Metrics

Assess quality on received shipments using the QA checklist (see `fulfillment-sop`
skill). Summarize vendor-facing quality data monthly:

- **Color accuracy failures**: mismatch vs. approved render (log per unit)
- **Surface defects**: visible layer lines, support scarring, incomplete cure
- **Dimensional deviation**: measure against nominal height ± 2 mm tolerance
- **Breakage on arrival**: packaging-related vs. print brittleness (distinguish cause)

Report quality metrics to MCAE quarterly. Use failure rate trends as leverage
in annual contract reviews.

---

## Alternative Vendor Evaluation

Evaluate alternative vendors when:
- MCAE on-time delivery drops below 90% for 4+ consecutive weeks
- MCAE raises unit prices by more than 10% with less than 60 days notice
- Order volume exceeds MCAE's stated capacity (currently ~400 units/month on J55)

**Evaluation criteria for alternatives:**

1. **Technology match**: Must support full-color PolyJet or equivalent (e.g.,
   Stratasys J850, Mimaki 3DUJ series). FDM/SLA vendors are not suitable.
2. **Geographic location**: Prefer CZ/SK/DE to maintain shipping SLAs
3. **Minimum order**: Must accept single-unit custom orders (no MOQ)
4. **Color profile support**: Must accept Figurio's color-calibrated 3MF/VRML files
5. **Turnaround parity**: Must match or beat MCAE's turnaround targets above
6. **Pricing**: Request per-tier unit quotes and compare against current MCAE rates

Run a parallel test batch of 5–10 units across all three tiers before qualifying
any alternative vendor.

---

## Contract Review Cadence

- **Monthly**: Volume check, SLA metrics review, quality summary
- **Quarterly**: Formal quality review with MCAE, share defect data
- **Annually**: Full pricing renegotiation, update volume discount brackets,
  reassess alternative vendor landscape
