---
name: vendor-evaluation
description: >
  Vendor evaluation framework for Figurio's supply chain —
  criteria for assessing printing partners, shipping providers,
  and material suppliers with scoring methodology and decision matrix.
---

# Vendor Evaluation

## When to Use

When evaluating a new printing partner, shipping provider, or any vendor in the supply chain.

## Evaluation Criteria

### Printing Partners (MCAE and alternatives)

| Criterion | Weight | How to Assess |
|-----------|--------|---------------|
| Print quality | 30% | Request sample prints across all size tiers, evaluate color accuracy, surface finish, detail resolution |
| Per-unit pricing | 25% | Get quotes for small/medium/large at volumes of 10, 50, 100 units/month |
| Turnaround time | 20% | Measure from file submission to finished print delivery |
| Reliability | 15% | Track on-time delivery rate, defect rate over first 10 orders |
| Communication | 10% | Responsiveness, transparency, willingness to share production status |

### Shipping Partners (Zasilkovna, DHL)

| Criterion | Weight | How to Assess |
|-----------|--------|---------------|
| Delivery speed | 25% | Average days to delivery by zone (CZ, EU, international) |
| Cost per shipment | 30% | Rates for figurine-sized packages (weight, dimensions) |
| Tracking quality | 20% | Real-time tracking, customer-facing tracking page quality |
| Insurance/claims | 15% | Coverage for damaged goods, claims process speed |
| Integration | 10% | API availability, label generation, pickup scheduling |

## Decision Matrix Template

```
Vendor A vs Vendor B

| Criterion | Weight | Vendor A Score (1-5) | Weighted | Vendor B Score (1-5) | Weighted |
|-----------|--------|---------------------|----------|---------------------|----------|
| Quality   | 30%    | 4                   | 1.2      | 3                   | 0.9      |
| Price     | 25%    | 3                   | 0.75     | 5                   | 1.25     |
| ...       | ...    | ...                 | ...      | ...                 | ...      |
| TOTAL     | 100%   |                     | X.XX     |                     | X.XX     |
```

## Red Flags

- Won't provide sample prints before commitment
- No volume discount structure
- Turnaround times longer than 10 business days for standard orders
- Defect rate above 5%
- No written SLA or contract terms
