---
name: feature-prioritization
description: >
  Framework for prioritizing Figurio features using impact/effort scoring against
  the 5 company goals. Distinguishes MVP catalog work from AI pipeline features
  and longer-horizon marketplace evolution. Use this when ranking a backlog,
  deciding what to build next, or writing a prioritization recommendation.
allowed-tools:
  - Read
  - Glob
metadata:
  paperclip:
    tags:
      - product
      - strategy
---

# Feature Prioritization

Use this framework when ranking Figurio features or deciding what to build next.

---

## The 5 Company Goals (scoring anchors)

Every feature is scored against how much it advances each goal.

| ID | Goal slug | Short label |
|----|-----------|-------------|
| G1 | launch-mvp-platform | Ship the web store (catalog + Stripe + order tracking) |
| G2 | build-ai-custom-pipeline | Text-to-3D generation workflow live |
| G3 | establish-brand-acquire-customers | First 500 customers |
| G4 | operationalize-fulfillment | MCAE + Zasilkovna/DHL pipeline reliable |
| G5 | validate-unit-economics | Positive unit margins confirmed |

---

## Scoring Method

### Step 1 — Score impact on each goal (0–3 per goal)

| Score | Meaning |
|-------|---------|
| 0 | No effect |
| 1 | Indirect or marginal contribution |
| 2 | Direct and meaningful contribution |
| 3 | Blocking — this goal cannot be met without the feature |

**Total impact = sum of 5 goal scores (0–15 max).**

### Step 2 — Score effort (1–5, Fibonacci-style)

| Score | Meaning |
|-------|---------|
| 1 | Trivial — hours, single engineer |
| 2 | Small — 1–3 days |
| 3 | Medium — 1–2 weeks |
| 5 | Large — 2–4 weeks or multiple engineers |
| 8 | Epic — needs splitting before scheduling |

### Step 3 — Calculate priority score

```
Priority = Impact / Effort
```

Higher score = prioritize sooner. Features with the same score are broken by:
1. Goal status: `active` goals outrank `planned` goals
2. Dependencies: unblock other features first
3. Risk: lower-risk features first if scores are equal

---

## Phase Buckets

Assign every feature to exactly one bucket before scoring.

### Bucket A — MVP (Now)
Required to have a functioning, sellable product. G1 and G4 must reach score 2+ for any feature here.

Must-haves:
- Catalog browsing (listing, detail, size tier selection)
- Stripe checkout — full prepayment, no production before capture
- Order confirmation + status tracking emails
- MCAE print-file submission flow
- Zasilkovna/DHL shipping label generation
- Basic IP content check on model listings

### Bucket B — AI Pipeline (Next)
Required to launch Prompt-to-Print. G2 must reach score 2+ for any feature here.

Must-haves:
- Text-to-3D generation API integration (Meshy / Tripo3D / Luma Genie)
- Automated mesh repair (NetFabb / Meshmixer / Blender scripting)
- Human QA queue for 3D technician review
- Rendered preview delivery to customer
- Deposit payment flow (50% at order / 50% on approval)
- IP content moderation on prompts (reject copyrighted characters)

### Bucket C — Growth (Later)
Features that increase revenue, retention, or acquisition once the core is live.

Examples: subscription boxes, B2B quoting flow, gift wrapping upsell, referral program, social UGC incentives, rush processing surcharge, premium pedestal upsell, multilingual storefront.

### Bucket D — Phase 2+ (Future)
Scan-to-print, permanent scanning studio, in-house printing, marketplace/artist platform.

Do not schedule Bucket D features until G5 (unit economics) is validated.

---

## Scoring Table Template

| Feature | G1 | G2 | G3 | G4 | G5 | Impact | Effort | Score | Bucket | Notes |
|---------|----|----|----|----|-----|--------|--------|-------|--------|-------|
| Catalog listing page | 3 | 0 | 2 | 0 | 1 | 6 | 2 | 3.0 | A | Blocking G1 |
| Stripe checkout | 3 | 0 | 0 | 1 | 2 | 6 | 3 | 2.0 | A | No payment = no revenue |
| Text-to-3D API integration | 0 | 3 | 1 | 0 | 1 | 5 | 5 | 1.0 | B | Requires A complete |
| Subscription box flow | 0 | 0 | 2 | 1 | 2 | 5 | 5 | 1.0 | C | After G5 baseline set |
| Scan-to-print mobile rig | 0 | 0 | 1 | 0 | 1 | 2 | 8 | 0.25 | D | Phase 2 only |

---

## Decision Rules

**Rule 1 — Bucket before score.** Never pull a Bucket D feature into the sprint because it scored well in isolation. Phase gating is a hard constraint, not a score factor.

**Rule 2 — Blocking features first.** If a feature is marked 3 (blocking) on any active goal, it jumps to the top of its bucket regardless of final score.

**Rule 3 — IP risk is a veto.** Any feature that could expose Figurio to IP infringement (unlicensed characters, unmoderated AI prompts) is blocked until the mitigation requirement is in scope in the same sprint.

**Rule 4 — MCAE pricing must be known before finalizing Bucket A pricing features.** Unit economics depend on per-unit MCAE costs across all three size tiers.

**Rule 5 — AI pipeline features carry a quality risk multiplier.** Score effort +1 for any feature that touches the text-to-3D generation or mesh repair pipeline until quality benchmarks are established (turnaround, rejection rate, human QA load).

---

## Anti-patterns

- Prioritizing Bucket C growth features (subscriptions, B2B) before the MVP store is live and taking orders.
- Treating scan-to-print as a Phase 1 scope item — it is explicitly Phase 2.
- Scheduling AI pipeline work without ensuring a 3D technician QA resource is available.
- Assigning a high priority score to a feature without checking whether MCAE pricing for that size tier is confirmed.
```
