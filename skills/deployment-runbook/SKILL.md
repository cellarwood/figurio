---
name: deployment-runbook
description: >
  Figurio deployment procedure for all services: Docker multi-stage build,
  push to lukekelle00 on Docker Hub, K8s rollout on microk8s-local via Helm,
  Traefik ingress configuration, and rollback steps for failed deployments.
allowed-tools:
  - Bash
  - Read
  - Write
  - Grep
metadata:
  paperclip:
    tags:
      - devops
      - deployment
      - infrastructure
---

# Deployment Runbook

## When to Use

Use this runbook when deploying any Figurio service — backend (FastAPI), frontend
(React), ML pipeline, or supporting services — to the microk8s-local K8s cluster.

---

## 1. Docker Multi-Stage Build

All Figurio images use multi-stage builds to minimize final image size.

```bash
# Build from the repo root (context must include the service directory)
docker build \
  --target production \
  -t lukekelle00/<service>:<git-sha> \
  -t lukekelle00/<service>:latest \
  -f services/<service>/Dockerfile \
  .
```

Services: `figurio-api`, `figurio-frontend`, `figurio-ml-pipeline`

Build targets:
- `builder` — dependency install + compile step
- `production` — minimal runtime image (no dev deps, no build tools)

Always tag with the short Git SHA (`git rev-parse --short HEAD`) in addition to `latest`.

---

## 2. Push to Docker Hub

Registry: `lukekelle00` on Docker Hub.

```bash
docker push lukekelle00/<service>:<git-sha>
docker push lukekelle00/<service>:latest
```

Ensure `docker login` is active for `lukekelle00` before pushing. In CI
(GitHub Actions) this uses the `DOCKERHUB_TOKEN` secret stored in the
`cellarwood/figurio` repository settings.

---

## 3. K8s Rollout on microk8s-local

Figurio services are deployed via Helm charts located at `infra/helm/<service>/`.

```bash
# Set context to microk8s-local
kubectl config use-context microk8s

# Helm upgrade (creates if not exists)
helm upgrade --install <service> infra/helm/<service>/ \
  --namespace figurio \
  --set image.tag=<git-sha> \
  --values infra/helm/<service>/values.yaml \
  --wait \
  --timeout 5m
```

Verify the rollout:

```bash
kubectl rollout status deployment/<service> -n figurio
kubectl get pods -n figurio -l app=<service>
```

---

## 4. Traefik Ingress Configuration

Figurio uses Traefik (deployed via microk8s addon or Helm) as the ingress controller.

Ingress resources live at `infra/helm/<service>/templates/ingress.yaml`.

Key conventions:
- Host: `api.figurio.cz`, `figurio.cz`, `ml.figurio.cz`
- TLS termination at Traefik using Let's Encrypt (cert-manager or Traefik's ACME)
- Middleware: rate limiting on API routes, redirect HTTP→HTTPS on all routes
- IngressRoute kind (Traefik CRD) preferred over standard Ingress for middleware support

```yaml
# Example IngressRoute snippet
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: figurio-api
  namespace: figurio
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`api.figurio.cz`)
      kind: Rule
      services:
        - name: figurio-api
          port: 8000
  tls:
    certResolver: letsencrypt
```

Apply manually if not managed by Helm:

```bash
kubectl apply -f infra/k8s/ingressroutes/ -n figurio
```

---

## 5. GitHub Actions CI/CD

The pipeline is defined at `.github/workflows/deploy.yml`. On push to `main`:

1. Run tests (pytest, Jest)
2. Docker build + push (using `DOCKERHUB_TOKEN` secret)
3. `helm upgrade --install` against microk8s-local via self-hosted runner
4. Sentry release notification (`sentry-cli releases new`)

To trigger a manual deployment without a push, use the `workflow_dispatch` trigger
in the Actions UI on `cellarwood/figurio`.

---

## 6. Rollback Steps

### Helm rollback (preferred)

```bash
# List Helm release history
helm history <service> -n figurio

# Roll back to previous revision
helm rollback <service> <revision> -n figurio --wait
```

### Image rollback

```bash
# Pin to previous SHA
helm upgrade <service> infra/helm/<service>/ \
  --namespace figurio \
  --set image.tag=<previous-git-sha> \
  --reuse-values \
  --wait
```

### Kubectl rollout undo (emergency)

```bash
kubectl rollout undo deployment/<service> -n figurio
kubectl rollout status deployment/<service> -n figurio
```

After any rollback, file an incident (see `incident-response` skill) and
notify the CTO.

---

## Checklist

- [ ] Tests pass in CI before merge to `main`
- [ ] Image tagged with Git SHA (not just `latest`)
- [ ] `helm upgrade` used `--wait` flag
- [ ] Pod readiness confirmed after rollout
- [ ] Sentry release created for traceability
- [ ] Traefik ingress routes healthy (check Traefik dashboard)
