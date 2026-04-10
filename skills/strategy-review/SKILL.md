---
name: strategy-review
description: >
  Weekly strategic review process for Figurio — evaluate progress against the five
  company goals (MVP platform, AI pipeline, fulfillment ops, brand/acquisition,
  scan-to-print Phase 2), identify cross-functional blockers, and reprioritize
  work across the eight-agent org. Run when last review was more than five days ago.
allowed-tools:
  - Read
  - Write
  - Bash
metadata:
  paperclip:
    tags:
      - strategy
      - leadership
      - weekly
---

# Strategy Review

## When to Run

Run a full strategic review when:
- It has been more than 5 days since the last review (check `$AGENT_HOME/memory/` for last review date)
- A blocker surfaces that touches more than one team
- A major milestone is within 7 days

Do NOT run on every heartbeat. This is a weekly cadence, not a daily one.

## The Five Company Goals

Every review scores each goal on: **On Track / At Risk / Blocked**.

| # | Goal | Owner | Key Signal |
|---|------|-------|------------|
| 1 | Launch MVP e-commerce platform | CTO | Platform issues in `in_progress` or `done` |
| 2 | Launch AI prompt-to-print pipeline | CTO | AI pipeline issues; staging/prod deploy status |
| 3 | Establish production and fulfillment with MCAE | Head of Operations | Open ops issues; MCAE coordination status |
| 4 | Build brand and acquire first customers | CMO | Campaign issues; first-order milestone |
| 5 | Research Phase 2 scan-to-print capability | CEO (business) + CTO (technical) | Research brief in Google Drive; open research issues |

## Step-by-Step Process

### 1. Pull Cross-Team Issue Data

```
GET /api/companies/{companyId}/issues?status=todo,in_progress,blocked
```

Filter by each direct report's team. Look for:
- Issues `in_progress` for more than 3 days with no comment update — these are stale
- Issues with `status=blocked` — each needs an unblocking action before you exit
- Issues without a `goalId` — these are unanchored work; evaluate whether they belong

### 2. Score Each Goal

For each of the five goals, determine the status:

- **On Track** — active progress, no blockers, milestone timeline intact
- **At Risk** — slow progress, stale issues, dependency unclear, or timeline slipping
- **Blocked** — hard blocker with no current owner or action

Write the score and one-sentence rationale. Do not pad.

### 3. Identify Cross-Functional Blockers

A cross-functional blocker exists when:
- A CTO deliverable is required before CMO or Ops can proceed
- MCAE fulfillment readiness blocks platform launch
- AI pipeline completion blocks marketing launch materials
- Phase 2 research has technical questions outstanding from CTO

For each cross-functional blocker: name the issue, name the blocking dependency, name the two teams affected, and assign a resolution action.

### 4. Comment on Stale and Blocked Issues

For each stale `in_progress` issue (>3 days, no update):
```
Status check — this has been in_progress for X days without an update.
- What is the current state?
- Is there a blocker?
- Expected completion?
```

For each `blocked` issue, comment with the specific unblocking action and a deadline.

### 5. Reprioritize If Needed

Reprioritize when:
- A goal has moved from At Risk to Blocked
- Two goals are competing for the same agent's bandwidth
- A new dependency has emerged that changes sequencing

When reprioritizing, create or update issues with revised `priority` and `goalId`. Do not reassign work silently — always comment the rationale on the affected issues.

### 6. Update the Roadmap Document

Open the strategic roadmap in Google Drive. Update:
- Goal status badges (On Track / At Risk / Blocked)
- Any milestones that have shifted
- Next week's focus for each goal

Keep the roadmap doc under two pages. It is an executive artifact, not a task board.

### 7. Record the Review

Write a brief review record to `$AGENT_HOME/memory/strategy-review-{YYYY-MM-DD}.md`:

```
# Strategy Review — {date}

## Goal Statuses
1. MVP Platform — On Track / At Risk / Blocked
2. AI Pipeline — ...
3. Fulfillment Ops — ...
4. Brand/Acquisition — ...
5. Phase 2 Research — ...

## Cross-Functional Blockers
- [list or "None"]

## Reprioritization Actions
- [list or "None"]

## Next Review Trigger
{date + 5 days}
```

## Output Format

When reporting a review in an issue comment or digest, use this structure:

```
Weekly strategy review complete — {date}

Goals:
- MVP Platform: On Track — {one-line rationale}
- AI Pipeline: At Risk — {one-line rationale}
- Fulfillment Ops: On Track — {one-line rationale}
- Brand/Acquisition: On Track — {one-line rationale}
- Phase 2 Research: On Track — {one-line rationale}

Blockers addressed: {N}
Stale issues commented: {N}
Roadmap updated: yes/no
```

## Anti-Patterns

- Do not score a goal "On Track" because no one has complained — verify with issue data
- Do not skip the roadmap update because it feels minor — the board reads it
- Do not resolve a cross-functional blocker without leaving a comment on the affected issue
- Do not run the review from memory — always pull fresh issue data from the API
