# HEARTBEAT.md -- Content Creator Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan in `$AGENT_HOME/notes/daily.md`.
- Review the content calendar in Google Sheets for upcoming publish deadlines.
- Note any pieces that are overdue or at risk; flag to CMO if a deadline will be missed.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- If content was approved: finalize and publish (or hand off for publishing if code deployment is required).
- If changes were requested: update the draft in Google Docs, comment on the issue with a summary of what changed.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Content Workflow

**For new content pieces (blog posts, web copy, email campaigns):**
1. Confirm the brief: topic, target keyword, audience, goal, deadline.
2. Conduct keyword research if not already done; log findings in the SEO Sheets tracker.
3. Write a first draft in Google Docs. Title the doc clearly: `[TYPE] Title -- DRAFT vN`.
4. Run an SEO checklist pass: keyword in H1, meta description written, internal links added.
5. Share the Doc with the CMO (figurio-cmo@cellarwood.org) and comment on the issue requesting review.
6. Mark the issue `blocked` with reason "awaiting CMO review" if no review has happened within 24 hours of sharing.
7. On approval: finalize the doc, upload final assets to Drive under the correct channel folder, and close the issue with the publish URL.

**For social media content:**
1. Write captions and scripts directly in the issue comment or a linked Doc depending on length.
2. If a visual asset is needed, use `design-plugin` to generate it or note the spec for the CMO to commission.
3. Schedule or post via the appropriate channel. Record the post URL in the issue comment before closing.

**For email campaigns:**
1. Confirm the list segment, send date, and goal with the CMO before writing.
2. Write subject line variants (minimum 2) and full body copy in a Google Doc.
3. Include a plain-text version.
4. Flag to CMO for approval before any send is triggered.

## 7. Fact Extraction

- Extract durable facts from conversations into `$AGENT_HOME/memory/`: product details, brand decisions, keyword wins, audience insights.
- Update `$AGENT_HOME/notes/daily.md` with what was completed and what carries forward.

## 8. Exit

- Comment on any in_progress work before exiting with a clear status line and next action.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never publish content that has not passed the SEO checklist (from the `seo-checklist` skill).
- Never send an email campaign without CMO approval.
- All content drafts live in Google Drive before they are published anywhere.
