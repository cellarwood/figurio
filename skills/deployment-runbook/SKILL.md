---
name: deployment-runbook
description: >
  Step-by-step deployment procedure for Figurio services to microk8s — Docker
  multi-stage builds, push to Docker Hub (lukekelle00), Helm chart upgrades,
  Traefik ingress routing, and TLS certificate management. Use this skill
  whenever deploying or redeploying any Figurio service to the Kubernetes cluster.
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
metadata:
  paperclip:
    tags:
      - engineering
      - devops
      - deployment
---

# Deployment Runbook

## When to Use

Use this skill when deploying a Figurio service — new release, hotfix, config change, or infrastructure update. Covers the full pipeline from image build through live traffic.

## Prerequisites

- Docker daemon running locally
- `kubectl` configured against the microk8s cluster (`microk8s kubectl` or aliased)
- `helm` v3 available
- Docker Hub credentials active for `lukekelle00`
- GitHub Actions pipeline is the preferred path; this runbook covers both CI and manual procedures

## Step 1 — Build the Docker Image

Figurio services use multi-stage Docker builds. The `Dockerfile` must have a `builder` stage and a lean final stage.

```bash
# From the service root
docker build \
  --target production \
  --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --build-arg GIT_SHA=$(git rev-parse --short HEAD) \
  -t lukekelle00/<service-name>:<git-sha> \
  -t lukekelle00/<service-name>:latest \
  .
```

- Always tag with the Git SHA — `latest` alone is not acceptable for production deploys.
- Verify the final image size is reasonable; if the production stage exceeds ~200 MB, investigate layer bloat.

## Step 2 — Push to Docker Hub

```bash
docker push lukekelle00/<service-name>:<git-sha>
docker push lukekelle00/<service-name>:latest
```

Confirm the push completed by checking Docker Hub: `https://hub.docker.com/r/lukekelle00/<service-name>/tags`

## Step 3 — Update Helm Values

Helm charts live at `helm/<service-name>/`. The image tag must be pinned to the SHA, never a mutable tag.

Edit `helm/<service-name>/values.yaml` (or the environment override):

```yaml
image:
  repository: lukekelle00/<service-name>
  tag: "<git-sha>"   # pin to exact SHA
  pullPolicy: IfNotPresent
```

Commit the values change to the repository before proceeding.

## Step 4 — Deploy with Helm

```bash
helm upgrade --install <release-name> ./helm/<service-name>/ \
  --namespace figurio \
  --values helm/<service-name>/values.yaml \
  --atomic \
  --timeout 3m \
  --wait
```

- `--atomic` rolls back automatically on failure.
- `--wait` blocks until all pods are ready or the timeout fires.
- Use `--dry-run` first when making chart structural changes.

## Step 5 — Verify Rollout

```bash
kubectl rollout status deployment/<service-name> -n figurio
kubectl get pods -n figurio -l app=<service-name>
kubectl logs -n figurio -l app=<service-name> --tail=50
```

Healthy state: all pods `Running`, no crash-loops, no OOMKilled events.

## Step 6 — Traefik Ingress Check

Traefik is the ingress controller. After a deploy, confirm routing is intact:

```bash
kubectl get ingressroute -n figurio
kubectl describe ingressroute <service-name>-route -n figurio
```

Expected: `entryPoints` includes `websecure`, `tls` block references the correct certificate resolver, routes match the expected host rules (e.g., `api.figurio.com`).

If a new IngressRoute was added, confirm Traefik picked it up:

```bash
kubectl logs -n kube-system -l app.kubernetes.io/name=traefik --tail=30
```

## Step 7 — TLS Certificate Verification

Figurio uses Traefik's ACME resolver. After ingress changes:

```bash
# Check cert state
kubectl get certificate -n figurio
kubectl describe certificate <service-name>-tls -n figurio
```

Expected: `Ready = True`. If `False`, check the cert-manager / Traefik ACME logs for DNS-01 or HTTP-01 challenge failures.

## Step 8 — Smoke Test

Run the service-level smoke test against the live endpoint:

```bash
curl -sf https://api.figurio.com/health | jq .
```

Expected response: `{"status": "ok"}`. For checkout-critical services, also verify Stripe webhook endpoint reachability.

## GitHub Actions Pipeline

The preferred deployment path is the `deploy.yml` workflow in `.github/workflows/`. It executes Steps 1-8 automatically on merge to `main`. Manual deploys should only occur for hotfixes or when the pipeline is broken.

To trigger a manual pipeline run:

```bash
gh workflow run deploy.yml --ref main -f service=<service-name>
```

## Rollback

If a deployment fails and `--atomic` did not catch it (e.g., app-level regression):

```bash
helm rollback <release-name> -n figurio
```

Then investigate via Sentry before re-deploying. See the `incident-response` skill for full rollback procedures.

## Anti-patterns

- Do NOT push only `latest` without a SHA tag — rollback becomes impossible.
- Do NOT edit running pods directly with `kubectl edit` — all changes go through Helm.
- Do NOT bypass the `--atomic` flag — silent broken deploys are harder to recover from.
- Do NOT deploy on Friday afternoon without on-call coverage.
