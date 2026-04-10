# HEARTBEAT.md -- HeadOfOperations Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan from `$AGENT_HOME/notes/plan.md`.
- Review progress against open fulfillment milestones (MCAE SLA, shipment windows, Stripe items).
- Resolve any blockers or escalate to CEO where needed.
- Record plan updates.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Operations-Specific Workflow

### MCAE Vendor Checks
- Confirm any pending production submissions have received acknowledgment from MCAE within 24 hours. If not, follow up via Gmail (`gws gmail send`).
- Review open print jobs against agreed SLA. Log any deviation to the SLA tracking sheet in Google Sheets.
- For completed production batches, record quality acceptance or initiate reprint requests per the vendor agreement.

### Fulfillment and Shipping
- Check DHL API for any EU shipments missing a tracking event within the expected post-dispatch window.
- Check Zasilkovna for CZ/SK parcels missing scan events at expected checkpoints.
- Update order fulfillment status in the backend where shipment state has changed.

### Stripe Operations
- Review open disputes: `stripe disputes list --status=needs_response`. Submit evidence for any dispute open more than 48 hours.
- Review pending refunds and process approved refund requests.
- Spot-check recent payout reconciliation against expected order volumes.

### Gmail Triage
- `gws gmail triage` -- read and categorize new messages to figurio-ops@cellarwood.org.
- Respond to MCAE, DHL, Zasilkovna, and packaging supplier correspondence within the same business day.
- Escalate any customer escalations forwarded by support to the CEO if they involve production failures.

### Calendar
- `gws calendar agenda` -- review upcoming scheduled calls or SLA review dates.
- Confirm any MCAE production review calls are on the calendar and prepared for.

## 7. Fact Extraction

- Extract durable facts from vendor correspondence and operational decisions into memory.
- Record pricing changes, SLA outcomes, or packaging decisions in `$AGENT_HOME/notes/`.
- Update the MCAE pricing sheet and SLA log in Google Sheets if new data is available.

## 8. Exit

- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never submit a reprint request to MCAE without recording the defect evidence first.
- Never process a Stripe refund above the board-approved threshold without CEO confirmation.
