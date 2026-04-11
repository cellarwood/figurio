---
name: feature-prioritization
description: >
  Prioritization framework for the Figurio product backlog. Balances catalog
  features, AI custom figurine pipeline improvements, and operational tooling
  using an impact/effort scoring model tied to Figurio's company goals of
  conversion, AI order volume, and fulfillment efficiency.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - product
      - planning
---

# Feature Prioritization

Use this skill when grooming the Figurio backlog, preparing a sprint, or making a case for why one feature should be built before another.

## Company Goals (Reference)

Prioritization decisions must trace back to at least one of these goals:

| Goal ID | Goal | Primary KPI |
|---------|------|-------------|
| G1 | Grow AI custom order volume | AI orders / month |
| G2 | Improve catalog conversion | Catalog add-to-cart rate |
| G3 | Reduce fulfillment errors and ops overhead | Ops tickets / 100 orders |
| G4 | Retain repeat buyers | 90-day repurchase rate |

---

## Scoring Model

Score each backlog item on two dimensions. Use integers only.

### Impact (1–5)

How significantly does this item move one or more company goals?

| Score | Meaning |
|-------|---------|
| 5 | Direct, measurable lift on a G1–G4 KPI; affects all or most users |
| 4 | Strong indirect lift or affects a large segment |
| 3 | Moderate improvement or affects a key segment (e.g., AI custom buyers only) |
| 2 | Nice-to-have, marginal KPI effect |
| 1 | Purely internal / no measurable customer impact |

### Effort (1–5)

How much engineering work is required across the React/TS frontend, FastAPI backend, and Stripe integration?

| Score | Meaning |
|-------|---------|
| 1 | Half a day — single layer, no API changes |
| 2 | 1–3 days — one layer plus minor API change |
| 3 | 1 week — multiple layers or non-trivial backend work |
| 4 | 2–3 weeks — cross-layer, likely needs design and QA |
| 5 | Month+ — new subsystem, Stripe integration change, or AI pipeline work |

### Priority Score

```
Priority = Impact / Effort
```

A score above 1.0 is generally worth scheduling. Below 0.5 is a candidate for the icebox unless it unblocks a higher-priority item.

---

## Backlog Categories

Figurio's backlog divides into three buckets. Apply the scoring model within and across buckets.

### Catalog Features
Examples: filter/sort improvements, product page redesign, search, upsell widgets.
- Tie impact to G2 (catalog conversion) and G4 (retention).
- Catalog work tends to have low-to-medium effort because the data model is stable.

### AI Custom Pipeline
Examples: configurator UX, photo processing quality, style/pose options, real-time price estimates, generation status polling.
- Tie impact to G1 (AI order volume).
- AI pipeline work often scores effort 4–5 because changes touch the FastAPI ML integration and the multi-step React configurator.
- Always check whether a proposed change requires a new FastAPI endpoint or modifies the existing `/api/v1/orders/custom` flow before assigning effort.

### Operational Tooling
Examples: order status dashboard, fulfillment error alerts, print queue management, customer support tooling.
- Tie impact to G3 (ops efficiency).
- These rarely have a direct customer-facing KPI but can unlock capacity that benefits G1 and G2 indirectly — note this in the scoring rationale.

---

## Tiebreaker Rules

When two items have the same Priority score, apply these tiebreakers in order:

1. **Unblocks higher-priority work** — pick the item that unblocks more items downstream.
2. **G1 over G2 over G3 over G4** — AI custom growth is the primary strategic lever for Figurio as a D2C brand; prefer it when scores are equal.
3. **Customer-facing over internal** — visible improvements support marketing and retention.
4. **Lower absolute effort** — between two equal-scoring items, take the easier one first to maintain delivery cadence.

---

## How to Run a Prioritization Session

1. List all candidate items with a one-line description and their backlog category.
2. Score each item on Impact and Effort; record the rationale in one sentence.
3. Calculate Priority = Impact / Effort.
4. Sort descending by Priority score.
5. Apply tiebreakers where needed.
6. Flag any item with Effort ≥ 4 for a brief engineering sizing conversation before committing it to a sprint.
7. Present the ranked list with goal alignment (G1–G4) visible for stakeholder review.

---

## Scoring Table Template

| Feature | Category | Impact (1–5) | Goal | Effort (1–5) | Priority | Notes |
|---------|----------|--------------|------|--------------|----------|-------|
| Real-time price in configurator | AI Custom | 4 | G1 | 2 | 2.0 | Uses existing `/quotes/estimate` endpoint |
| Catalog faceted search | Catalog | 4 | G2 | 3 | 1.3 | Needs Elasticsearch or similar |
| Print queue ops dashboard | Ops Tooling | 3 | G3 | 2 | 1.5 | Internal only; unblocks G3 metric tracking |
| Saved figurine drafts | AI Custom | 3 | G1, G4 | 4 | 0.75 | Complex — new DB schema + auth scope |

---

## Anti-patterns

- Scoring impact based on engineering enthusiasm rather than goal alignment.
- Treating all three backlog categories as equally weighted — AI custom pipeline (G1) is the primary growth lever.
- Scheduling Effort 5 items without an engineering sizing estimate.
- Letting ops tooling permanently sit at the bottom — when G3 metrics degrade, reprioritize proactively.
- Adding items to the sprint without a linked Goal ID — every scheduled item must trace to G1, G2, G3, or G4.
