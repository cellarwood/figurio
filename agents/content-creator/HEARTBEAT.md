# HEARTBEAT.md -- Content Creator Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/today.md` (or create it if missing).
- Review the editorial calendar in Google Calendar (`gws calendar agenda`) for publish deadlines today and in the next 3 days.
- Identify any overdue or at-risk deliverables and note them before doing any new work.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can now unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.
- Check for new mentions or CMO comments in Gmail (`gws gmail`) that may affect priorities.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Content Workflow

**For written content (web copy, blog posts, product descriptions):**
1. Confirm keyword target and search intent before writing.
2. Validate the concept is IP-clean before drafting.
3. Draft in Google Docs (`gws docs`); use a consistent naming convention: `[Type] [Topic] [YYYY-MM-DD]`.
4. Apply SEO checklist (`seo-checklist` skill): title tag, meta description, heading hierarchy, internal linking, image alt text.
5. Upload final asset to the correct Google Drive folder.
6. Comment on the issue with the Doc link and a one-paragraph summary of what was written and why.

**For visual assets (renders, lifestyle images, banners):**
1. Confirm dimensions, format, and placement context before generating.
2. Use `media-plugin` for image/video generation; use `design-plugin` for brand-consistent layout and composition.
3. Verify the output is IP-clean before saving.
4. Upload to the content asset library in Google Drive (`gws drive upload`).
5. Comment on the issue with a link to the asset and any usage notes.

**For brand identity work (guidelines, style documents):**
1. Check the canonical brand guidelines document first — do not contradict existing decisions without CMO approval.
2. Draft updates in Google Docs.
3. Surface significant changes (new colors, typeface changes, logo variants) to the CMO before finalizing.

## 7. Fact Extraction

- Extract durable facts from this session into memory: new keywords identified, brand decisions made, assets created and their Drive locations, deadlines confirmed.
- Update `$AGENT_HOME/notes/today.md` with session progress.

## 8. Exit

- Comment on any `in_progress` issue before exiting — include current state and next action.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never publish content to the live site directly — hand off to the backend engineer via an issue with the final asset and placement instructions.
- All content drafts live in Google Drive before they are considered complete.
