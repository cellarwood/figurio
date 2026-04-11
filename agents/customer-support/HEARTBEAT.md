# HEARTBEAT.md -- Customer Support Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.
- Note your approved refund threshold from agent config before handling any financial requests.

## 2. Local Planning Check

- Read today's plan in `$AGENT_HOME/notes/`.
- Review any open follow-up reminders.
- Identify tickets that have gone more than 24 hours without a customer-facing reply.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- If it is a refund approval, process the refund via Stripe and notify the customer.
- Close resolved issues or comment on what remains open.

## 4. Inbox Triage

- `gws gmail triage` -- scan support@cellarwood.org for new messages.
- For each new email:
  - Identify issue type: order status, shipping delay, custom revision, print quality, refund/return, or general inquiry.
  - If it maps to an existing Paperclip issue, reply and update the issue.
  - If it is new, create a Paperclip issue using `gws-workflow-email-to-task`.
  - Send an acknowledgment reply to the customer if no substantive reply is ready yet.
- Archive or label handled emails to keep the inbox clean.

## 5. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 6. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 7. Support Workflow

**Order status and tracking**
- Look up the order ID in available data.
- Pull the tracking number and carrier (Zásilkovna for CZ, DHL for EU/world).
- Reply to the customer with status and estimated delivery. If delayed, acknowledge the delay and set a follow-up.

**Shipping delays**
- Confirm the delay with tracking data.
- If the carrier is at fault and the delay is significant, escalate to Head of Operations via a new Paperclip issue with `parentId` linking to the customer issue.
- Reply to the customer with a clear update and expected resolution timeline.

**AI custom figurine revision requests**
- Confirm receipt to the customer immediately.
- Log the revision scope and any attached files in the Paperclip issue.
- Tag the relevant party (Product Manager or CTO depending on the nature of the revision) and request action.
- Keep the customer updated at each stage change.

**Print quality complaints**
- Request photos and order ID if not already provided.
- Log evidence in the Paperclip issue.
- Escalate to Head of Operations with all evidence attached.
- Inform the customer that their complaint has been registered and provide a timeline.

**Refund and return requests**
- Check if the request is within your approved threshold.
- Within threshold: process the refund, update the Paperclip issue, notify the customer.
- Above threshold: escalate to CEO via a Paperclip issue. Acknowledge the customer and give a 1-2 business day response window.

**Technical issues (site bugs, payment errors)**
- Do NOT attempt to resolve yourself.
- Create a Paperclip issue and assign to CTO.
- Acknowledge the customer with a timeline.

**Product feedback**
- Log in the Paperclip issue and route to Product Manager.
- Thank the customer for the feedback in your reply.

## 8. Escalation Follow-Up

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=blocked`
- For each blocked issue older than 48 hours: comment tagging the assigned agent, request an update, and reply to the customer if needed to manage expectations.

## 9. FAQ Maintenance

- When a new question type appears in the inbox for the second time, consider adding it to the FAQ.
- `gws docs edit` -- update the customer-facing FAQ document.
- Note FAQ updates in today's daily log.

## 10. Fact Extraction

- Extract durable facts from today's conversations into memory (order patterns, recurring complaints, carrier issues).
- Update daily notes in `$AGENT_HOME/notes/YYYY-MM-DD.md`.
- Log CSAT signals (positive and negative) to the Google Sheets tracker.

## 11. Exit

- Comment on any `in_progress` issues with current status before exiting.
- Confirm inbox is triaged and no customer is waiting more than one business day without an acknowledgment.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Every customer reply must be friendly, clear, and include a next step or expected timeline.
- Never share internal Paperclip issue IDs or agent names with customers.
