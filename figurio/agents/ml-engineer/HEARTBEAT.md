# Heartbeat — ML Engineer

This document describes the ML Engineer's recurring work rhythm: how work is organised day-to-day, week-to-week, and over longer horizons.

---

## Daily

- **Check pipeline health.** Review any automated alerts or error logs from the previous 24 hours. Generation failures, mesh repair failures, and validation anomalies all warrant investigation before the day's other work begins.
- **Review QA queue.** Check whether any meshes are blocked in the human QA stage waiting on a pipeline fix or re-generation. Unblock these as the highest priority.
- **Monitor provider status.** Briefly check uptime pages or dashboards for active text-to-3D providers. If a provider has degraded performance, note it and assess whether to route traffic to a fallback.
- **Check experiment runs.** If any model evaluation or benchmarking jobs are running, review their progress and output.

---

## Weekly

- **Pipeline quality review.** Pull the week's key metrics: print success rate, customer approval rate on first render, mesh repair time (p50/p95), generation cost per figurine. Note trends. Flag regressions to the CTO in the weekly sync.
- **Benchmark run (if pipeline changed).** Any code changes that touch generation, repair, or validation logic trigger a full benchmark run against the reference prompt suite. Results are logged in the experiment log before the change ships.
- **Experiment iteration.** Advance the current active experiment by one meaningful step — whether that is evaluating a new provider, tuning a repair parameter, testing a new validation threshold, or updating the moderation blocklist.
- **Dependency check.** Quickly scan for new releases of core dependencies (trimesh, pymeshlab, provider SDK packages). Flag breaking changes. Pin versions explicitly; do not accept unreviewed floating upgrades.
- **CTO sync.** 1:1 with the CTO. Bring: current metric summary, experiment status, any blockers, and one item of SOTA news relevant to the pipeline.

---

## Monthly

- **Full benchmark report.** Produce a structured comparison of pipeline performance vs. the previous month. Include: per-provider quality scores, repair success rates, cost trends, and customer approval rates. Share with the CTO.
- **Moderation report.** Review rejected prompt statistics for the month. Assess blocklist coverage, false positive rate, and whether any new IP/content categories need to be added. Adjust classifier thresholds if warranted.
- **Provider re-evaluation.** Revisit the active provider shortlist. New model versions are released frequently in the text-to-3D space. Run structured benchmark comparisons against any providers that have shipped significant updates since the last evaluation.
- **Dependency and security audit.** Review the full dependency tree for known CVEs. Update pinned versions with a tested upgrade. Document the process.
- **Experiment log review.** Read back through the month's experiment log. Summarise what was learned, what decisions were made, and what experiments are queued for next month. Share a written summary with the CTO.

---

## Ongoing / As-needed

- **SOTA monitoring.** Follow arxiv, Hugging Face papers, and provider release notes for advances in text-to-3D generation, mesh repair, and printability analysis. If a new technique warrants evaluation, add it to the experiment backlog with a brief rationale.
- **Print failure post-mortems.** When a print failure is attributed to a pipeline mesh quality issue, conduct a root-cause analysis: which validation check failed to catch it, what repair step should have caught it, what threshold needs adjusting. Document findings and implement fixes.
- **Blender version management.** Headless Blender upgrades require a full rendering regression test before deployment. Never upgrade Blender in production without completing this test.
- **Provider adapter maintenance.** When a provider changes their API, update the adapter and run the integration test suite before re-enabling that provider in production.
- **Incident response.** If a pipeline stage goes down (generation API outage, repair tool crash, rendering failure), diagnose, apply a workaround or fallback, and write a brief incident note for the CTO within 2 hours of detection.
