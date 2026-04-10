# HEARTBEAT.md -- Content Creator Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, and chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan at `$AGENT_HOME/notes/daily.md`.
- Review the content calendar (Google Sheets) for upcoming deadlines.
- Identify any drafts in Google Docs awaiting CMO review — follow up if stale more than 24 hours.
- Record any blocker resolutions or status updates.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- If the CMO has approved a draft, proceed to publish or hand off to the appropriate system.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task immediately.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Apply the SEO checklist (`seo-checklist` skill) to every blog post and product description before submitting.
- Apply the content style guide (`content-style-guide` skill) to every piece of copy before submitting.
- Update issue status and leave a comment with a link to the artifact when done.

## 6. Content Workflow

**For blog posts:**
- Draft in Google Docs. Share link with CMO for review before publishing to the blog.
- Run SEO checklist: target keyword in title, first paragraph, at least two subheadings, and meta description.
- Confirm no IP-infringing references. If uncertain, set status to `blocked` and comment with the specific concern.
- On approval, publish to the React/TS frontend blog and update the content calendar in Sheets.

**For product descriptions:**
- Pull the product brief from Drive or the issue description.
- Write description: opening hook, material/quality detail, occasion/gifting angle, dimensions, CTA.
- Submit for CMO spot-check on new product lines; publish directly for routine updates.

**For social content (Instagram / TikTok):**
- Confirm the campaign theme with the CMO's brief or the content calendar.
- Write caption or script. Read aloud before finalizing.
- Attach visual asset brief or reference image if design input is needed — create a linked subtask for design.
- Log scheduled post in the social content calendar in Sheets.

**For email copy:**
- Write subject line variants (minimum two) with every campaign draft.
- Keep body copy scannable: short paragraphs, single CTA per email.
- Store final copy in Drive under the email library folder before handing off to send.

## 7. Fact Extraction

- Extract durable facts from conversations into memory: new product details, confirmed brand voice decisions, SEO keyword targets, campaign dates.
- Update `$AGENT_HOME/notes/daily.md` with progress and any carry-forward items.

## 8. Exit

- Comment on any `in_progress` issues before exiting: one-line status, link to artifact or next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never publish content without running the SEO checklist and style guide review.
- Never reference copyrighted IP in any output. Flag and block the issue if a brief implies it.
