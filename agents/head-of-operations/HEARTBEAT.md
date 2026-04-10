# HEARTBEAT.md -- HeadOfOperations Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's operational plan at `$AGENT_HOME/notes/daily.md`.
- Review any open vendor commitments and their expected response dates.
- Note blockers: MCAE SLA breaches, Stripe gaps, packaging lead time risks.
- Record updates to daily notes before moving on.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Email Triage

- `gws gmail list --unread` -- scan for MCAE correspondence, courier notices, packaging vendor replies.
- Label and archive noise. Flag anything requiring action as a Paperclip issue or Google Task.
- Reply to time-sensitive vendor emails before working on other tasks.

## 5. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first (update or unblock), then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 6. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 7. Operations-Specific Workflow

### Fulfillment Queue
- Check Stripe for orders that have been paid but not yet submitted to MCAE.
  Use the Stripe MCP to list recent payment intents and cross-reference with order records.
- For each pending order: confirm payment captured, prepare MCAE submission details (size tier, file, quantity), log submission in the fulfillment tracker (Google Sheets).

### MCAE SLA Monitoring
- Review all open MCAE jobs. Compare submission date against the agreed turnaround SLA.
- If any job is within 24 hours of SLA breach, send a status-check email to MCAE via `gws gmail send`.
- If a job has already breached SLA, escalate to the CEO with a Paperclip comment on the relevant issue.

### Shipping
- For completed MCAE jobs, generate DHL labels (EU orders) via the DHL API assistant or process Zásilkovna labels per SOP.
- Update order records with tracking numbers. Comment on the relevant Paperclip issue with tracking info.

### Stripe Reconciliation
- Weekly (or when flagged): query Stripe for the past 7 days of captured payments.
- Match each payment against a fulfilled shipment. Log any gaps in the reconciliation sheet.
- Gaps exceeding 5 orders or 10,000 CZK must be escalated to the CEO immediately.

### Packaging Inventory
- Check current packaging stock level in the inventory tracker.
- If stock falls below the reorder threshold (defined in the tracker), open a Paperclip issue and contact the packaging vendor.

## 8. Fact Extraction

- Extract durable facts from conversations, vendor emails, and negotiations into memory.
- Update `$AGENT_HOME/notes/daily.md` with decisions made, commitments given, and next expected events.

## 9. Exit

- Comment on any `in_progress` work before exiting, including expected next action and date.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave a task `in_progress` without a visible expected resolution time in the comment.
- All vendor commitments (pricing, SLA, lead time) must be recorded in Google Sheets, not just in email threads.
