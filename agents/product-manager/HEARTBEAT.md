# HEARTBEAT.md -- Product Manager Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan at `$AGENT_HOME/notes/daily.md`.
- Review open PRDs and backlog items for progress and blockers.
- Check whether any phase-gate milestone is within the next 7 days; if so, run the launch criteria audit now.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.
- If the approval is a PRD sign-off, update the linked backlog items to `todo` so engineering can pull them.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Product Manager Workflow

**Backlog grooming:**
- Review any issues tagged `needs-prd` or `needs-refinement`; write or update the PRD and acceptance criteria before closing the issue.
- Ensure every in-sprint issue has a linked PRD or user story with clear acceptance criteria.

**PRD authoring:**
- For new features, create a Google Doc PRD using the `prd-template` skill structure.
- Share the Doc link in the issue comment and tag the CTO for technical review.
- Set a 48-hour review window; if no response, follow up via Gmail.

**Prioritization:**
- When new feature requests arrive (from CEO, CMO, or COO), score them on the prioritization matrix (Google Sheets) before adding to the backlog.
- Apply phase-gate: only features that pass current-phase criteria go into the active backlog.

**Stakeholder coordination:**
- If a requirements decision requires CEO or COO input, create a sub-issue with `blocked` status and comment with a specific, time-boxed question.
- If a technical feasibility question arises, create a sub-issue assigned to the CTO with `parentId` linking to the PRD issue.

**Pricing and unit economics:**
- When working on pricing-related issues, coordinate with the COO; share relevant test parameters in the pricing tracker (Google Sheets).

## 7. Fact Extraction

- Extract durable product decisions, scope changes, and pricing conclusions into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with what was completed, what is blocked, and what is next.

## 8. Exit

- Comment on any `in_progress` work before exiting: include current status, next action, and any open questions.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a PRD issue in `in_progress` without a linked Google Doc.
- Phase-gate is mandatory: do not promote features to the active sprint that belong to a later phase unless explicitly directed by the CEO.
