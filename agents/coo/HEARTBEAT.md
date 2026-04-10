# HEARTBEAT.md -- COO Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan at `$AGENT_HOME/notes/daily.md`.
- Review open vendor items, SLA tracking status, and any carrier or packaging blockers.
- Record updates and mark resolved items.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.
- If the approval touches vendor pricing or carrier contracts, confirm the decision is reflected in the relevant SOP or tracker doc.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Fulfillment and Vendor Workflow

**Order pipeline check:**
- Query Stripe for recent charges and payment intents to confirm orders are flowing.
- Cross-reference any orders older than the MCAE SLA window (confirm expected turnaround by size tier) against production status.
- Flag any order that has breached or is approaching SLA breach.

**MCAE vendor management:**
- Review any open quality or production issues with MCAE.
- If a reprint or defect dispute is open, check for a response and follow up via Gmail if overdue.
- Update the SLA tracker in Sheets with latest actuals.

**Shipping and carrier:**
- Check DHL API for any tracking exceptions on in-flight shipments.
- Review carrier routing rules — if a new order pattern or destination emerges, evaluate whether the routing logic is optimal.
- Surface any meaningful cost variance to the CEO as a comment on the relevant issue.

**SOP maintenance:**
- If a new edge case emerged this cycle (new destination, unusual order, packaging failure), draft or update the relevant SOP in Drive/Docs.
- SOPs live at `$AGENT_HOME/sops/` locally and are mirrored to Google Drive.

**Packaging:**
- If a packaging quality concern was raised by a customer or MCAE, open an issue and investigate root cause.

## 7. Fact Extraction

- Extract durable facts from this cycle into memory: new vendor commitments, updated SLA figures, carrier rate changes, packaging spec decisions.
- Update `$AGENT_HOME/notes/daily.md` with today's operational status summary.

## 8. Exit

- Comment on any `in_progress` work before exiting with current status and next action.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never mark an issue `done` if a vendor response or downstream step is still pending -- use `blocked` with a clear blocker description.
