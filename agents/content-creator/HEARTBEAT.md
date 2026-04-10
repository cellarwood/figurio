# HEARTBEAT.md -- Content Creator Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan in `$AGENT_HOME/notes/daily.md`.
- Review the content calendar in Sheets — identify any publish slots due within 48 hours.
- Resolve any blockers you can unblock. Record updates in daily notes.

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

## 6. Content Production Workflow

**Before drafting any piece of content:**
- Confirm the target keyword or topic brief exists. If not, define it and record it in the SEO keyword tracker in Sheets before writing.
- Run through the SEO checklist (skill: `seo-checklist`) — keyword, meta title, meta description, internal link target.
- Confirm the required visual asset (render, lifestyle shot, or designed graphic) is in scope and tracked.

**For product descriptions:**
- Pull product spec from Drive or the relevant issue.
- Write using the content style guide (skill: `content-style-guide`).
- Include: product name, material/finish, dimensions, what makes it notable, and a call to action.
- Store final copy in a Google Doc, link the Doc in the issue comment.

**For blog posts:**
- Outline first, draft second. Outline goes into a Google Doc for CMO visibility.
- Target 800-1200 words for standard posts, 1500+ for pillar pages.
- Apply all SEO checklist items before marking done.

**For social (Instagram / TikTok):**
- Write caption + hashtag block together.
- For TikTok, write a shot list or script alongside the caption.
- Log the slot as filled in the content calendar Sheets tab.

**For email campaigns:**
- Write subject line, preview text, and body copy together.
- Store in the email copy library Doc in Drive.
- Tag with campaign name and send date in the Sheets tracker.

**Visual asset pipeline:**
- Use media-plugin for AI-generated visuals, screenshots, or mockup production.
- Use design-plugin for brand identity assets, logo usage, and style guide graphics.
- All finalized visual assets go into the shared Drive folder: `Figurio / Assets / [content-type]`.

## 7. Fact Extraction

- Extract durable facts from conversations into memory (style decisions, keyword wins, brand vocabulary additions).
- Update the style guide Doc in Drive if a new voice or vocabulary rule was established this session.
- Update daily notes.

## 8. Exit

- Comment on any in_progress work before exiting — include status, what was produced, and any open dependencies.
- If a visual asset is still pending, comment with a specific description of what is needed and mark the issue blocked.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never mark a content piece done if the visual asset it depends on has not been confirmed.
- Never let a content calendar slot pass without either a finalized asset or a blocked issue with a clear explanation.
