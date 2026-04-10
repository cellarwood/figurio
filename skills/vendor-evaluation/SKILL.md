---
name: vendor-evaluation
description: >
  Framework for evaluating and managing Figurio's two critical external partners —
  print partner MCAE (Stratasys J55 PolyJet, mcae.cz) and shipping provider Zásilkovna.
  Covers pricing benchmarks, SLA thresholds, quality metrics, escalation triggers,
  and periodic review cadence for both vendors.
allowed-tools:
  - Read
  - Write
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - vendors
      - quality
---

# Vendor Evaluation

## When to Use

Invoke this skill when:
- Conducting a scheduled quarterly vendor review for MCAE or Zásilkovna
- An SLA breach or quality incident requires a structured assessment
- Evaluating whether to renegotiate terms, add a backup vendor, or escalate a concern
- Onboarding a potential alternative print or shipping partner

---

## Vendors Overview

| Vendor | Role | Contract Type |
|--------|------|---------------|
| MCAE Systems (mcae.cz) | 3D print production — Stratasys J55 PolyJet | Per-order pricing, outsourced production |
| Zásilkovna | Last-mile shipping, parcel network CZ/SK/EU | Per-shipment rate, API integration |

---

## MCAE — Print Partner

### Pricing Benchmarks

Track cost-per-unit by size tier. Flag for renegotiation if actual invoiced cost drifts more than 10% above agreed rates:

| Size Tier | Target Unit Cost (CZK) | Max Tolerance |
|-----------|------------------------|---------------|
| Small (~8 cm) | Establish baseline at contract review | +10% |
| Medium (~15 cm) | Establish baseline at contract review | +10% |
| Large (~25 cm) | Establish baseline at contract review | +10% |

Material surcharges (support material waste, PolyJet resin) must be itemized on every invoice. Reject invoices that bundle production and material costs without line-item breakdown.

### SLA Thresholds

| Metric | Target | Breach Threshold |
|--------|--------|-----------------|
| Production lead time (Small/Medium) | ≤ 3 business days | > 4 business days |
| Production lead time (Large) | ≤ 5 business days | > 6 business days |
| File acknowledgement (after handoff) | ≤ 4 hours (business hours) | > 8 hours |
| Reprint turnaround (defect-caused) | ≤ 2 business days | > 3 business days |

Any breach triggers an immediate written notification to MCAE and is logged in the SLA breach register.

### Quality Metrics

Score each incoming batch on a 1–5 scale for:
- **Color fidelity** — match to reference render from Figurio's AI pipeline
- **Surface finish** — no layer artifacts, no support scarring visible on display surfaces
- **Dimensional accuracy** — within ±0.5 mm on critical axes for all size tiers
- **Structural integrity** — no cracks, delamination, or hollow failures

A batch with any unit scoring ≤ 2 on any metric is rejected in full. Units scoring 3 on color fidelity are accepted with a note for trend tracking. Three consecutive batches with a score of 3 on color fidelity trigger a formal calibration request to MCAE.

### Escalation Triggers (MCAE)

Escalate to CTO + COO immediately if any of the following occur:
- Two or more SLA breaches in a rolling 30-day period
- Defect rate exceeds 5% across any monthly batch
- MCAE unable to produce a size tier for > 5 consecutive business days
- Invoice discrepancies > 5% unresolved after 48 hours

---

## Zásilkovna — Shipping Provider

### Pricing Benchmarks

Benchmark against published Zásilkovna B2B rate card. Flag if per-shipment cost exceeds agreed tier by more than 8%. Monitor:
- Base parcel rate (CZ domestic vs. SK vs. EU destinations)
- Pickup surcharges (if applicable)
- COD fee (not used by Figurio — Stripe-only — confirm this remains off)

### SLA Thresholds

| Metric | Target | Breach Threshold |
|--------|--------|-----------------|
| CZ domestic delivery | ≤ 2 business days | > 3 business days |
| SK delivery | ≤ 3 business days | > 4 business days |
| EU delivery | ≤ 5 business days | > 7 business days |
| Label generation API response time | < 2 seconds p95 | > 5 seconds p95 |
| Tracking event update latency | ≤ 4 hours after scan | > 8 hours |

### Quality Metrics

| Metric | Target | Review Trigger |
|--------|--------|---------------|
| Successful first-attempt delivery rate | ≥ 95% | < 92% in a month |
| Parcel damage rate (customer-reported) | < 0.5% of shipments | > 1% in a month |
| Lost parcel rate | < 0.1% of shipments | > 0.3% in a month |
| Customer-facing tracking accuracy | ≥ 98% events correct | < 95% in a month |

Damage and loss data is sourced from Figurio's customer support tickets, cross-referenced against Zásilkovna's claims portal.

### Escalation Triggers (Zásilkovna)

Escalate to COO + CMO if:
- Delivery SLA breach rate exceeds 5% of monthly shipments for a given destination zone
- API outage or label generation failure exceeds 30 minutes
- Damage or loss rate hits the review trigger threshold two months in a row

---

## Periodic Review Cadence

| Review Type | Frequency | Participants | Output |
|-------------|-----------|--------------|--------|
| MCAE quality snapshot | Monthly | Head of Ops | SLA + quality scorecard |
| Zásilkovna delivery report | Monthly | Head of Ops | Delivery metrics report |
| Full vendor business review | Quarterly | Head of Ops + COO | Scorecard + action items sent to vendor |
| Contract/rate renegotiation | Annually or on trigger | COO + Head of Ops | Updated pricing agreement |

Quarterly reviews must include a written summary sent to each vendor within 5 business days of the review date. Action items are tracked with owners and due dates.

---

## Backup Vendor Readiness

Figurio currently has no active backup print vendor. The Head of Operations should maintain a shortlist of at least one alternative PolyJet-capable print partner (evaluated annually) and document a switchover runbook in the `references/` folder of this skill.

---

## Anti-patterns

- Do not evaluate MCAE solely on cost — color fidelity is core to Figurio's product promise
- Do not accept bundled MCAE invoices without line-item material breakdown
- Do not escalate individual one-off parcel delays to Zásilkovna — only escalate pattern-level failures
- Do not renegotiate vendor contracts without COO sign-off
