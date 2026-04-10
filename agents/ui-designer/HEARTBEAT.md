# HEARTBEAT.md -- UI Designer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan in `$AGENT_HOME/notes/plan.md`.
- Review which design tasks are in progress, which specs have been delivered, and which are waiting for Frontend Engineer acknowledgment.
- Resolve any blockers you can resolve now. Record updates in your daily notes.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can now provide the missing input.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Attach the deliverable (spec doc, token table, mockup description, or media-plugin output) as a comment before closing.
- Update status and comment when done.

## 6. Design Workflow

**For brand identity tasks:**
- Establish color palette tokens first (primary, secondary, neutral, semantic: success/error/warning).
- Define typography scale (typeface choices, size scale, weight and line-height pairings).
- Produce logo explorations with media-plugin; select a direction and document the final lockup rules.
- Write brand guidelines section covering logo clearspace, color usage, type hierarchy, imagery tone.

**For design system tasks:**
- Map every design token to a Tailwind config key. Document the mapping explicitly so the Frontend Engineer can copy it directly.
- Specify each component with: purpose, variants, states (default/hover/focus/disabled/error), spacing (internal padding, gap, margin conventions), and motion behavior if animated.
- Reference GSAP easing names and duration values when specifying transitions.

**For mockup and asset tasks:**
- Use media-plugin to generate or render visual concepts.
- Attach generated asset descriptions or rendered outputs to the issue comment.
- Document prompt parameters used so assets can be regenerated consistently.

**For social media template tasks:**
- Define fixed canvas sizes (Instagram square 1080x1080, story 1080x1920, Facebook post 1200x630).
- Specify text zones, image zones, logo placement, and safe areas.
- Produce template mockups with media-plugin.

**Handoff to Frontend Engineer:**
- When a component spec or token set is ready, create or update the handoff issue with the spec attached and explicitly @mention the Frontend Engineer in the comment.
- Include: token values, Tailwind config snippet, component variant table, motion spec if applicable.

## 7. Fact Extraction

- Extract durable decisions (color hex values, typeface names, brand rules, component variant counts) into `$AGENT_HOME/memory/`.
- Update `$AGENT_HOME/notes/plan.md` with tomorrow's priorities.

## 8. Exit

- Comment on any in_progress work before exiting, summarizing what was completed and what remains.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Every closed design task must have a concrete deliverable in its final comment — no empty closes.
