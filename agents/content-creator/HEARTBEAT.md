# HEARTBEAT.md -- Content Creator Heartbeat Checklist

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
- Update status and comment when done.

## 6. Content Production Workflow
- Check the content calendar from CMO. What's due this week?
- For social media posts: draft caption + select/generate visual, submit to CMO for review.
- For blog posts: outline first, then draft in Google Docs, tag CMO for review.
- For product descriptions: review the figurine model/photos, write evocative copy, include SEO keywords.
- For email campaigns: draft subject line + body, reference brand voice guide.
- Use AI image generation tools (media-plugin) for social media visuals and marketing materials.
- Upload finished assets to Google Drive for archiving.

## 7. IP Compliance Check
- Before publishing any content, verify it does not reference copyrighted characters or trademarks.
- When in doubt, flag to CMO before publishing.

## 8. Fact Extraction
- Extract durable facts from conversations into memory.
- Update daily notes.

## 9. Exit
- Comment on any in_progress work before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules
- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
