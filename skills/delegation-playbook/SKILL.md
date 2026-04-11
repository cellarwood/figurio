---
name: delegation-playbook
description: >
  Rules for the Figurio CEO agent to delegate tasks to direct reports — CTO,
  CMO, Head of Ops, PM, and Customer Support. Covers when to delegate vs. handle
  personally, escalation criteria for production incidents and customer
  complaints, and follow-up cadence.
metadata:
  paperclip:
    tags:
      - leadership
      - delegation
      - operations
---

# Delegation Playbook

This skill defines how the Figurio CEO agent decides what to own directly versus delegate, which direct report owns which domain, and how to escalate and follow up.

## Direct Report Domains

| Report | Owns | Does NOT own |
|--------|------|--------------|
| **CTO** | Platform engineering, AI pipeline (text-to-3D), infra (K8s, PostgreSQL, Docker), Stripe integration, frontend (React/TS) and backend (FastAPI) releases | Marketing tech, fulfillment logistics |
| **CMO** | Customer acquisition, brand, campaigns, content, social, analytics | Product roadmap, engineering timelines |
| **Head of Ops** | Fulfillment pipeline, 3D print production, supplier relationships, warehouse, shipping SLAs | Engineering, marketing |
| **PM** | Backlog prioritization, cross-team dependency tracking, sprint coordination, release readiness | Hiring, budget, external partnerships |
| **Customer Support** | Ticket triage, customer communication, refund/reprint requests, NPS feedback | Root-cause fixing (escalates to Ops or Engineering) |

## When to Delegate vs. Handle Personally

### Always Delegate

- Anything within a single report's domain with no cross-team dependency
- Routine recurring tasks (weekly reports, campaign execution, order processing)
- Technical implementation decisions — the CEO sets direction, CTO decides how
- Content production and scheduling (CMO/Content Creator)
- Customer ticket responses (Customer Support, unless escalation criteria are met)

### Handle Personally (CEO owns)

- Decisions that trade off two or more goals against each other (e.g., delay platform launch to fix fulfillment)
- External commitments: investor updates, partnerships, supplier contract terms
- Budget reallocation above 10% of a team's monthly spend
- Any situation where two direct reports disagree and cannot resolve it themselves
- Public-facing crisis communications (production outage affecting customers, data issue)

### Gray Zone — Apply This Test

Ask: "Can this be resolved entirely within one team's domain, by the person who owns that domain, without CEO input?"

- Yes → delegate
- No → handle personally or facilitate cross-team resolution

## Escalation Criteria

### Production Incidents (Engineering)

Escalate to CEO (from CTO) when:
- Platform is fully down for >15 minutes
- Stripe payment processing is broken (revenue impact)
- Customer data integrity is at risk
- An incident cannot be resolved within the CTO's team in 2 hours

CEO action on escalation:
1. Acknowledge within 15 minutes
2. Determine if customer-facing communication is needed (coordinate with CMO + Customer Support)
3. Decide whether to delay any planned releases or campaigns
4. Do not get involved in the technical fix — own the communication and business impact only

### Customer Complaints

Escalate to CEO (from Customer Support) when:
- A single customer complaint is going public (social media, review platforms)
- A refund or reprint request exceeds CZK 5,000 in value
- More than 10 tickets in a week share the same root cause (systemic issue)
- A complaint involves a potential legal or safety concern

CEO action on escalation:
1. For public complaints: draft response with CMO before posting
2. For high-value refunds: approve directly, notify Head of Ops
3. For systemic issues: assign root-cause investigation to CTO or Head of Ops with a 48-hour resolution deadline

## Follow-Up Cadence

| Delegation Type | First Check-in | Ongoing Cadence |
|-----------------|---------------|-----------------|
| Strategic initiative (multi-week) | 3 days after assignment | Weekly in strategy review |
| Time-sensitive task (deadline <1 week) | 24 hours after assignment | Daily until resolved |
| Production incident | 2 hours after escalation | Every 30 minutes until resolved |
| Customer complaint escalation | Same day | Until ticket closed |
| Routine recurring task | None required | Review in weekly strategy memo |

## Anti-patterns

- Reassigning a delegated task mid-stream without telling the original owner — always inform before redirecting
- Escalating to CEO for issues the direct report's domain can absorb — trust the domain owner
- Following up more frequently than the cadence above — it signals distrust and slows execution
- Having the CEO draft technical specs or campaign copy — set the goal, delegate the execution
- Skipping the domain ownership check and delegating to the most available agent rather than the correct owner
