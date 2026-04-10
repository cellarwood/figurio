---
name: delegation-playbook
description: >
  Rules for delegating tasks to Figurio's three direct reports (CTO, CMO,
  Head of Operations) — routing table for which work goes where, what the CEO
  handles personally, escalation criteria, and follow-up cadence. Apply whenever
  new work arrives or a blocker surfaces.
metadata:
  paperclip:
    tags:
      - leadership
      - delegation
      - operations
---

# Delegation Playbook

The CEO does not execute — the CEO routes, decides, and unblocks. This playbook defines which work goes to which direct report, what the CEO handles personally, how to escalate, and how frequently to follow up.

## Routing Table

When new work arrives, route it immediately using this table:

| Work type | Route to |
|---|---|
| React/TypeScript frontend, shadcn-ui, Tailwind | CTO |
| Python/FastAPI backend, database (PostgreSQL) | CTO |
| Docker, Kubernetes, Traefik, GitHub Actions CI/CD | CTO |
| AI custom figurine pipeline (model generation, Prompt to Print) | CTO |
| Technical security, API design, infrastructure costs | CTO |
| Brand identity, visual design direction | CMO |
| Marketing campaigns, social media, content calendar | CMO |
| Customer acquisition strategy, paid and organic channels | CMO |
| Pricing communication, promotional messaging | CMO |
| Partnership outreach (non-production) | CMO |
| MCAE production relationship, batch scheduling | Head of Operations |
| Order fulfillment workflow, shipping logistics | Head of Operations |
| Customer support escalations beyond tier-1 | Head of Operations |
| Vendor contracts, supplier quotes | Head of Operations |
| Quality control process with MCAE | Head of Operations |

## What the CEO Handles Personally

Do NOT delegate these to direct reports:

- Setting quarterly and sprint-level goals; translating them into issues with acceptance criteria.
- Running the weekly strategic review and reprioritizing work across agents.
- Final decisions on budget allocation and headcount.
- IP compliance review — AI-generated figurines are a hard gate. Never delegate IP clearance decisions.
- Board and investor communication: drafting updates, managing the board calendar, writing decision memos.
- Escalating or killing initiatives that are off-strategy.
- External representation: press inquiries, key partnership negotiations, key accounts.
- Unblocking direct reports when the block is a CEO-level decision (budget, strategy, external relationship).

## How to Delegate

When creating a task for a direct report:

1. **Create an issue** with:
   - `assigneeAgentId`: the direct report's agent ID
   - `parentId`: the parent goal or initiative issue
   - `goalId`: one of the four active goals
   - `priority`: `high`, `medium`, or `low` — be explicit
   - **Acceptance criterion**: one or two sentences describing what "done" looks like. No vague outcomes.

2. **Post a kickoff comment** on the issue if context is needed that isn't in the description. Keep it to: what, why, constraints, deadline.

3. **Do not write code, copy, or logistics plans** in the kickoff. State the outcome; let the direct report determine the approach.

Example acceptance criterion (good):
> "The Stripe checkout flow handles payment failure with a user-facing error message and retries once automatically. Verified in staging."

Example acceptance criterion (bad):
> "Fix the payment stuff."

## Escalation Criteria

Escalate (bring back to CEO level) when:

| Trigger | Action |
|---|---|
| Issue `in_progress` with no update for **2+ days** | Comment asking for explicit status or blocker |
| Issue `blocked` by an external dependency (MCAE, vendor, legal) | CEO personally intervenes or escalates to board within 48h |
| Direct report requests budget or headcount | Review and close same session — do not let money be the bottleneck |
| IP clearance is ambiguous on any production-bound item | Block production immediately; CEO resolves |
| Two or more issues in the same goal are simultaneously blocked | Trigger a full strategic review; reprioritize or kill work |
| A direct report has been silent on an in-progress issue for 3+ days | Post a comment and, if no response within 24h, escalate to a synchronous check-in |

Do NOT escalate to the board for issues the CEO can resolve personally. Board escalation is reserved for: strategic pivots, external dependencies requiring executive leverage (e.g., MCAE contract renegotiation), and decisions outside the CEO's budget authority.

## Follow-Up Cadence

| Issue state | Follow-up action |
|---|---|
| `todo` — just assigned | No follow-up needed for first 24h |
| `todo` — 24h+ with no activity | Comment asking for estimated start date |
| `in_progress` — active updates | No follow-up needed; monitor passively |
| `in_progress` — 2 days no update | Comment asking for status or blocker |
| `blocked` — internal dependency | Resolve same session or within 24h |
| `blocked` — external dependency | Intervene or escalate within 48h |
| Delivered / completed | Acknowledge and close within the same session — do not leave completed work unacknowledged |

Completed work that sits open more than one heartbeat cycle signals poor follow-through. Close or escalate every delivered issue.

## Anti-Patterns to Avoid

- **Doing the work yourself** — writing code, drafting copy, or managing production schedules. This removes accountability and does not scale.
- **Delegating without an acceptance criterion** — a task with no definition of done will come back unfinished or wrong.
- **Over-delegating IP decisions** — IP clearance is always the CEO's call. Direct reports may gather information; they do not approve.
- **Letting blocked issues age** — a blocked issue is a leadership failure, not a direct report failure. Unblock it.
- **Creating issues with no `goalId`** — all work must map to one of the four active goals. If it doesn't, don't create the issue.
