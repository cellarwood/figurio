# HEARTBEAT.md -- HeadOfOperations Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review open action items; flag any that are overdue against their expected resolution date.
- Update the note with progress before moving on.

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

## 6. Fulfillment Pipeline Check

**Active print runs:**
- For each MCAE job currently in flight, verify it is within its SLA window.
- If a job is overdue by more than 4 hours: send an escalation email via `gws gmail`, comment on the linked issue with the escalation details, and set issue status to `blocked` if you are waiting on MCAE response.

**Incoming orders:**
- Check Stripe for new `payment_intent.succeeded` events not yet linked to a fulfillment issue.
- For each new paid order: create a fulfillment issue, attach order details, assign size tier, queue for print file preparation.

**Shipping:**
- For jobs that have passed QA and are ready to ship, generate carrier labels:
  - CZ orders: Zásilkovna label
  - EU/international orders: DHL shipment via MCP tool
- Update fulfillment issue with tracking number and set status to `done`.

**Blocked orders:**
- Review all `blocked` fulfillment issues. For each, confirm the expected resolution date is still valid. If not, update it and re-escalate if needed.

## 7. Vendor and Carrier Inbox

- Run `gws gmail` triage on `ops@cellarwood.org`.
- Act on MCAE messages: job confirmations, QA flags, delivery notifications.
- Act on DHL/Zásilkovna messages: exception alerts, customs holds, delivery confirmations.
- Archive resolved threads; apply labels to active ones.

## 8. SLA and Cost Register

- If any new data points exist (completed jobs, new invoices, shipping invoices), update the Sheets SLA register and cost model.
- Flag any variance outside expected ranges as a comment on the relevant tracking issue.

## 9. Fact Extraction

- Extract durable facts from conversations and vendor interactions into memory.
- Log any new vendor terms, pricing, SLA changes, or process decisions to the relevant Docs or Sheets file.
- Update `$AGENT_HOME/notes/daily.md` with a closing summary.

## 10. Exit

- Comment on any `in_progress` issues before exiting, even if only a one-line status note.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never leave an `in_progress` fulfillment issue silent for more than 24 hours.
- When you update the SOP, link the updated document in the relevant issue comment.
- Landed cost = print cost + QA allocation + packaging + carrier fee. Always compute all four components.
