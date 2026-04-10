---
name: vendor-evaluation
description: >
  Framework for evaluating and scoring printing partners (MCAE and alternatives),
  shipping providers (Zásilkovna, DHL), and material suppliers for Figurio's
  3D-printed figurine business. Covers scoring criteria, cost comparison templates,
  SLA requirements, and quality standards specific to PolyJet figurine production.
allowed-tools:
  - Read
  - Write
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - vendors
      - procurement
---

# Vendor Evaluation

## When to Use

Use this skill when assessing current or prospective vendors — printing partners,
shipping carriers, or material suppliers. Run a full evaluation annually for each
active vendor, or ad hoc when a new vendor is being onboarded or a current vendor
raises concerns.

## Printing Partners

### Current Primary Vendor: MCAE (mcae.cz)

MCAE operates a Stratasys J55 PolyJet printer and is Figurio's sole production
partner. All evaluation of alternatives must be benchmarked against MCAE's
current baseline.

### Scoring Criteria for Printing Partners

Score each criterion 1–5. Minimum acceptable total: **32 / 50**.

| Criterion | Weight | Notes |
|-----------|--------|-------|
| Print quality — surface finish (PolyJet or equivalent) | 5x | Must support multi-material/full-color at figurine scale |
| Dimensional accuracy (±0.2 mm target) | 5x | Test with calibration figurine at each size tier |
| Turnaround time — standard lead | 4x | Target: Small ≤3 BD, Medium ≤4 BD, Large ≤5 BD |
| Turnaround time — rush capability | 3x | Can MCAE or alternative prioritise on short notice? |
| Defect / rework rate | 5x | Track defects per 100 units; target <3% |
| File format support (STL, OBJ, 3MF) | 3x | Must accept all three without surcharge |
| Communication responsiveness | 3x | Response within 4 business hours |
| Pricing per tier (CZK) | 5x | See cost comparison section below |
| Capacity — peak headroom | 4x | Can handle 50-unit surges without SLA slip |
| Location / logistics compatibility | 3x | CZ-based strongly preferred for shipping speed |

### Cost Comparison Template — Printing

Record actual quoted prices per unit for each size tier:

| Size | Target Cost Ceiling | MCAE Current | Alternative A | Alternative B |
|------|---------------------|--------------|---------------|---------------|
| Small (~8 cm) | 350 CZK | | | |
| Medium (~15 cm) | 750 CZK | | | |
| Large (~25 cm) | 1 400 CZK | | | |

Include setup fees, file-handling fees, and packaging surcharges in unit cost.

### Quality Standards for Figurine Prints

Any print vendor must meet all of the following before approval:

- Layer lines not visible to the naked eye on exterior surfaces (PolyJet or SLA minimum)
- Full-color capability without post-painting requirement
- Support removal must not leave marks deeper than 0.3 mm on display faces
- Color accuracy: Delta-E ≤ 5 vs. reference render (use provided test figurine)
- Wall thickness ≥ 1.5 mm on all structural elements (enforced pre-submission)

### SLA Requirements — Printing Partners

| Metric | Minimum Acceptable |
|--------|--------------------|
| On-time delivery (vs. committed date) | ≥ 95% of orders |
| Defect rate (print failures, color errors) | < 3% of units |
| File rejection rate | < 2% (with actionable feedback within 1 BD) |
| Emergency turnaround (48 h) availability | At least 2× per month |

---

## Shipping Providers

### Current Providers

- **Zásilkovna** — CZ domestic, standard parcel delivery, pickup-point network
- **DHL** — EU cross-border, tracked express service

### Scoring Criteria for Shipping Providers

Score each criterion 1–5. Minimum acceptable total: **24 / 35**.

| Criterion | Weight | Notes |
|-----------|--------|-------|
| Delivery success rate (first attempt) | 5x | Target ≥ 97% CZ domestic, ≥ 94% EU |
| Tracking granularity | 4x | Real-time scan events required |
| Damage/loss rate for fragile parcels | 5x | Figurines are fragile — critical criterion |
| Pricing per shipment (CZK) | 4x | See cost comparison below |
| Integration (API / label generation) | 4x | Must support automated label creation |
| Customer claim resolution speed | 3x | Target: < 5 BD for damage claims |
| Coverage — CZ parcel points (Zásilkovna) | 5x | ≥ 3 000 pickup points required |
| EU zone coverage (DHL) | 5x | All EU27 countries required |

### Cost Comparison Template — Shipping

| Route | Max Weight | Target Cost | Zásilkovna Current | DHL Current |
|-------|------------|-------------|-------------------|-------------|
| CZ domestic — Small | ≤ 0.5 kg | 90 CZK | | |
| CZ domestic — Medium | ≤ 1.0 kg | 110 CZK | | |
| CZ domestic — Large | ≤ 2.0 kg | 140 CZK | | |
| EU standard — Small | ≤ 0.5 kg | 280 CZK | — | |
| EU standard — Large | ≤ 2.0 kg | 520 CZK | — | |

### SLA Requirements — Shipping Providers

| Metric | Zásilkovna (CZ) | DHL (EU) |
|--------|-----------------|----------|
| Transit time | ≤ 3 business days | ≤ 5 business days |
| Damage claim resolution | < 5 BD | < 7 BD |
| Max acceptable damage rate | < 1.5% | < 2% |
| Tracking update frequency | Every scan point | Every scan point |

---

## Material Suppliers

Figurio does not purchase materials directly — MCAE sources consumables. If
in-house printing is ever considered, evaluate material suppliers on:

- VeroClear / VeroWhitePlus or certified Stratasys-compatible equivalents
- Price per kg vs. Stratasys direct pricing (benchmark: Stratasys list price)
- Shelf life certification and batch traceability
- Compatibility certification for J55 or target printer

---

## Evaluation Cadence

| Vendor Type | Full Evaluation | Spot Check |
|-------------|----------------|------------|
| Printing partner (MCAE) | Annually (Q1) | After any defect spike (>5% in a month) |
| Zásilkovna | Annually (Q2) | After any damage claim cluster (3+ in a week) |
| DHL | Annually (Q2) | After any damage claim cluster |
| New candidate vendor | Before onboarding | After first 50-unit trial run |

## Escalation Threshold

Flag for CTO/CEO review if any active vendor falls below minimum score or misses
SLA thresholds for two consecutive months.
