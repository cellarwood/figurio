---
name: strategy-review
description: >
  Weekly strategic review process for Figurio — evaluate progress against the
  four active company goals (MVP platform launch, AI custom figurine pipeline,
  brand building and first customer acquisition, production and fulfillment ops),
  identify blockers, and reprioritize work across agents. Run at every heartbeat
  and in full on Mondays.
metadata:
  paperclip:
    tags:
      - strategy
      - leadership
---

# Strategy Review

The weekly strategic review is the CEO's primary mechanism for keeping Figurio on track. It surfaces risk early, keeps direct reports unblocked, and ensures priorities reflect current reality rather than last week's assumptions.

## When to Run

- **Full review:** Every Monday (or the start of the work week).
- **Abbreviated sweep:** Every heartbeat cycle — check for goal drift and stale issues even when not doing the full review.

## The Four Active Goals

Always evaluate in this order — sequenced by dependency risk:

| # | Goal | Owner | Existential risk if late? |
|---|------|--------|--------------------------|
| 1 | Launch MVP e-commerce platform | CTO | Yes — nothing sells without it |
| 2 | Build AI custom figurine pipeline end to end | CTO / ML Engineer | Yes — "Prompt to Print" is the differentiator |
| 3 | Brand identity and first paying customer acquisition | CMO | High — cash flow depends on first orders |
| 4 | Stand up reliable production and fulfillment operations | Head of Operations | Yes — a fulfillment failure destroys trust |

## Full Weekly Review Process

### Step 1 — Goal Status Sweep

For each of the four goals:

1. Pull open issues tagged to the goal: `GET /api/companies/{id}/issues?goalId={goal-id}&status=todo,in_progress,blocked`
2. Identify the most at-risk goal (most blocked, most overdue, highest downstream impact).
3. Write a one-line status for each goal. Use this format:

```
Goal: MVP Platform
Status: ON TRACK | AT RISK | BLOCKED
Last milestone: [what completed]
Next milestone: [what is due and by when]
Blocker (if any): [specific blocker + owner]
```

### Step 2 — Direct Report Queue Scan

- Pull all open issues assigned to CTO, CMO, and Head of Operations.
- Flag any issue that has been `in_progress` with no update for more than **two days** — post a comment requesting a status or explicit blocker.
- Flag any `blocked` issue where the block is external (MCAE, vendor, legal) — CEO must personally intervene or escalate to board.

### Step 3 — Blocker Triage

For each active blocker:

| Blocker type | Action |
|---|---|
| Waiting on CTO / CMO / Head of Ops decision | Comment with explicit question and deadline |
| Waiting on MCAE or vendor | Head of Operations escalates; CEO owns strategic relationship if unresolved 48h+ |
| Waiting on budget approval | CEO resolves immediately — do not let money be the blocker |
| Waiting on IP clearance | CEO resolves — IP is a hard gate, never skip |
| Needs board input | Draft a decision memo and send; do not wait for next scheduled meeting |

### Step 4 — Reprioritization

If a goal is at risk, explicitly downgrade lower-priority work to free up capacity:

- Reassign issues from lower-priority goals to direct reports already loaded.
- Change issue priorities via `PATCH /api/issues/{id}` — update `priority` field.
- Post a comment on deprioritized issues explaining the trade-off and expected resumption date.
- Never deprioritize production ops or IP compliance — both are existential.

### Step 5 — New Work Decomposition

For any new strategic input (board request, market signal, partnership inquiry):

1. Decide: does this advance one of the four active goals, or is it a distraction?
2. If it advances a goal: create issues with `parentId`, `goalId`, and a clear acceptance criterion. Route to the right direct report.
3. If it does not advance a goal: document the decision to defer and the reasoning. Do not create issues.

### Step 6 — IP Compliance Check

- Review any new catalog figurines or AI pipeline outputs currently in review.
- Confirm each has passed IP clearance before approving for production.
- If clearance is ambiguous: block production, comment with the specific IP concern, escalate.

### Step 7 — Weekly Digest (Mondays)

After completing the review, draft the weekly digest:

- **Recipients:** Board / investors (via Gmail).
- **Content:** One paragraph per goal — status, last week's progress, this week's focus, risks.
- **Tone:** Confident and specific. Real numbers, real dates. Acknowledge problems with a plan.
- **Send via:** `gws gmail +send`

## Abbreviated Heartbeat Sweep

When not doing a full review, run steps 1, 2, and 3 only. Takes 5–10 minutes. The goal is to catch anything that went sideways since the last full review.

## Red Flags That Require Immediate Action

- Any goal has had zero issue progress for 3+ days.
- A direct report is waiting on a CEO decision and did not escalate — find and unblock proactively.
- MCAE has not confirmed a production batch that is now overdue.
- An AI pipeline output with an IP concern has moved to production without clearance.
- Stripe payments are failing or a customer has not received a confirmed order.

## Output Format

End every strategy review with a brief written summary logged to `$AGENT_HOME/notes/weekly-review-{YYYY-MM-DD}.md`:

```
# Strategy Review — [date]

## Goal Status
- MVP Platform: [status]
- AI Pipeline: [status]
- Brand / Acquisition: [status]
- Production Ops: [status]

## Top 3 Risks
1. [risk + owner + mitigation]
2. ...
3. ...

## Decisions Made
- [decision + rationale]

## Delegated This Session
- [issue] → [direct report]
```
