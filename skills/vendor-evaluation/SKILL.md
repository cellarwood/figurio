---
name: vendor-evaluation
description: >
  Framework for evaluating Figurio's printing partners and shipping providers.
  Covers cost-per-unit benchmarking across figurine size tiers, print technology
  comparison (PolyJet vs SLA vs FDM), turnaround SLA assessment, geographic
  coverage, and drop-ship capability for Czech Republic and EU fulfillment.
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

Use this skill when assessing a new printing partner or shipping provider, renegotiating terms with existing vendors (MCAE, Zasilkovna, DHL), or comparing alternatives during capacity planning.

## Print Partner Evaluation

### Size Tier Cost Benchmarking

Figurio figurines fall into three size tiers. Collect cost-per-unit quotes for each:

| Tier | Dimensions | Key Cost Drivers |
|------|-----------|-----------------|
| S (small) | up to 80mm height | material volume, support waste |
| M (medium) | 81–150mm height | material volume, build time |
| L (large) | 151–250mm height | material volume, per-job setup amortization |

Request quotes for minimum viable batch sizes (e.g., 10, 50, 100 units) to understand volume breaks. Always request cost in CZK and EUR; note which currency the SLA penalty clauses use.

### Print Technology Comparison

Figurio's primary requirement is full-color, high-fidelity figurines. Evaluate each technology against this:

| Technology | Full Color | Surface Quality | Rigidity | Relative Cost | Notes |
|-----------|-----------|----------------|----------|---------------|-------|
| PolyJet (Stratasys J55) | Yes — best in class | Smooth, paintable | Moderate | High | Current standard via MCAE |
| SLA (resin) | Post-painted only | Very smooth | High | Medium | Not viable for catalog products |
| FDM | Post-painted only | Layer lines visible | High | Low | Reject for figurines — quality mismatch |

Score each vendor candidate on: color gamut (CMYK range), minimum layer thickness (target ≤ 27 µm), and surface finish without post-processing.

### Turnaround SLA Assessment

Figurio's customer-facing promise is 10 business days door-to-door for standard orders. Work backwards:

- Print + cure: target ≤ 5 business days from approved print file
- QC + pack: 1 business day (Figurio-side)
- Shipping: 2–4 business days (Zasilkovna domestic / DHL EU)

Evaluate vendors on:
- Standard turnaround commitment (contractual, not best-effort)
- Rush/expedite option and uplift cost
- Peak-season capacity guarantees (Q4 Nov–Dec)
- SLA breach penalties (credit or rebate per day late)

### Drop-Ship Capability

Preferred vendors can ship directly to end customers under Figurio branded packaging. Assess:

- Can vendor print on Figurio-branded box inserts? (white-label packaging)
- Do they support per-order shipment (true drop-ship) vs. batch delivery to Figurio warehouse?
- API or EDI integration for order handoff (preferred) vs. manual CSV upload
- Returns/damage handling: does vendor accept direct returns from customers?

### Geographic Coverage

Primary market is Czech Republic; secondary is EU (DE, SK, AT, PL priority). Assess:

- Vendor location relative to Zasilkovna pickup points
- EU customs handling if vendor is outside CZ (prefer CZ or SK based)
- Cross-border shipping cost impact on unit economics

---

## Shipping Provider Evaluation

### Current Providers

| Provider | Use Case | Coverage |
|----------|----------|----------|
| Zasilkovna | Czech Republic domestic, parcel shop pickup | CZ, SK, PL, HU, RO, DE |
| DHL Express | EU delivery, international orders | Global |

### Evaluation Criteria for New or Alternative Providers

1. **Rate card by weight bracket** — collect rates for 0–0.5 kg, 0.5–1 kg, 1–2 kg (typical figurine range)
2. **Parcel shop network density** — Zasilkovna benchmark: 5,000+ pickup points in CZ
3. **Tracking API** — must support webhook or polling for status updates to feed Figurio order status page
4. **Damage/loss claims process** — SLA for claim resolution; maximum liability per parcel
5. **Label generation** — REST API for label creation from order data (required for automation)
6. **Cash on delivery (COD)** — assess if relevant for CZ market segment

---

## Scoring Scorecard

Use a weighted score (1–5 per criterion) when comparing vendors head-to-head:

| Criterion | Weight | Print Partner | Shipping Provider |
|-----------|--------|--------------|------------------|
| Cost competitiveness | 30% | Yes | Yes |
| Quality / color fidelity | 25% | Yes | — |
| Turnaround SLA | 20% | Yes | Yes |
| API / integration readiness | 15% | Yes | Yes |
| Drop-ship / direct fulfillment | 10% | Yes | — |

Document scores in the vendor comparison sheet (Google Sheets — Operations folder) and share summary with CTO and CEO before any contract decision.

---

## Anti-patterns

- Do not evaluate FDM or uncolored SLA vendors for catalog figurines — they require manual painting that breaks unit economics.
- Do not accept turnaround SLAs quoted in calendar days without confirming business-day definition.
- Do not switch shipping providers without confirming Zasilkovna parcel shop pickup compatibility — customers selecting pickup points depend on this network.
