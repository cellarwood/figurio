# HEARTBEAT.md -- Content Creator Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan in `$AGENT_HOME/notes/daily.md`.
- Review in-progress content assets. Note any that are overdue or need a status comment.
- Check the content calendar (Google Sheets) for upcoming deadlines in the next 7 days.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- If content was approved: confirm it was logged to the content calendar and Drive.
- If revisions were requested: update the draft and re-comment with a summary of changes.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Content Production Workflow

For every content task:

1. **Identify the asset type** — product description, blog post, social caption, email, or landing page.
2. **Apply the style guide** (`content-style-guide` skill) before writing. Confirm channel, audience, and goal.
3. **Draft in Google Docs** for long-form (blog, landing page, email sequence). Draft inline for short-form (product description, social captions).
4. **Run the SEO checklist** (`seo-checklist` skill) on any product page, blog post, or landing page before marking done.
5. **Attach media or visuals** using the `media` or `design` plugin if the brief calls for imagery or creative direction.
6. **Log to content calendar** in Google Sheets: asset title, channel, publish date, Drive link, status.
7. **Comment on the issue** with a summary: what was produced, where it lives (Drive link or inline), what review or action is needed.

For social content (Instagram / TikTok):
- Deliver: caption, hashtag set (15-20 tags for Instagram, 5-8 for TikTok), any image or video brief.
- Flag trending audio or cultural timing notes when relevant.

For email campaigns:
- Deliver: subject line (with A/B variant), preview text, body copy, and CTA.
- Note list segment if specified in the brief.

For seasonal content:
- Work at minimum two weeks ahead of the target date.
- If no brief exists for an upcoming seasonal window, flag it to the CMO via a comment on the relevant planning issue.

## 7. Fact Extraction

- Extract durable facts from briefs, feedback, and conversations into `$AGENT_HOME/memory/`.
- Record style decisions, recurring product details, and campaign performance notes for future reference.
- Update `$AGENT_HOME/notes/daily.md` with what was completed and what is pending.

## 8. Exit

- Comment on any `in_progress` work before exiting, even if just a brief status update.
- Confirm the content calendar reflects the day's output.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never publish content externally yourself -- deliver drafts and await CMO sign-off or explicit instruction.
- Every asset gets a Drive link logged to the content calendar before the task is closed.
