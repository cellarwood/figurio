---
name: delegation-playbook
description: >
  Rules for how the Figurio CEO agent delegates tasks to CTO, CMO, and Head of
  Operations — covering when to delegate vs handle personally, escalation criteria,
  and follow-up cadence across the 9-agent figurine e-commerce company.
metadata:
  paperclip:
    tags:
      - leadership
      - delegation
      - operations
---

# Delegation Playbook

## When to Use

Use this skill whenever the CEO agent needs to assign work, route a decision, or
follow up on an outstanding task. It prevents both under-delegation (CEO doing work
that belongs to a domain lead) and over-delegation (sending unclear or premature
tasks that bounce back).

---

## The Three Domain Leads

| Lead | Domain | What They Own |
|------|--------|---------------|
| **CTO** | Engineering & infrastructure | FastAPI backend, React/TS frontend, Docker/K8s, PostgreSQL, AI figurine pipeline, scan-to-print Phase 2 |
| **CMO** | Marketing & growth | Customer acquisition, campaign performance, content pipeline, CAC, conversion rate |
| **Head of Operations** | Fulfillment & payments | MCAE print queue, Stratasys J55 quality, delivery SLAs, Stripe payment flows |

The CTO, CMO, and Head of Operations each manage sub-agents beneath them. Delegate
to the lead, not past them.

---

## When to Delegate vs Handle Personally

### Delegate to CTO when:
- A feature or bug affects any part of the platform (frontend, backend, infra)
- The AI-prompt or scan-to-print pipeline needs changes
- There is a production incident (CTO is the first call, not the engineers directly)
- A technical architecture decision needs to be made

**Do not** delegate engineering tasks directly to Backend Engineer, Frontend Engineer,
or DevOps — those agents report to the CTO.

### Delegate to CMO when:
- A campaign, content piece, or channel experiment needs to be planned or evaluated
- CAC is rising or conversion is dropping and a marketing hypothesis is needed
- A new product line (e.g., scan-to-print Phase 2) needs a go-to-market plan
- Brand or copy decisions arise

**Do not** delegate content creation or content review tasks directly to Content Creator
— that agent reports to the CMO.

### Delegate to Head of Operations when:
- An order is stuck in the MCAE print queue or exceeds SLA
- A Stripe payment or refund issue is reported by support
- Print quality complaints from customers need investigation with MCAE
- Shipping or delivery logistics need adjustment

**Do not** contact MCAE directly unless the Head of Operations is unresponsive for more
than 24 hours on a P0 issue.

### Handle Personally (CEO does not delegate):
- Final go/no-go on new product lines
- Public-facing crisis communications
- Budget reallocation decisions above a material threshold
- Decisions that require resolving conflict between two domain leads
- Weekly operating brief distribution after strategy review

---

## How to Write a Delegation

Every task delegated to a domain lead must include:

```
Task: [one sentence describing the output required]
Context: [why this matters now — link to goal or blocker]
Acceptance criteria: [what "done" looks like]
Due: [specific date, not "ASAP"]
Priority: [P0 / P1 / P2]
```

Vague delegations ("look into the conversion issue") return vague results. Be specific.

---

## Escalation Criteria

Escalate a delegated task back to CEO-level attention when:

- A P0 task has no update after **4 hours**
- A P1 task has no update after **24 hours**
- The domain lead indicates the task requires a cross-domain decision
- MCAE reports a print failure that affects more than 5 customer orders

When escalating, the CEO agent resolves the blocker directly or calls a synchronous
decision with the relevant leads — do not re-delegate without removing the root cause.

---

## Follow-up Cadence

| Priority | First follow-up | Max wait before escalation |
|----------|----------------|---------------------------|
| P0 | 2 hours | 4 hours |
| P1 | 24 hours | 48 hours |
| P2 | 72 hours | 1 week |

Follow-up should be a single, direct status request — not a reminder chain. If a second
follow-up is needed, treat it as an escalation signal.

---

## Anti-patterns

- Delegating to sub-agents directly, bypassing the domain lead — this breaks the
  reporting chain and creates conflicting priorities
- Sending a task without acceptance criteria — leads cannot self-assess completion
- Delegating a decision that has not been framed yet — think it through first, then hand
  it off
- Following up more than once before the agreed cadence — it signals distrust and
  creates noise for the domain lead
