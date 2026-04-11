# HEARTBEAT.md -- Content Creator Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's editorial priorities.
- Check the editorial calendar in Google Sheets for upcoming publish dates or campaign deadlines.
- Note any blocked tasks that need a follow-up comment or asset request.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can now unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Content Workflow

**For product descriptions:**
- Pull the product spec (dimensions, material, SKU) from the task or Drive.
- Draft using the story-hook → features → CTA structure from SOUL.md.
- Run the SEO checklist: primary keyword in title, first paragraph, and at least one subheading (for PDP pages). Meta description under 160 characters.
- Upload the finished doc to Drive and link it in a task comment.

**For blog posts:**
- Confirm the target keyword and search intent before writing.
- Follow the structure: punchy headline, hook paragraph, subheadings every 200-300 words, internal links to product pages where natural, CTA at the close.
- Save the draft in Google Docs, share the link in the issue comment, and tag the CMO for review if required.

**For newsletters:**
- Draft in Google Docs first. Subject line, preview text, body copy, and CTA button label all go in the doc.
- When approved, compose and send via `gws gmail` or queue via the office-plugin.
- Log send date and subject line in the newsletter tracking sheet.

**For social copy:**
- Instagram: hook line (pre-break) + body + hashtag block. Keep captions scannable.
- TikTok: write a script with [VISUAL], [VO], and [TEXT OVERLAY] markers so production knows what goes where.
- Store all social copy in the social copy bank doc in Drive.

**If blocked on assets (images, renders, product specs):**
- Comment on the issue with what you need and who owns it.
- Set the issue status to `blocked`.
- Move on to the next `todo` task.

## 7. Fact Extraction

- Extract durable facts (new product details, brand decisions, keyword wins, campaign outcomes) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/daily.md` with what was completed, what is pending, and any decisions made.

## 8. Exit

- Comment on any `in_progress` issues with current status before exiting.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Every published content piece must pass the SEO checklist and the Figurio brand voice check before being marked done.
