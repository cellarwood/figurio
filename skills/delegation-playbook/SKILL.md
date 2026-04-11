---
name: delegation-playbook
description: >
  Rules for the Figurio CEO delegating tasks to direct reports — CTO, CMO, and Head of
  Operations. Covers when to delegate vs. handle personally, escalation criteria for
  production incidents and IP/legal concerns, and the follow-up cadence expected from
  each direct report. Specific to Figurio's 9-agent structure and Czech Republic operations.
allowed-tools:
  - Read
  - Write
metadata:
  paperclip:
    tags:
      - executive
      - delegation
      - operations
---

# Delegation Playbook

## Direct Reports and Their Domains

| Agent | Domain | Owns |
|-------|--------|------|
| **CTO** | Engineering | FastAPI backend, React/TS frontend, AI custom pipeline, Docker/K8s infra, Stripe integration |
| **CMO** | Marketing | Customer acquisition, paid/organic channels, content strategy, conversion rate optimization |
| **Head of Operations** | Fulfillment & vendor | MCAE coordination, Stratasys J55 print queue, QC, shipping SLAs, Czech ops |

## When to Delegate vs. Handle Personally

### Delegate to CTO when:
- Any engineering implementation decision (architecture, library choice, API design)
- Sprint prioritization within the engineering team
- Code review standards and technical debt triage
- Stripe integration specifics (webhooks, payment flow edge cases)
- AI pipeline model selection or inference infrastructure choices
- On-call and incident response process setup

### Delegate to CMO when:
- Channel strategy and budget allocation within approved marketing spend
- Campaign execution and creative direction
- Copywriting and content calendar decisions
- Social media presence and community management
- Analytics tooling and attribution model choices

### Delegate to Head of Operations when:
- Day-to-day MCAE vendor communication and print job scheduling
- QC process definition and rejection thresholds
- Shipping carrier selection and tracking integration
- Czech Republic regulatory compliance for DTC shipments
- Customer support escalations related to fulfillment delays or print quality

### Handle personally (CEO does not delegate):
- Company strategy pivots or new product line decisions
- Fundraising conversations or investor relations
- Pricing strategy and margin targets
- Hiring or firing of direct reports
- Any legal agreement with MCAE or other key vendors
- IP concerns — if AI-generated output may infringe third-party IP, CEO reviews before any action
- Public statements about the company or product

## Escalation Criteria

### P0 — Escalate to CEO immediately (direct reports must not resolve alone)

| Trigger | From | Why CEO must be involved |
|---------|------|--------------------------|
| Production checkout down (Stripe failure or backend outage) | CTO | Revenue impact; may require vendor communication |
| AI pipeline generating output that may violate IP / copyright | CTO | Legal exposure; requires CEO judgment before any response |
| MCAE unable to fulfill active orders (capacity or equipment failure) | Head of Ops | Core vendor relationship; CEO may need to communicate with MCAE directly |
| Customer data breach or suspected unauthorized access | CTO | Legal obligation under GDPR (Czech Republic); CEO must be notified within 1 hour |
| Negative press or viral complaint involving brand reputation | CMO | CEO approves all public responses |

### P1 — Notify CEO within 24 hours, direct report leads resolution

- A sprint milestone slips by more than 3 days
- A marketing channel is suspended or banned (e.g., ad account flagged)
- A batch of orders has QC rejection rate above 15%
- A third-party integration (Stripe, MCAE API, shipping carrier) has degraded performance

### P2 — Handle independently, include in weekly review

- Normal engineering bugs, feature work, deployment issues resolved within SLA
- Routine content and campaign decisions within approved budget
- Standard MCAE order routing and QC

## Delegation Protocol

When delegating a task, always specify:

1. **What**: clear description of the task and expected output
2. **Done state**: how the CEO will know it is complete (e.g., "Stripe webhook tested end-to-end in staging with a successful test charge")
3. **Deadline**: specific date, not "soon" or "ASAP"
4. **Constraints**: budget limit, tech constraints, anything off-limits
5. **Check-in point**: when the direct report should surface status if not yet done

Example delegation format:
```
To: CTO
Task: Implement Stripe checkout webhook handler for order confirmation
Done state: Webhook receives payment_intent.succeeded, creates order record in DB, returns 200 — verified in staging
Deadline: Friday EOD
Constraints: Use existing FastAPI order model; do not introduce new DB tables without discussion
Check-in: Wednesday if not yet in review
```

## Follow-up Cadence

| Direct Report | Async check-in | Sync review |
|---------------|----------------|-------------|
| CTO | Daily standup summary (written) | Weekly strategy review |
| CMO | Weekly campaign performance report | Weekly strategy review |
| Head of Operations | Weekly fulfillment ops summary (orders in/out, QC rate, MCAE status) | Weekly strategy review |

- If a P1 item is open, check in with the owning direct report every 24 hours until resolved
- P0 items: real-time coordination until resolved; CEO stays in the loop throughout

## Anti-patterns

- Delegating without a clear done state — leads to rework and missed expectations
- Pulling decisions back from CTO / CMO after delegating — undermines trust and speed
- Treating MCAE vendor issues as purely operational when order backlog is building — escalate to CEO at P1 threshold
- Allowing direct reports to absorb P0 issues without notifying CEO — sets wrong precedent for a small DTC team
