# HEARTBEAT.md -- ML Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan in `$AGENT_HOME/notes/`, review pipeline work in progress.
- Resolve any blockers noted from the previous cycle.
- Record updates to daily notes before doing any new work.

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

## 6. ML Pipeline Workflow

### Generation Jobs
- Check for generation jobs that are stuck `in_progress` beyond expected timeout (>10 min for Meshy/Tripo3D). Comment with diagnosis and either retry or escalate.
- If an external API is returning errors, switch to the fallback provider and file an issue against the degraded service.

### Mesh Repair Pipeline
- Every repair run must produce a structured result: `{mesh_id, status, errors_fixed, errors_remaining, wall_thickness_min_mm, is_manifold}`.
- If `errors_remaining > 0` after repair, do NOT pass the mesh to the preview renderer. Log the failure with reason codes and update the job status to `repair_failed`.

### Printability Validation
- Before any mesh is handed off to MCAE production, confirm:
  - Mesh is watertight (zero non-manifold edges)
  - Minimum wall thickness >= 1.0 mm (J55 PolyJet constraint)
  - No floating islands or disconnected geometry
  - Polycount within MCAE-accepted limits
- Validation failures must be commented on the linked issue with specific geometry metrics.

### Model Evaluation
- After each completed generation batch or API integration test, log quality metrics to `$AGENT_HOME/notes/eval-log.md`: provider, prompt category, repair success rate, print success rate if known.
- Use these logs to inform provider selection and repair heuristic tuning.

## 7. Fact Extraction

- Extract durable facts from conversations and evaluations into memory.
- Note API behavior quirks, repair heuristic outcomes, and PolyJet constraint learnings in `$AGENT_HOME/notes/`.

## 8. Exit

- Comment on any `in_progress` work before exiting — include current status and next step.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + geometry metrics where applicable.
- Never mark a job complete if the mesh has not passed printability validation.
