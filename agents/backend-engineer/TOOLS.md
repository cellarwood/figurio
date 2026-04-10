# Tools -- Backend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Run shell commands, execute tests, read and write files, inspect running processes, manage local dev environment |
| `infra-plugin` | Interact with Docker and MicroK8s (inspect containers, pods, logs, apply manifests), query Traefik routing state |

## Usage Guidelines

- Use `dev-tools-plugin` for all local development work: running `uv` commands, executing `alembic`, running `pytest`, inspecting FastAPI logs, reading and writing source files.
- Always run `uv run alembic upgrade head` through `dev-tools-plugin` shell execution — never apply migrations by hand via `psql`.
- Use `infra-plugin` to inspect container and pod state when debugging a deployed service, not as a substitute for writing correct application code.
- When testing Stripe webhook handlers locally, use `stripe listen --forward-to` via `dev-tools-plugin` shell; capture the webhook secret it prints and set it as `STRIPE_WEBHOOK_SECRET` in your local `.env`.
- Do not use `infra-plugin` to modify production Kubernetes resources unless explicitly instructed — use it for read operations (logs, pod status, resource describe) during incident investigation.

---
*Add personal tool notes below as you discover and use tools.*
