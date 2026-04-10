# HEARTBEAT.md -- ML/AI Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan at `$AGENT_HOME/notes/plan.md`.
- Review progress against yesterday's recorded next actions.
- Identify blockers and resolve or escalate them before picking up new work.
- Record updates to the plan before moving on.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Review the approval and its linked issues.
- Close resolved issues or comment on what remains open.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Prioritize: `in_progress` first, then `todo`. Skip `blocked` unless you can concretely unblock it now.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, prioritize that task.
- Also check the `ai-pipeline` project board for unassigned issues that fall in your domain.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- Do the work. Update status and comment when done.

## 6. Pipeline-Specific Workflow

### Text-to-3D Generation
- For new API evaluations: run benchmark suite against Meshy, Tripo3D, and Luma Genie using the standard prompt set in `$AGENT_HOME/evals/prompts.txt`.
- Record manifold rate, wall-thickness pass rate, average generation time, and cost-per-model in `$AGENT_HOME/evals/results/`.
- Commit evaluation summary as a comment on the relevant issue with a recommendation.

### Mesh Repair Pipeline
- For new failure classes surfaced by QA technicians: reproduce the failure, write a Blender Python repair script, validate with NetFabb, update `$AGENT_HOME/repair/scripts/`.
- Track repair success rate per failure class in PostgreSQL (`ai_pipeline.repair_metrics`).

### Content Moderation
- For prompt rejection false-positive reports: review the prompt, update the classifier threshold or blocklist, re-run the eval set, confirm no regression before deploying.

### QA Review Queue
- Check the queue daily: `GET /api/ai-pipeline/qa-queue?status=pending`.
- If items have been pending for more than 24 hours without technician action, comment on the linked issue and notify the COO.

### Preview Rendering Service
- Monitor rendering job failure rate; investigate any sustained failure rate above 2%.

## 7. Fact Extraction

- Extract durable facts (API pricing changes, new model versions, rejection reason patterns) into memory.
- Update daily notes at `$AGENT_HOME/notes/{date}.md`.

## 8. Exit

- Comment on any in-progress work before exiting: current state, what was done, next action and owner.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never call an external text-to-3D API for a prompt that has not passed content moderation.
- Do not store raw mesh files in the Git repository; use GCS object storage.
