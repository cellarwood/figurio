---
name: strategy-review
description: >
  Weekly strategic review process for Figurio's CEO agent. Evaluates progress
  against the four core company goals — platform launch, catalog readiness,
  fulfillment pipeline, and customer acquisition — identifies cross-functional
  blockers, and reprioritizes work across the 11-agent org.
metadata:
  paperclip:
    tags:
      - leadership
      - strategy
      - operations
---

# Strategy Review

Figurio runs a weekly strategic review every Monday. This skill guides the CEO agent through that process: pulling status from direct reports, assessing goal health, surfacing blockers, and issuing updated priorities.

## When to Use

- At the start of each week (Monday morning cadence)
- When a major blocker surfaces mid-week that affects multiple teams
- Before any board or investor update

## The Four Company Goals

All review activity maps back to these goals. Every status check and reprioritization decision must reference at least one of them:

| Goal | Owner | Key Signal |
|------|-------|------------|
| **Platform Launch** | CTO | API uptime, release milestone completion, open critical bugs |
| **Catalog Readiness** | CTO + PM | Number of 3D models live, AI custom pipeline acceptance rate |
| **Fulfillment Pipeline** | Head of Ops | Order-to-ship time (target: ≤5 days), supplier SLA compliance |
| **Customer Acquisition** | CMO | Weekly new signups, CAC, paid campaign ROAS |

## Review Process

### 1. Collect Status Inputs

Request async status updates from each direct report before the review. Expect:

- **CTO** — engineering sprint completion %, open P0/P1 bugs, any infra incidents (K8s, PostgreSQL, Stripe integration)
- **CMO** — acquisition funnel metrics, active campaign performance, social/content output
- **Head of Ops** — fulfillment throughput, 3D print queue depth, supplier issues
- **PM** — feature backlog health, cross-team dependency map
- **Customer Support** — open ticket volume, top complaint categories, escalation count

### 2. Score Goal Health

Rate each of the four goals Red / Amber / Green based on inputs:

- **Green** — on track, no blockers, metrics moving in the right direction
- **Amber** — at risk; a blocker exists but has a clear owner and resolution path
- **Red** — off track; blocker is unresolved or owner unclear; requires CEO intervention

### 3. Identify Cross-Functional Blockers

A blocker is cross-functional if it involves more than one team or agent. Common Figurio patterns:

- AI custom pipeline (text-to-3D) quality issues blocking both catalog readiness and customer acquisition
- Stripe integration bugs blocking purchase conversion, affecting both engineering and CMO metrics
- 3D print supplier delays affecting fulfillment pipeline and customer support ticket volume
- Frontend (React/TS) release delays blocking CMO from launching campaigns tied to new catalog pages

For each cross-functional blocker: name the blocker, the two affected goals, the blocking agent/team, and the resolution owner.

### 4. Reprioritize Work

Apply this priority hierarchy when goals conflict:

1. **Fulfillment pipeline issues** — customer orders in flight; always P0
2. **Platform stability** (production incidents, Stripe downtime) — blocks all revenue
3. **Platform launch milestones** — if a launch date is committed externally
4. **Customer acquisition** — time-sensitive campaigns with spend already committed
5. **Catalog readiness** — important but rarely time-critical within a single week

Issue explicit reprioritization directives to affected agents when rank order changes.

### 5. Publish Review Output

After completing the review, produce a weekly strategy memo with:

- Goal health scorecards (R/A/G)
- Top 3 cross-functional blockers + owners + resolution dates
- Priority changes (what moved up, what was deferred, and why)
- CEO focus areas for the coming week

Distribute to CTO, CMO, Head of Ops, and PM.

## Anti-patterns

- Reviewing only one team's status and declaring goals healthy — always cross-reference at least two inputs per goal
- Treating every Amber as a crisis — Amber goals require monitoring, not CEO intervention
- Reprioritizing catalog work every week based on AI pipeline experiments — catalog readiness needs sustained focus, not reactive churn
- Skipping the review when the CEO is "busy" — delegate collection of inputs to PM if needed, but never skip the scoring and output
