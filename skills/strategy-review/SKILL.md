---
name: strategy-review
description: Framework for evaluating strategic proposals at Figurio — market positioning, pricing, vendor, and growth decisions for a 3D-printed figurine e-commerce business.
---

# Strategy Review Framework

## Purpose

Provide a structured evaluation process for strategic proposals at Figurio. Every significant decision — pricing changes, vendor partnerships, geographic expansion, new product lines — must pass through this framework before execution.

## Evaluation Criteria

### 1. Market Positioning Impact

- Does this proposal strengthen Figurio's position in the custom 3D-printed figurine market?
- How does it differentiate us from mass-produced figurine competitors?
- Does it reinforce our premium-but-accessible brand positioning?
- Will it attract our target audience (gift buyers, collectors, gaming/anime enthusiasts)?

### 2. Pricing Sensitivity

- Figurine pricing must account for MCAE PolyJet printing costs per size tier (S/M/L/XL).
- Material cost is the dominant variable — small pricing changes have outsized margin impact.
- Custom figurines carry a premium over catalog items (30-50% markup is acceptable).
- Price anchoring: always show the "starting from" price alongside the configured price.
- Currency considerations for EU expansion (CZK primary, EUR secondary).

### 3. MCAE Vendor Lock-in Risk

- Evaluate dependency level on MCAE for PolyJet printing.
- Can we onboard a secondary printing partner within 30 days if needed?
- Are print file formats vendor-neutral (STL/OBJ) or proprietary?
- What is the switching cost in terms of quality calibration and QA process?

### 4. AI Pipeline Build-vs-Buy

- Text-to-3D services: evaluate API cost per generation, quality, and printability.
- Mesh repair: in-house (Blender bpy) vs external service vs hybrid.
- QA automation: manual review vs AI-assisted defect detection.
- Always prefer vendor APIs for generation, in-house for post-processing.

### 5. Geographic Expansion (EU Focus)

- Phase 1: Czech Republic (Zasilkovna domestic, CZK payments).
- Phase 2: Slovakia, Poland (Zasilkovna cross-border).
- Phase 3: DACH region (DHL EU, EUR payments).
- Each phase requires: localized checkout, shipping integration, VAT compliance.

### 6. Seasonal Demand Planning

- Q1 (Jan-Mar): Valentine's couples figurines, post-holiday slowdown recovery.
- Q2 (Apr-Jun): Easter, graduation gifts, wedding cake toppers.
- Q3 (Jul-Sep): Back-to-school, gaming convention season, Halloween prep.
- Q4 (Oct-Dec): Halloween, Black Friday, Christmas ornaments — peak season.
- MCAE lead times increase 2-3x during Q4; plan inventory accordingly.

## Decision Template

Every strategic proposal must be documented using this format:

### Proposal

- **Title**: One-line description of the proposal.
- **Sponsor**: Which agent or role is proposing this.
- **Impact Area**: Market positioning / pricing / vendor / growth / product.

### Context

- What problem or opportunity does this address?
- What data or signals triggered this proposal?
- What is the current state and what changes?

### Tradeoffs

| Factor               | Pro                        | Con                        |
|----------------------|----------------------------|----------------------------|
| Revenue impact       |                            |                            |
| Cost impact          |                            |                            |
| Execution complexity |                            |                            |
| Time to value        |                            |                            |
| Risk level           |                            |                            |

### Recommendation

- **Decision**: Accept / Reject / Defer / Modify.
- **Rationale**: 2-3 sentences explaining the reasoning.
- **Owner**: Who executes this decision.
- **Timeline**: Key milestones and deadlines.

### Success Metrics

- Primary KPI and target value.
- Secondary metrics to monitor.
- Review date (30/60/90 days post-decision).
- Rollback trigger: what condition would reverse this decision.

## Guardrails

- No single vendor should represent more than 70% of a critical capability.
- Pricing changes must be A/B tested before full rollout.
- Geographic expansion requires minimum 3-month runway of positive unit economics.
- AI pipeline costs must stay below 15% of the figurine's retail price.
- All strategic decisions require CEO sign-off; CTO and CMO provide input on their domains.
