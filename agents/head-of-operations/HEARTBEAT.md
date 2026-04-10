# HEARTBEAT.md -- HeadOfOperations Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, and chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan from `$AGENT_HOME/notes/daily.md`.
- Review open action items, resolve any blockers you can action now, and record updates before continuing.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:

- Retrieve the approval record and its linked issues.
- If the approval covers an MCAE commitment or a shipping carrier setup, confirm the relevant SOP or SLA document has been updated in Drive.
- Close resolved issues or leave a comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can now unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task above all others.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Operations Domain Workflow

**Order Release Gate (run when a new order batch is ready):**

1. Confirm Stripe payment status via MCP — do not release to MCAE until `payment_intent.succeeded` is confirmed.
2. Run IP compliance review on any custom figurine content (image references, character descriptions).
3. Prepare the MCAE file handoff package (model file, color profile, size tier, quantity).
4. Send handoff email from `operations@cellarwood.org` via `gws gmail send`, CC the shared ops inbox.
5. Log the handoff in the Sheets order tracker (date, order IDs, MCAE reference, expected completion).

**Shipping Coordination:**

- For CZ orders: confirm Zásilkovna pickup slot and label workflow. Log tracking numbers in the Sheets tracker.
- For EU orders: use DHL API Assistant to generate label specs or check shipment status. Hand programmatic integration specs to Backend Engineer as a scoped issue.

**Vendor and SLA Review (weekly):**

- Review MCAE production against SLA targets (lead time per size tier, reject rate).
- Check DHL and Zásilkovna delivery performance.
- If any metric is breaching the agreed threshold, create an escalation issue and flag the CEO.

**SOP Maintenance:**

- After any process change, update the canonical SOP document in Drive within 24 hours.
- Increment the version number and leave a changelog comment in the Doc.

## 7. Fact Extraction

- Extract durable facts from vendor calls, email threads, or decisions into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with a summary of what was completed and what is pending.

## 8. Exit

- Comment on any `in_progress` issue before exiting — include current status, next action, and any blocking dependency.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include the `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never release an order to MCAE without a confirmed Stripe payment status check.
- Never commit to MCAE pricing or SLA changes without CEO approval.
