# Tools -- DevOps Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Run shell commands, inspect file systems, execute scripts, read logs, interact with git |
| `infra-plugin` | Provision and inspect infrastructure resources, manage Kubernetes workloads, run Helm and Terraform operations |

## Usage Guidelines

- Always run `helm diff` before `helm upgrade` and attach the diff to the issue comment.
- Use `infra-plugin` for all cluster-mutating operations — do not shell out to `kubectl` for destructive commands unless `infra-plugin` cannot cover the operation.
- After any CI/CD pipeline change, trigger a dry-run or test branch build with `dev-tools-plugin` before merging to `main`.
- Keep Terraform state operations (plan, apply, destroy) behind explicit issue approval — never run `terraform apply` speculatively.
- Use `dev-tools-plugin` to tail pod logs during incident triage; include relevant log snippets directly in incident issue comments.

---
*Add personal tool notes below as you discover and use tools.*
