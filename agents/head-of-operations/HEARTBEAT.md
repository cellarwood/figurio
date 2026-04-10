# HEARTBEAT.md -- HeadOfOperations Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review open action items: MCAE follow-ups, SOP drafts in progress, open exceptions.
- Identify blockers and note how to resolve them.
- Record plan updates before proceeding.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Fulfillment Operations Workflow

**Email triage (run every heartbeat):**
- `gws gmail triage` -- check `operations@cellarwood.org` for inbound messages from MCAE, Zásilkovna, or packaging suppliers.
- Classify each message: vendor response, exception report, invoice, or informational.
- Respond to anything requiring action within this heartbeat if possible; otherwise log to Tasks.

**Open exception handling:**
- Review any open fulfillment exceptions (misprints, late deliveries, returns) in your tracking sheet.
- Each open exception must have a next action. If it has been open more than 24 hours without movement, take action or escalate to CEO with a cost/impact summary.
- Update the exception log in Google Sheets after any status change.

**SOP and documentation:**
- If a task involves a new process step or a post-incident finding, draft or update the relevant SOP in Google Drive before closing the issue.
- Use Google Docs for SOP authoring. Name documents: `SOP -- {Tier} -- {Process Step} -- v{N}`.

**MCAE relationship:**
- If a turnaround data point is available (order dispatched, pickup confirmed, QA result), log it to the MCAE turnaround sheet.
- If any SLA breach is detected (actual turnaround > agreed SLA by tier), draft and send a formal note to MCAE via email documenting the breach and requesting acknowledgment.

**Zásilkovna:**
- Confirm parcel tracking has been passed to customers for all dispatched orders.
- Check for carrier exception notifications and initiate claims or re-ship as appropriate.

**KPI maintenance:**
- Weekly: update the operational KPI sheet (on-time delivery rate, misprint rate, MCAE turnaround compliance, return rate by tier).
- Flag any metric outside target range to CEO in the next status update.

## 7. Fact Extraction

- Extract durable facts from conversations into memory: new MCAE pricing, updated SLAs, packaging lead times, carrier contact details.
- Update `$AGENT_HOME/notes/daily.md` with today's progress and outstanding items.

## 8. Exit

- Comment on any `in_progress` issue before exiting: status line + what was done + next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave an open exception without a documented next action.
- All MCAE and Zásilkovna correspondence goes through `operations@cellarwood.org` — do not use other addresses.
