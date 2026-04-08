# HEARTBEAT.md -- Head of Operations Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context
- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check
- Read today's plan, review progress, resolve blockers, record updates.

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

## 6. Operations Pipeline Check
- **Order pipeline status:** Check for orders stuck in any stage (payment captured, file prep, sent to MCAE, printing, shipped, delivered). Flag anything overdue.
- **MCAE turnaround times:** Compare actual print completion dates against target SLAs. If average turnaround is drifting, investigate and escalate.
- **Shipping issues:** Review Zasilkovna and DHL tracking for failed deliveries, stuck parcels, or label creation errors. Resolve or escalate immediately.
- **Vendor negotiations:** Follow up on any pending MCAE quotes, pricing discussions, or SLA renegotiations. Check inbox for MCAE responses.
- **Cost tracking:** Update per-unit cost data if any pricing has changed (MCAE rates, shipping rates, packaging costs).
- **Packaging supply:** Verify branded packaging inventory is sufficient for upcoming order volume.
- **Coordinate with Backend Engineer** on any order management API changes or integration issues.

## 7. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 8. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
