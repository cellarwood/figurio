# HEARTBEAT.md -- ML/AI Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, chainOfCommand.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.

## 2. Local Planning Check

- Read today's plan in `$AGENT_HOME/notes/`. Review what was in progress, what is blocked, and what has shipped.
- If yesterday's pipeline run produced failures or cost anomalies, note them before picking up new work.
- Resolve any blockers you can address immediately (e.g., switch degraded API provider, patch known repair heuristic).

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

## 6. ML Pipeline Workflow

### Text-to-3D Integration Work
- Confirm the target provider (Meshy, Tripo3D, Luma Genie, or CSM) and its current API status before starting.
- Test with a minimal prompt before running full batches. Log the raw API response for debugging.
- If an API response changes shape, update the integration layer and version the schema.

### Mesh Repair Pipeline Work
- Run Blender repair scripts in headless mode (`blender --background --python`).
- After repair, always run the printability validator before marking a mesh as production-ready.
- Log repair outcomes: which heuristics fired, wall thickness minimums found, manifold errors resolved.

### Printability Validation
- Check: manifold geometry (zero holes), wall thickness >= J55 minimum (~0.5 mm solid), no floating islands, color map present and within gamut.
- A mesh that fails validation must not be forwarded to MCAE. Mark it failed, log the reason, and trigger a retry or escalation.

### Benchmarking and Evaluation
- Run evaluations on a fixed prompt set so comparisons are apples-to-apples.
- Record per-API metrics: generation time, cost per mesh, printability pass rate, subjective quality score.
- Commit evaluation results to `$AGENT_HOME/evals/` with a dated filename.
- Summarize findings and post to the CTO when a benchmark round completes.

### Custom PyTorch Work
- Scope custom model work narrowly: only where API gaps are confirmed and documented.
- Track training runs with experiment IDs. Log hyperparameters, dataset version, and validation metrics.

## 7. Fact Extraction

- Extract durable facts from conversations into memory: API quirks, repair heuristics that work, printability thresholds confirmed with MCAE, cost-per-mesh baselines.
- Update daily notes in `$AGENT_HOME/notes/YYYY-MM-DD.md`.

## 8. Exit

- Comment on any in_progress work before exiting: what was done, what is next, any risks.
- If no assignments and no valid mention-handoff, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on mutating API calls.
- Comment in concise markdown: status line + bullets + links.
- Never forward a mesh to production that has not passed the printability validator.
- When switching AI providers due to degradation, document the reason in the task comment.
