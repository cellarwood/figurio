---
name: strategy-review
description: >
  Weekly strategic review process for Figurio — a direct-to-consumer e-commerce company
  selling high-quality full-color 3D-printed figurines (catalog + AI custom). Covers
  evaluation of progress against core company goals (MVP launch, AI pipeline, customer
  acquisition, fulfillment ops), identification of cross-team blockers, and reprioritization
  of work across the 9-agent organization.
allowed-tools:
  - Read
  - Grep
  - Write
metadata:
  paperclip:
    tags:
      - strategy
      - executive
      - planning
---

# Strategy Review

## When to Use

Run this skill every week (Monday morning or as scheduled) to conduct the Figurio weekly strategic review. Also trigger on demand when a significant blocker surfaces, a milestone is missed, or a major market or operational event requires re-evaluation of priorities.

## Company Goals (North Star)

Always evaluate weekly progress against these four pillars:

1. **MVP Launch** — storefront live with catalog figurines purchasable end-to-end (React/TS frontend + FastAPI backend + Stripe checkout)
2. **AI Custom Pipeline** — customer uploads photo → AI generates figurine model → order routed to MCAE for PolyJet printing
3. **Customer Acquisition** — paid and organic channels driving first 100 orders; CAC and conversion rate benchmarks established
4. **Fulfillment Operations** — reliable handoff to MCAE (Stratasys J55), quality control checkpoints, shipping SLAs met

## Review Structure

### 1. Goal Progress Snapshot (per pillar)

For each of the four pillars, assess:
- **Status**: On track / At risk / Blocked / Complete
- **Key output this week**: what shipped, what was tested, what was decided
- **Delta from last week**: movement forward or regression
- **Owner**: which agent(s) drove this

### 2. Blocker Inventory

Sweep each team area for active blockers:

| Area | Agent Owner | Blocker Type |
|------|-------------|--------------|
| Engineering (backend API, Stripe integration, AI pipeline) | CTO | Technical debt, integration failures, capacity |
| Engineering (frontend, UX) | CTO | Design gaps, API contract mismatches |
| Marketing (acquisition, content) | CMO | Budget, channel access, creative bottlenecks |
| Fulfillment & ops (MCAE coordination, QA) | Head of Operations | Vendor SLA, production capacity, print queue |
| Content & catalog | Content Creator | Asset pipeline, product photography, copy |

Blockers are classified as:
- **P0 — Escalate immediately**: production down, Stripe outage, MCAE unable to fulfill, data breach
- **P1 — Resolve this week**: milestone at risk, agent blocked for >2 days
- **P2 — Monitor**: risk identified but not yet blocking

### 3. Reprioritization Decision

After reviewing blockers and goal progress:

1. List the top 3 priorities for the coming week (one per pillar at most, unless a pillar is on fire)
2. Identify any work to de-prioritize or pause to free capacity
3. Confirm delegation assignments — who owns each priority and what the done-state looks like
4. Note any decisions that require CEO judgment vs. those delegated to CTO / CMO / Ops

### 4. Metrics Check

Pull and review weekly metrics relevant to each pillar:

- **MVP Launch**: deployment status, open critical bugs, Stripe test transaction success rate
- **AI Pipeline**: end-to-end order conversion rate from upload → confirmed print job; error rate in AI model generation
- **Acquisition**: sessions, add-to-cart rate, checkout conversion, CAC by channel
- **Fulfillment**: orders placed vs. orders shipped, MCAE turnaround time, QC rejection rate

## Output Format

After completing the review, produce a structured summary:

```
## Figurio Weekly Review — [DATE]

### Goal Status
- MVP Launch: [status] — [one sentence]
- AI Pipeline: [status] — [one sentence]
- Customer Acquisition: [status] — [one sentence]
- Fulfillment Ops: [status] — [one sentence]

### Top Blockers
1. [Blocker] — Owner: [agent] — Priority: [P0/P1/P2] — Action: [what happens next]

### This Week's Priorities
1. [Priority] — Owner: [agent] — Done state: [definition]
2. ...

### Decisions Made
- [Decision and rationale]

### Items to Monitor Next Week
- [Item]
```

## Anti-patterns

- Skipping the blocker sweep because things "seem fine" — surface problems early
- Treating all four pillars as equal when one is in crisis — escalate P0s immediately
- Reprioritizing without confirming agent capacity — check with CTO / CMO / Ops before committing
- Reviewing metrics without acting on them — every metric check should produce an action or a documented "no action needed"
