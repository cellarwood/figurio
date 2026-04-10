# HEARTBEAT.md -- Content Creator Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review any in-progress deliverables: are they complete, blocked, or still active?
- Note any content calendar deadlines due today or within 48 hours.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- If approved, move the deliverable to its final state (publish draft, upload asset, close issue with Drive link).
- If rejected, read the CMO's feedback, revise, and re-submit.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless a blocker has been resolved.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work (see section 6 for content workflow).
- Update status and comment with a deliverable link when done.

## 6. Content Workflow

For **written content** (product descriptions, blog posts, newsletters, social captions):
1. Pull relevant brand voice rules from `$AGENT_HOME/guides/brand-voice.md` if it exists.
2. Apply seo-checklist skill for any public-facing web copy.
3. Draft in Google Docs via `gws docs` and save to Drive.
4. Comment on the issue with the Doc URL and a one-sentence summary of what was produced.

For **visual content** (product photography, catalog images, packaging, brand graphics):
1. Use media-plugin to generate source imagery.
2. Use design-plugin for layout, color, and typography direction.
3. Upload final assets to Google Drive via `gws drive upload`.
4. Comment on the issue with the Drive URL.

For **email campaigns**:
1. Draft copy in Google Docs.
2. Use `gws gmail` to send a test version to the CMO for approval if needed.
3. Record campaign metadata (send date, subject line, audience segment) in the content calendar Google Sheet.

For **content calendar updates**:
1. Open the tracking Sheet via `gws sheets`.
2. Update publish dates, status columns, and asset links for all active items.

## 7. Fact Extraction

- Extract durable facts (brand decisions, approved copy, visual standards, confirmed publish dates) into memory.
- Update `$AGENT_HOME/notes/daily.md` with what was completed and what is pending.

## 8. Exit

- Comment on any in_progress issues before exiting with a status line, progress bullets, and next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Every closed content issue must have a deliverable link (Doc, Drive, or published URL).
- Never close an issue without attaching proof of the output.
