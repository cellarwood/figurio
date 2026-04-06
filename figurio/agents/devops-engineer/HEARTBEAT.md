# Heartbeat

This document defines the standard operating rhythm for the DevOps Engineer. Run through these steps at the start of each working session to establish situational awareness before taking on any new tasks.

## Daily Heartbeat Checklist

### 1. Cluster Health

- Check that all nodes in the GKE cluster are in `Ready` state
- Review pod status across all three namespaces (`figurio-dev`, `figurio-staging`, `figurio-prod`) for any pods in `CrashLoopBackOff`, `OOMKilled`, `Pending`, or `Error` states
- Check persistent volume claims — confirm all PVCs are `Bound`, especially the PostgreSQL StatefulSet PVC in prod
- Review HorizontalPodAutoscaler status — confirm no service is pegged at max replicas unexpectedly

```bash
kubectl get nodes
kubectl get pods -n figurio-prod
kubectl get pods -n figurio-staging
kubectl get pvc -n figurio-prod
kubectl get hpa -n figurio-prod
```

### 2. Review Failed or Degraded Deployments

- Check GitHub Actions for any failed workflow runs on `main` or open PRs
- Review Helm release history in staging and prod for any failed releases (`STATUS: failed`)
- Confirm the latest `main` build pushed a Docker image to Docker Hub successfully
- If a rollback was triggered (automatic or manual), confirm the previous release is stable and open a post-mortem issue

```bash
helm list -n figurio-prod
helm history <release-name> -n figurio-prod
```

### 3. Check Monitoring Alerts

- Open Grafana and review the main Figurio dashboard for anomalies in the past 24 hours:
  - API error rate (5xx responses)
  - API p99 latency
  - Pod restart counts
  - PostgreSQL connection pool saturation
  - Memory and CPU usage per namespace
- Review Prometheus alert manager for any firing or pending alerts
- Check Sentry for new error spikes in `services/api` or `apps/web` since last session
- Check Loki for any unusual log patterns (e.g., repeated stack traces, auth failures)

### 4. Certificate and Ingress Health

- Verify that cert-manager certificates are not approaching expiry (flag anything under 14 days)
- Confirm Traefik is routing correctly to all services — check Traefik dashboard or IngressRoute status

```bash
kubectl get certificates -n figurio-prod
kubectl get ingressroutes -n figurio-prod
```

### 5. Security Posture Scan (Weekly, every Monday)

- Review any Dependabot or GitHub security alerts in the `Kelle00-AI` org
- Check for outdated base images in Dockerfiles (Alpine, distroless) — flag anything more than 2 minor versions behind
- Confirm no new Kubernetes Secrets have been committed to the repo in plaintext (run a quick grep on recent commits)
- Review IAM service account permissions in GCP for least-privilege drift

## On-Call Response Priorities

| Severity | Condition | Response |
|----------|-----------|----------|
| P0 | `figurio-prod` pods down, store unreachable | Immediate — rollback or hotfix, notify CTO |
| P1 | `figurio-prod` degraded (elevated errors, high latency) | Within 30 min — investigate and mitigate |
| P2 | `figurio-staging` broken, blocking deployments | Within 2 hours |
| P3 | `figurio-dev` issues, non-critical alerts | Best effort same day |

## End-of-Session Note

Before ending a session, confirm:

- Any manual changes applied to the cluster are captured in a follow-up PR or issue
- No secrets were logged or committed
- Grafana dashboards reflect the current state of the system
