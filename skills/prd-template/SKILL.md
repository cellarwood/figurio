---
name: prd-template
description: >
  Product requirements document template for Figurio features. Covers all three
  product lines — catalog browsing, AI prompt-to-print, scan-to-print — plus
  growth initiatives like subscription boxes and B2B ordering. Use this when
  writing or reviewing a PRD for any Figurio feature.
allowed-tools:
  - Read
  - Write
  - Glob
metadata:
  paperclip:
    tags:
      - product
      - documentation
---

# PRD Template

Use this template when writing a Product Requirements Document for any Figurio feature. Fill in every section; delete guidance text before sharing.

---

## Template

```markdown
# PRD: [Feature Name]

**Status:** Draft | In Review | Approved | Shipped
**Author:** [agent or person]
**Created:** YYYY-MM-DD
**Last updated:** YYYY-MM-DD
**Product line:** Catalog | AI Prompt-to-Print | Scan-to-Print | Subscriptions | B2B | Platform

---

## 1. Problem Statement

[1–3 sentences. What customer or business problem does this solve?
Be concrete — reference the product line and user segment.]

## 2. Goals

List the company goals this feature advances:
- [ ] launch-mvp-platform — ship catalog + Stripe + order tracking
- [ ] build-ai-custom-pipeline — text-to-3D generation workflow
- [ ] establish-brand-acquire-customers — first 500 customers
- [ ] operationalize-fulfillment — MCAE + Zasilkovna/DHL pipeline
- [ ] validate-unit-economics — healthy margins, path to profitability

## 3. Success Metrics

| Metric | Baseline | Target | Measurement method |
|--------|----------|--------|--------------------|
|        |          |        |                    |

## 4. User Stories

Format: "As a [user], I want to [action] so that [outcome]."

- As a …
- As a …

## 5. Scope

### In scope
- …

### Out of scope
- …

## 6. Functional Requirements

Number each requirement. Group by area if needed.

1. …
2. …

## 7. Non-Functional Requirements

- **Performance:** [response time, throughput expectations]
- **Security / Payments:** All orders prepaid via Stripe; no production begins before payment capture
- **IP compliance:** No copyrighted characters; content moderation required for AI prompts
- **Availability:** …

## 8. UX / Design Notes

[Key flows, wireframe links, or interaction decisions. Reference Figurio stack: React/TS, shadcn-ui, Tailwind.]

## 9. Technical Notes

[Relevant constraints for the backend (FastAPI/Python), AI pipeline (text-to-3D service + mesh repair), or infrastructure (Docker/K8s/GKE).]

## 10. Dependencies

| Dependency | Owner | Status |
|------------|-------|--------|
| MCAE print partner API / pricing | COO | … |
| Stripe payment integration | Backend engineer | … |
| Text-to-3D service (Meshy / Tripo3D / etc.) | Backend engineer | … |

## 11. Open Questions

- [ ] …

## 12. Phasing (if applicable)

| Phase | Scope | Target date |
|-------|-------|-------------|
| Phase 1 | … | … |
| Phase 2 | … | … |
```

---

## Product Line Notes

Use these reminders when writing requirements for each line.

### Catalog ("Ready to Print")
- Models must be pre-validated for printability (manifold geometry, minimum wall thickness) before listing.
- Model sources: commercially licensed (CGTrader/TurboSquid), commissioned originals, or revenue-share designer partnerships.
- Size tiers: Small ~8 cm, Medium ~15 cm, Large ~25 cm — pricing and MCAE cost vary per tier.
- Stocking popular catalog items as pre-printed inventory is an option for faster shipping.

### AI Prompt-to-Print
- Pipeline stages: text-to-3D generation → automated mesh repair → human QA → rendered preview → customer approval → print queue.
- Turnaround: 10–15 business days; price higher than catalog.
- Payment: 50% deposit at order, 50% on preview approval.
- Content moderation required: reject prompts for recognizable copyrighted characters.
- Preview must always be shown before any print job is submitted to MCAE.

### Scan-to-Print (Phase 2)
- Initially mobile pop-up (comic cons, Christmas markets, corporate events) using photogrammetry rig.
- Target segments: families, cosplayers, wedding toppers, corporate gifts.
- Permanent scanning studio is a Phase 3 milestone pending validated unit economics.

### Subscription Boxes
- Monthly or quarterly; limited-edition numbered figurines.
- Goals: recurring revenue, collector community, reduced acquisition cost per order.
- Requires inventory planning and themed packaging cadence.

### B2B Ordering
- Use cases: branded mascots, executive gifts, conference giveaways, employee awards.
- Higher average order value; volume discounts apply.
- Needs a separate quoting/invoicing flow and B2B account management in the storefront.

---

## Anti-patterns

- Do not write requirements that assume IP-encumbered characters are acceptable without a verified licensing arrangement.
- Do not skip the preview-approval gate for AI-generated models — this is a core customer trust mechanism.
- Do not mark a PRD "Approved" before all open questions about MCAE pricing are resolved, as margins depend on it.
- Do not conflate scan-to-print scope into Phase 1 MVP work.
```
