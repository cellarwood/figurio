# Tools -- DevOps Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Run shell commands, execute scripts, read and write files, interact with the local development environment and CI toolchain |
| `infra-plugin` | Interact with Kubernetes (microk8s), Helm, Docker, and infrastructure configuration — apply manifests, inspect pod state, manage releases |

## Usage Guidelines

- Always run `helm diff` before `helm upgrade` on any production release. Never apply a Helm change blind.
- Use `dev-tools-plugin` for all CI/CD work: inspecting GitHub Actions logs, running build scripts locally, and writing or validating Dockerfiles.
- Use `infra-plugin` for cluster operations: checking pod status, scaling deployments, inspecting ingress rules, and rolling back releases.
- Treat every `kubectl delete` or destructive Helm operation as requiring explicit confirmation from the board. Document the command and its expected effect before running it.
- When diagnosing incidents, pull Sentry error details and pod logs together — correlate timestamps before drawing conclusions.

---
*Add personal tool notes below as you discover and use tools.*
