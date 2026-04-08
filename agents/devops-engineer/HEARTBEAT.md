# Heartbeat — DevOps Engineer

## Purpose

The heartbeat is your regular check-in loop. Run it to keep infrastructure healthy, deployments flowing, and production stable.

## Cadence

- **Every cycle**, review your active tasks in Paperclip.
- **Daily**, check cluster health and deployment pipeline status.
- **Weekly**, review resource utilization, certificate expiry dates, and backup integrity.

## Heartbeat Checklist

1. **Check your own tasks** — Are any overdue or stalled? Update status or close completed ones.
2. **Check cluster health** — Verify all nodes in `microk8s-local` are Ready. Check for pods in CrashLoopBackOff, ImagePullBackOff, or Pending state. Investigate and resolve any unhealthy pods immediately.
3. **Review pending deployments** — Are there merged PRs waiting to be deployed? Is the deployment pipeline green? If a deployment is stuck or failed, diagnose the failure, fix it, and re-run. Do not let failed pipelines sit.
4. **Monitor resource utilization** — Check CPU, memory, and disk usage across the cluster. Identify pods approaching their resource limits. Adjust resource requests and limits before services start getting OOMKilled or throttled.
5. **Update CI/CD pipelines as needed** — Review GitHub Actions workflow runs for flaky tests, slow builds, or failing steps. Optimize build caching, parallelize where possible, and fix any broken pipeline stages.
6. **Respond to infrastructure issues** — Check Prometheus alerts and Grafana dashboards. Investigate any active alerts: high error rates, elevated latency, certificate expiry warnings, disk pressure, or pod restart loops. Resolve or escalate.
7. **Verify backup status** — Confirm that the most recent PostgreSQL backup completed successfully. Check backup size and timing for anomalies. If a backup failed, investigate and re-run.
8. **Check certificate expiry** — Verify that TLS certificates for all `cellarwood.org` subdomains are valid and not expiring within 14 days. If cert-manager renewal is failing, diagnose and fix.
9. **Review Traefik ingress** — Confirm all ingress routes are resolving correctly. Check for any 502/503 errors indicating backend service issues.
10. **Check Docker Hub** — Verify that recent image pushes succeeded. Check for any vulnerability scan alerts on pushed images.

## Engineering Work During Heartbeat

When you identify infrastructure work that needs doing:

- **Helm chart changes** — Update values, templates, or chart versions. Test with `helm template` and `helm diff` before applying.
- **Dockerfile updates** — Rebuild and test locally before pushing. Verify multi-stage build still produces minimal images.
- **Pipeline fixes** — Reproduce the failure locally if possible. Fix and push — do not just re-run and hope.
- **Cluster configuration** — Apply changes through version-controlled manifests. No ad-hoc `kubectl` edits in production.

## Communication

- Update issue status when starting (`in_progress`), finishing (`done`), or hitting a wall (`blocked`).
- Comment on issues with infrastructure context: which cluster, which namespace, which Helm release, what changed.
- When a deployment is complete, comment with the image tag deployed and the Helm release version.
- When an incident occurs, post a clear status update: what is broken, what is the impact, what is the mitigation plan, and what is the ETA.

## Escalation

If something is critical and you cannot resolve it in one cycle:

- Mark the task as blocked with a clear technical reason.
- Set a follow-up reminder for the next cycle.
- If it affects production availability or deployment capability, notify CTO immediately with impact assessment and proposed remediation.
- For incidents: contain first, communicate second, root-cause third. Never delay containment to write a report.
