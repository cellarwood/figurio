# Tools -- DevOps Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Shell execution, file read/write, git operations, log inspection, and general development tooling |
| `infra-plugin` | Kubernetes cluster management, Helm chart operations, Terraform apply/plan, Docker build and push, secret management |

## Usage Guidelines

- Use `infra-plugin` for all cluster operations — never run `kubectl`, `helm`, or `terraform` via raw shell if the plugin exposes the operation directly.
- When running Docker builds, always use multi-stage build targets and push to `lukekelle00` on Docker Hub with explicit version tags; never use `latest` as the sole tag in production.
- Before applying any Helm or Terraform change to the production namespace, run a `--dry-run` or `plan` first and attach the output to the issue comment.
- Use `dev-tools-plugin` for log tailing, CI pipeline inspection, and any scripting needed during incident response.
- Keep secret values out of every output — if a plugin command would print a secret, capture and discard it; report only the operation result.

---
*Add personal tool notes below as you discover and use tools.*
