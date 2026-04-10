---
name: strategy-review
description: >
  Weekly strategic review process for Figurio's CEO agent. Evaluates progress
  against the 5 company goals (MVP launch, AI pipeline, brand/500 customers,
  fulfillment operations, unit economics), surfaces blockers across the 9-agent
  team, and reprioritizes work for the coming week.
metadata:
  paperclip:
    tags:
      - strategy
      - leadership
      - planning
---

# Strategy Review

## When to Use

Run this skill every week (Monday or start of sprint) to assess company health,
align agent priorities, and decide what changes — if any — need to be made to
the current plan.

Also invoke it when a significant event occurs mid-week: a major blocker is
escalated, a goal milestone is hit, or external conditions shift (e.g., a
supplier issue, a spike in ad spend, a technical incident).

## Figurio's 5 Company Goals

Evaluate each goal in order — they are roughly sequential but run in parallel:

1. **Launch MVP** — React/TS storefront + FastAPI backend live, Stripe checkout
   functional, at least one product SKU orderable end-to-end.
2. **AI Pipeline** — Automated 3D model generation pipeline operational;
   customer upload → render → fulfillment without manual intervention.
3. **Brand & 500 Customers** — 500 paying customers acquired; brand identity
   established (visual system, tone, social presence).
4. **Operationalize Fulfillment** — Print-to-ship SLA defined and met
   consistently; packaging, quality checks, and returns process documented.
5. **Unit Economics** — CAC, LTV, COGS, and contribution margin tracked weekly;
   path to profitability clear.

## Review Process

### 1. Collect Status (before the session)

Pull updates from each agent's last output or heartbeat:
- CTO / Backend Engineer / Frontend Engineer → engineering progress
- CMO / Content Creator → marketing metrics, campaign status
- DevOps Engineer → infrastructure health, deployment status
- Product Manager → feature backlog, sprint completion rate
- COO / Operations → fulfillment SLA, supplier status

### 2. Score Each Goal

For each of the 5 goals assign a traffic-light status:

| Status | Meaning |
|--------|---------|
| Green | On track, no intervention needed |
| Yellow | At risk — needs attention this week |
| Red | Blocked or significantly behind — requires immediate reprioritization |

### 3. Identify Blockers

A blocker is anything that prevents a goal from progressing. Categorize by
domain:

- **Engineering blockers** — unfinished infra, API gaps, unresolved bugs
- **Marketing blockers** — no creative assets, unclear targeting, budget not
  approved
- **Operations blockers** — supplier delays, fulfillment process undefined,
  tooling not in place
- **Cross-agent blockers** — dependency between two agents that is unresolved

For each blocker record: what it is, which agent owns it, and what unblocks it.

### 4. Reprioritize

After scoring and surfacing blockers, decide:

- Should any agent shift focus this week? (e.g., pull backend engineer off new
  features to fix a fulfillment integration bug)
- Is any goal being over-resourced relative to its current bottleneck?
- Is there a cross-agent coordination problem that only the CEO can resolve?

Output a ranked list of the top 3-5 priorities for the week across the team.

### 5. Communicate Decisions

Summarize the review in a short memo format:
- Goal statuses (traffic light)
- Top blockers and owners
- Priority changes for the week
- Any decisions that need agent acknowledgment

Send to relevant agents via the appropriate channel (Google Chat, task update,
or direct assignment).

## Anti-patterns

- Reviewing status without making a decision — every review must produce at
  least one action or confirmation that no change is needed.
- Treating all 5 goals as equally urgent every week — at any given time, one
  or two goals dominate; focus effort there.
- Waiting for complete data before reviewing — use best available information
  and flag gaps as part of the output.
- Conflating "busy" with "progress" — agent activity is not the same as goal
  advancement; tie everything back to the 5 goals.
