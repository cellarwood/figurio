---
name: strategy-review
description: >
  Weekly strategic review process for Figurio — a Czech D2C e-commerce company selling
  3D-printed figurines. Covers how to evaluate progress against company goals, identify
  blockers across engineering, marketing, and operations, and reprioritize work across
  the 9-agent roster.
metadata:
  paperclip:
    tags:
      - strategy
      - leadership
      - planning
---

# Strategy Review

## When to Use

Run this skill every week (or when triggered by a significant business event such as a
production outage, a spike/drop in conversion, or a new product line milestone). It
structures how the CEO agent evaluates company health and sets priorities for the week
ahead.

## Review Structure

Work through the following sections in order. Each section produces a concrete output
(a status, a list of blockers, or a set of updated priorities).

---

### 1. Goal Scorecard

Evaluate Figurio's three core goals for the current quarter:

| Goal | Leading Indicator | Source |
|------|------------------|--------|
| Revenue growth | Weekly orders, AOV, conversion rate | Stripe dashboard / backend analytics |
| Product quality | Print defect rate, customer complaints, re-print requests | MCAE production logs, support tickets |
| Custom figurine funnel | AI-prompt completion rate, scan-to-print Phase 2 readiness | CTO weekly report |

Rate each goal: **On Track / At Risk / Off Track**. An "At Risk" rating requires a
named owner and a corrective action within the same review.

---

### 2. Agent Status Check

Pull the latest heartbeat or status summary from each agent:

- **CTO** — engineering velocity, open incidents, infrastructure stability (K8s/Docker)
- **CMO** — campaign performance, content pipeline, CAC vs target
- **Head of Operations** — MCAE order queue, delivery SLAs, Stripe payment issues
- **Backend Engineer** — FastAPI service health, DB migrations, API reliability
- **Frontend Engineer** — React/TS build status, shadcn-ui component work, UX bugs
- **DevOps Engineer** — deployment pipeline, Docker image hygiene, K8s cluster alerts
- **Content Creator** — figurine catalog photography, product copy, social assets
- **Support Agent** — open ticket volume, CSAT, recurring complaint themes

Flag any agent whose status is blocked or whose output has not arrived.

---

### 3. Blocker Triage

For each blocker identified in step 2, classify it:

- **Engineering blocker** — route to CTO with a clear acceptance criterion and deadline
- **Marketing blocker** — route to CMO with the business impact quantified
- **Operations blocker** — route to Head of Operations; if it affects MCAE print queue,
  mark as P0 and expect same-day response
- **Cross-functional** — CEO handles directly or schedules a synchronous decision

Do not carry a blocker into a second review week without escalation.

---

### 4. Figurio Product Line Health

Check the status of each product line separately:

- **Catalog figurines** — in-stock SKUs, new designs in pipeline, any print quality issues
- **AI-prompted custom figurines** — prompt-to-order conversion, AI model performance,
  average turnaround time from order to MCAE submission
- **Scan-to-print (Phase 2)** — milestone progress only; not yet revenue-generating

---

### 5. Priority Reset

Based on the scorecard and blockers, produce a ranked priority list for the coming week.
Format:

```
P0 — [action] | owner: [agent] | due: [date]
P1 — [action] | owner: [agent] | due: [date]
P2 — [action] | owner: [agent] | due: [date]
```

Limit to 3 P0s. If more than 3 things feel like P0, something is wrong — escalate to
a human stakeholder.

---

## Output

The review produces:
1. A goal scorecard (On Track / At Risk / Off Track per goal)
2. A blocker list with owners
3. A weekly priority list in P0/P1/P2 format

Share the output with CTO, CMO, and Head of Operations as the week's operating brief.

## Anti-patterns

- Reviewing status without updating priorities — the review is only useful if it changes
  something
- Letting "At Risk" goals sit without a named owner and corrective action
- Running the review without checking the MCAE production queue — operational delays are
  the most common Figurio bottleneck and are easy to miss
- Producing a priority list longer than ~7 items — focus is the point
