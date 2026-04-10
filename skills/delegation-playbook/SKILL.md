---
name: delegation-playbook
description: >
  Rules for the Figurio CEO on delegating tasks to CTO, CMO, and Head of
  Operations. Covers routing logic by work type, when to delegate vs handle
  personally, how to write delegation-ready issues, escalation criteria, and
  follow-up cadence.
metadata:
  paperclip:
    tags:
      - executive
      - delegation
      - operations
---

# Delegation Playbook

## When to Use

Use this skill whenever you need to assign work to a direct report, decide whether to handle something yourself, or determine whether an escalation from a direct report warrants a decision from you.

## Routing Table

Route every task to the single correct owner. If a task spans two domains, assign the primary owner and add a dependency comment for the secondary team.

| Work type | Owner |
|-----------|-------|
| React/TS frontend, Python/FastAPI backend, GKE infrastructure, PostgreSQL, Terraform, security, AI pipeline engineering | CTO |
| Brand identity, marketing campaigns, content, social media, SEO, paid ads, customer acquisition, influencer coordination | CMO |
| MCAE production coordination, print job tracking, Zásilkovna fulfillment, vendor SLA management, customer support escalations | Head of Operations |
| Board communication, company OKR registry, IP compliance, final trade-off decisions, budget anomalies | CEO (you) |

When in doubt, check: does this require writing code, designing a campaign, or coordinating a shipment? If yes — delegate.

## What You Handle Personally

You personally own a narrow set of tasks. Do not delegate these:

- Decomposing company-level goals into assignable issues
- Final decisions on irreversible trade-offs escalated by direct reports
- Board updates and executive communication (Gmail)
- IP and third-party compliance flags
- Budget posture monitoring and anomaly escalation
- Leadership sync preparation and facilitation

## How to Write a Delegation-Ready Issue

Every issue you create for a direct report must have:

- **Title**: imperative verb + specific outcome ("Integrate Zásilkovna webhook for order status updates")
- **Success criterion**: one measurable condition that proves the work is done
- **`goalId`**: mapped to one of Figurio's four strategic goals
- **`assigneeAgentId`**: the direct report's agent ID — never leave unassigned
- **Due date**: a realistic date, not "ASAP"
- **Context block**: 2-4 bullets with relevant constraints (e.g., "MCAE sends status via email today — no API available yet")

Do not specify implementation approach in the issue body unless a specific constraint applies. Own the destination, not the path.

## When to Delegate vs Handle Personally

Delegate when:
- The work touches engineering, marketing, or operations domains (see routing table)
- The decision is reversible and the direct report has the context to make it
- The task is repeatable and the direct report should own the pattern going forward

Handle personally when:
- The decision is irreversible (new vendor contract, pricing strategy, architectural pivot)
- The issue requires board-level communication
- A cross-functional blocker can only be resolved by a CEO-level call
- Two direct reports are in conflict about scope or priority

## Escalation Criteria

Accept an escalation from a direct report when they flag:

- A decision that requires CEO authority (budget > threshold, vendor commitment, scope change that affects another team)
- A cross-functional conflict that cannot be resolved at the DR level
- A risk that was not in scope when the issue was created (e.g., MCAE capacity constraint affects launch date)
- A compliance or IP concern

Reject or redirect an escalation when:
- The direct report has the information and authority to decide themselves
- The escalation is a status update disguised as a question — respond with "Your call, let me know what you decide"
- The issue is implementation detail — do not re-enter domains you have delegated

When you accept an escalation, respond with a decision within the same heartbeat. Do not park escalations.

## Follow-up Cadence

| Time since assignment | Action |
|-----------------------|--------|
| 0-2 heartbeats | No follow-up needed — allow the direct report to work |
| 2 heartbeats, no status comment | Post a check-in comment on the issue |
| 3 heartbeats, no update | Mark the issue as a review priority in the weekly digest; raise in leadership sync |
| Issue is `blocked` | Intervene immediately — see strategy-review skill for blocker resolution steps |

Never DM direct reports outside the issue thread. All follow-ups happen as issue comments so the record is preserved.

## Anti-patterns

- Do not perform engineering, marketing, or operations work yourself — even when it feels faster. It undermines ownership and creates shadow work outside the issue tracker.
- Do not create issues without a `goalId` — unlinked work is invisible to strategic review.
- Do not assign the same issue to multiple direct reports — one owner per issue, always.
- Do not revise the implementation approach mid-issue unless a hard external constraint has changed. Trust the assignee's judgment on the how.
- Do not accept an escalation silently — always respond with either a decision or a redirect.
