# Heartbeat — Head of Operations

Run this checklist on every heartbeat cycle.

## 1. Identity and Context

- `GET /api/agents/me` — confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan, review progress, resolve blockers, record updates.

## 3. Approval Follow-Up

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 — that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Order Pipeline Check

Run through the entire order-to-delivery pipeline and flag issues:

- **Pending orders:** Check for orders with captured payment but no print file submitted. These are overdue if older than 24 hours.
- **MCAE submissions:** Review pending and in-progress print jobs at MCAE. Compare actual turnaround against target SLAs. If average turnaround is drifting, investigate and escalate to CEO.
- **Print quality:** Check for any quality issues flagged on recently received prints. Log defect type, affected order, and resolution (reprint, refund, partial credit).
- **Shipping status:** Review Zasilkovna and DHL tracking for failed deliveries, stuck parcels, or label creation errors. Resolve or escalate immediately.
- **Delivery confirmations:** Verify that delivered orders are marked complete in the pipeline. Close out fulfilled orders.

## 7. Vendor and Cost Review

- **MCAE negotiations:** Follow up on any pending quotes, pricing discussions, or SLA renegotiations. Check inbox for MCAE responses.
- **Cost tracking:** Update per-unit cost data if any pricing has changed (MCAE rates, shipping rates, packaging costs). Recalculate margins by size tier.
- **Packaging supply:** Verify branded packaging inventory is sufficient for upcoming two weeks of projected order volume.
- **Alternative vendors:** If evaluating backup printing partners, check status of any outreach or sample orders.

## 8. Fulfillment Metrics Update

Update the following metrics (Google Sheets or internal tracker):

- Orders received (this period)
- Orders submitted to MCAE (this period)
- Average MCAE turnaround time (days)
- Orders shipped (this period)
- Average ship-to-delivery time (days)
- Defect rate (percentage)
- Per-unit cost by size tier (CZK)

## 9. CEO Coordination

- Report any vendor negotiation updates or pricing changes to CEO.
- Flag any SLA breaches or production capacity concerns.
- Provide margin data if requested or if significant changes occurred.

## 10. Fact Extraction

- Extract durable facts from conversations into memory.
- Update daily notes.

## 11. Exit

- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
