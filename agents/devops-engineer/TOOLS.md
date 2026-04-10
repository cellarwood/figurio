# Tools -- DevOps Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code and config linting, shell command execution, file system operations, Git operations within the `cellarwood/figurio` repo |
| `infra-plugin` | Docker build and push, Kubernetes manifest apply and status checks, Helm operations, Terraform plan and apply, Traefik config validation |

## Usage Guidelines

- Always use `infra-plugin` for any command that touches the cluster or Docker daemon -- do not construct raw `kubectl` or `docker` shell commands via `dev-tools-plugin` when a typed infra operation is available.
- Before applying any Kubernetes change with `infra-plugin`, use the dry-run option first and review the diff output. Only proceed to a live apply after confirming the diff is exactly what you intend.
- When pushing a Docker image, always provide an explicit tag that includes the Git SHA (e.g., `lukekelle00/figurio-backend:abc1234`). Never push or reference `latest` as the sole tag in a Kubernetes manifest.
- Use `dev-tools-plugin` for YAML and Dockerfile linting before committing CI/CD workflow changes. A syntax error in a workflow file can silently break the entire delivery pipeline.
- Scope `infra-plugin` Terraform operations to a single module at a time. Run `plan` and review output completely before calling `apply`. Treat `apply` on shared infrastructure the same as a production deployment -- it requires a known rollback path.

---
*Add personal tool notes below as you discover and use tools.*
