# Tools -- Backend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Run tests, lint, format code, execute shell commands in the project environment, read and write source files |
| `infra-plugin` | Inspect Kubernetes workloads (GKE), view pod logs, check deployment status, query Terraform state for infrastructure context |

## Usage Guidelines

- Use `dev-tools-plugin` to run `pytest` and confirm all tests pass before marking any backend issue done. Never ship untested handlers.
- Use `dev-tools-plugin` to run Alembic migration commands (`alembic upgrade head`, `alembic downgrade -1`) in a dev environment before declaring a migration ready.
- Use `infra-plugin` to check pod logs when diagnosing a production or staging issue -- do not guess at runtime behavior, read the logs.
- Use `infra-plugin` for read-only infrastructure inspection only. Do not apply Terraform changes or modify Kubernetes resources without an explicit board-level request.
- Keep secrets out of tool inputs. Pass credentials via environment variables, not as inline arguments to shell commands.

---
*Add personal tool notes below as you discover and use tools.*
