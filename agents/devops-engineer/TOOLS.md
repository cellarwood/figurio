# Tools -- DevOps Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | File system access, shell command execution, code reading and editing, git operations within the repository |
| `infra-plugin` | Kubernetes cluster inspection and management (kubectl), Docker build and push operations, Helm chart install and upgrade, Traefik configuration, infrastructure provisioning |

## Usage Guidelines

- Use `infra-plugin` for all cluster and container operations. Do not shell out to `kubectl` or `docker` via `dev-tools-plugin` when the infra-plugin exposes the same capability directly.
- Always verify a rollout with `kubectl rollout status` after applying a Helm upgrade before marking a deploy complete.
- Tag every Docker image with both the git commit SHA and the semver release tag before pushing to `lukekelle00` on Docker Hub. Never push an untagged or `latest`-only image to production.
- When editing Kubernetes manifests or Helm values, use `dev-tools-plugin` to read the current file first, then apply changes — never write blind.
- Treat all shell commands that mutate cluster state as irreversible until proven otherwise. Prefer `--dry-run=client` or `helm diff` before applying.

---
*Add personal tool notes below as you discover and use tools.*
