---
name: strategy-review
description: >
  Weekly strategic review process for the Figurio CEO. Covers how to evaluate
  progress across CTO, CMO, and Head of Operations, surface stale or blocked
  issues, reprioritize against Figurio's four strategic goals, and produce a
  board-ready weekly digest.
allowed-tools:
  - Bash
  - Read
  - Write
metadata:
  paperclip:
    tags:
      - strategy
      - executive
      - weekly
---

# Strategy Review

## When to Use

Run this skill once per week as part of the weekly strategic review cycle — typically triggered by a scheduled heartbeat or a calendar reminder. Also run it when the company enters a new milestone phase or after a significant external event (MCAE delivery failure, Stripe integration issue, major customer complaint).

## Figurio's Four Strategic Goals

Every issue reviewed must map to one of these goals. If it does not, flag it for closure or re-scoping.

1. **Launch e-commerce platform** — catalog browsing, Stripe checkout, order management live for customers
2. **Launch Prompt to Print AI pipeline** — end-to-end custom figurine flow: prompt → AI model → MCAE print job → fulfillment
3. **Build brand presence and acquire first customers** — marketing, SEO, social, launch campaign, first 100 orders
4. **Establish reliable production and fulfillment operations** — MCAE SLA adherence, Zásilkovna integration, support operations

## Review Process

### Step 1 — Pull All Active Issues

Query all issues assigned to direct reports with status `todo`, `in_progress`, or `blocked`:

```
GET /api/companies/{companyId}/issues?status=todo,in_progress,blocked
```

Group by assignee: CTO, CMO, Head of Operations.

### Step 2 — Assess Each Issue Against Four Criteria

For every `in_progress` issue, ask:

| Criterion | Pass | Flag |
|-----------|------|------|
| Maps to a strategic goal (`goalId` set) | Yes | Missing `goalId` — add or close |
| Has a status comment within the last 2 heartbeats | Yes | Stale — post follow-up |
| Not blocked without an owner on the blocker | Clear | Blocked silently — intervene |
| Due date is realistic given current velocity | Yes | Slipping — reprioritize or descope |

### Step 3 — Handle Stale Issues

If an issue has been `in_progress` for 2+ heartbeats with no status comment, post:

```
Status check: this issue has had no update in 2+ cycles.
- Current status?
- Any blockers I should know about?
- Do you need a decision from me to unblock?
```

Tag the assignee. Do not change the status yet — wait for their response.

### Step 4 — Resolve or Escalate Blockers

For each `blocked` issue, determine blocker type:

- **Decision blocker** — the direct report needs a call from you (vendor choice, trade-off, scope cut). Make the call immediately and comment the decision.
- **External blocker** — depends on MCAE, Zásilkovna, Stripe, or another vendor. Contact the external party directly or assign a vendor follow-up task to Head of Operations.
- **Cross-functional blocker** — one team is waiting on another (e.g., CMO waiting on CTO for landing page API). Create a dependency comment on both issues and set a resolution deadline.

Never let a `blocked` issue sit without a comment or action for more than one review cycle.

### Step 5 — Reprioritize

After reviewing all issues, assess the overall picture:

- Are any goals underserved (no active `in_progress` issues)?
- Are too many issues clustered in one area while another goal stalls?
- Does any `todo` issue need to be promoted to `in_progress` immediately?

Adjust by commenting priority changes on issues and notifying the relevant direct report.

### Step 6 — Draft the Weekly Digest

Create or update the weekly digest doc in Google Drive using `gws docs`.

**Digest structure:**

```
Week of [DATE] — Figurio Strategic Digest

## Goal Progress
- E-commerce platform: [status, key milestone hit or missed]
- Prompt to Print: [status]
- Brand & acquisition: [status]
- Production & fulfillment: [status]

## This Week's Wins
- [bullet]

## Active Blockers
- [issue title] — [blocker description] — [owner of resolution]

## Decisions Made
- [decision] — [rationale in one sentence]

## Next Week's Focus
- [top 3 priorities]
```

Send the digest summary to the board via `gws gmail send` to `board@cellarwood.org`.

## Anti-patterns

- Do not write the digest before reviewing all issues — the review drives the content.
- Do not leave blockers unaddressed in the digest — every blocker must have a named resolution owner.
- Do not use the review to micromanage implementation — flag the what, not the how.
- Do not skip the goal-mapping check — issues without `goalId` are invisible to strategic tracking.
