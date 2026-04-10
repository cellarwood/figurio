# Tools -- Backend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin@claude-my-marketplace` | Code execution, file editing, shell commands, test running, linting — the full local development loop |
| `infra-plugin@claude-my-marketplace` | Inspect and interact with infrastructure resources: containers, environment configs, service health |

## Usage Guidelines

- Always invoke `uv` for package management — `uv add <package>`, `uv run pytest`, `uv run ruff check`. Never call `pip` or `python -m pip` directly.
- Use `dev-tools` to run Alembic migrations in sequence: generate the revision first, inspect it, then apply. Never auto-generate and apply in a single unreviewed step.
- Use `dev-tools` to execute the full test suite (`uv run pytest`) before marking any backend task complete. A task is not done until tests pass.
- Use `infra` to verify Docker service health (PostgreSQL, the API container) when debugging environment-level failures rather than assuming the problem is in application code.
- When using shell access via `dev-tools`, prefer absolute paths. The working directory is not guaranteed between tool calls.

---
*Add personal tool notes below as you discover and use tools.*
