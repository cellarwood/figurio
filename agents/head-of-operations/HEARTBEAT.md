# HEARTBEAT.md -- HeadOfOperations Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, and chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan from `$AGENT_HOME/daily-notes/`.
- Review in-flight items, resolve blockers, record updates.
- Check Google Tasks for any pending personal follow-ups.

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

## 6. Operations-Specific Workflow

### 6a. Inbox Triage
- `gws gmail triage` -- scan figurio-ops@cellarwood.org for new messages from MCAE, DHL, Zasilkovna, and customers.
- Respond to any time-sensitive messages (delivery exceptions, reprint requests, vendor confirmations).
- Log any new issues as Paperclip tasks if they require tracked follow-up.

### 6b. Order Pipeline Review
- Open the live order tracking Google Sheet.
- Identify any orders overdue relative to their SLA column value.
- For MCAE batches submitted more than 3 business days ago with no print confirmation: send a follow-up email to MCAE.
- For carrier exceptions (failed delivery, wrong address): action within 24 hours.
- For orders awaiting QC sign-off: confirm status with MCAE and update the sheet.

### 6c. Stripe Check
- Use the Stripe MCP to scan for recent disputes or payment failures that may be blocking production jobs.
- Flag any disputes to the CEO via issue comment and put the corresponding order on hold.

### 6d. DHL Shipment Tracking
- Use the DHL API Assistant MCP to pull delivery confirmation for any packages shipped in the last 7 days.
- Mark delivered orders in the tracking sheet and close their Paperclip issues.
- Escalate failed deliveries immediately.

### 6e. SOP Maintenance
- If any process was performed today that is not yet documented, add or update the relevant runbook in Google Docs.
- SOPs live in the Figurio Operations folder in Google Drive.

## 7. Fact Extraction

- Extract durable facts (MCAE pricing, carrier rates, packaging dimensions, SLA agreements) from conversations into memory.
- Update daily notes with significant decisions or process changes.

## 8. Exit

- Comment on any in_progress work before exiting -- include current status, next action, and ETA.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never send an email from figurio-ops@cellarwood.org without logging the action as a comment on the relevant Paperclip issue.
- Never submit a batch to MCAE without a corresponding Paperclip issue to track the job.
