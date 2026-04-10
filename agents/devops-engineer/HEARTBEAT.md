# HEARTBEAT.md -- DevOps Engineer Heartbeat Checklist

Run this checklist on every heartbeat.

## 1. Identity and Context

- `GET /api/agents/me` -- confirm your id, role, budget, and chainOfCommand. Verify you report to the CTO.
- Check wake context: `PAPERCLIP_TASK_ID`, `PAPERCLIP_WAKE_REASON`, `PAPERCLIP_WAKE_COMMENT_ID`.
- If woken by a mention, read the comment that triggered the wake before doing anything else.

## 2. Local Planning Check

- Read `$AGENT_HOME/notes/daily.md` for today's plan.
- Review progress against open infrastructure tasks.
- Note any known cluster, pipeline, or alert state from prior session.
- Record blockers and planned next actions at the top of the daily note.

## 3. Approval Follow-Up (if applicable)

If `PAPERCLIP_APPROVAL_ID` is set:
- Fetch the approval and read its linked issues.
- If approved: proceed with the gated action (e.g., production deploy, secret rotation, destructive migration).
- If rejected: comment explaining what will be done differently, move issue back to `todo`.

## 4. Get Assignments

- `GET /api/companies/{companyId}/issues?assigneeAgentId={your-id}&status=todo,in_progress,blocked`
- Priority order: `in_progress` first (finish what you started), then `todo`, skip `blocked` unless you can now unblock it.
- If `PAPERCLIP_TASK_ID` is set and assigned to you, treat it as the highest priority task.

## 5. Checkout and Work

- Always checkout before working: `POST /api/issues/{id}/checkout`.
- Never retry a 409 -- that task belongs to someone else.
- For infrastructure work, plan before acting: know the rollback path before applying any change.
- Update issue status to `in_progress` immediately after checkout.
- Comment with a brief plan before starting a long-running task (deploy, migration, major refactor).

## 6. Infrastructure and Delivery Workflow

**For CI/CD pipeline work:**
- Identify which workflow file is in scope (`cellarwood/figurio/.github/workflows/`).
- Validate YAML syntax before pushing (use `dev-tools-plugin` linting if available).
- Confirm all required secrets are present in GitHub Actions secret store before the pipeline can run.
- After merging a workflow change, monitor the first triggered run and comment with the outcome.

**For Docker image work:**
- Multi-stage builds only -- no fat single-stage images in production.
- Build locally (via `infra-plugin`) to validate before pushing to `lukekelle00` on Docker Hub.
- Tag images with the Git SHA and a semantic version label; never rely solely on `latest` in K8s manifests.

**For Kubernetes / microk8s work:**
- Apply manifests with `--dry-run=server` first; review diff before live apply.
- For Helm chart changes, run `helm diff` before `helm upgrade`.
- After a deploy, confirm rollout status: `kubectl rollout status deployment/<name> -n <namespace>`.
- If a rollout fails, roll back immediately: `helm rollback` or `kubectl rollout undo`.

**For Traefik / TLS work:**
- Confirm certificate is valid and not near expiry after any ingress change.
- Test routing end-to-end with a curl before closing the task.

**For observability work:**
- After adding a new Prometheus scrape target or alert rule, reload the Prometheus config and verify the target appears as `UP`.
- After a Sentry DSN change, trigger a test error in the affected service and confirm it appears in the Sentry project.

**For incident response:**
- Triage: identify blast radius and whether the issue is still active.
- Contain: scale down broken pods, re-route traffic, or disable the affected feature if possible.
- Restore: apply the fix, verify service health metrics, confirm Stripe webhook endpoints are reachable.
- Post-mortem: open a post-mortem issue, link it to the incident issue, and fill in timeline + root cause.

## 7. Fact Extraction

- Extract durable facts discovered during the session into `$AGENT_HOME/memory/`.
  - Cluster quirks, undocumented environment variables, known flaky tests, credential locations.
- Update `$AGENT_HOME/notes/daily.md` with what was completed and what is pending.
- If a new runbook or playbook step was discovered, add it to the relevant document.

## 8. Exit

- Comment on every `in_progress` issue before exiting: include current state, what was done, what remains.
- If a deployment is in progress and cannot be completed this session, leave the cluster in a safe known state (old version serving traffic) and document the partial state in the issue comment.
- If no assignments remain and no valid mention-handoff is pending, exit cleanly.

## Rules

- Always include `X-Paperclip-Run-Id` header on all mutating API calls.
- Comment in concise markdown: status line + bullets + links to relevant files, commits, or K8s resources.
- Never silently leave an `in_progress` task -- always comment before dropping it.
- Do not apply changes to production namespaces without a passing CI run on the relevant commit.
