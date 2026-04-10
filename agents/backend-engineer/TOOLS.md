# Tools -- Backend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code execution, shell commands, file read/write, test running, linting — primary tool for all backend development work |
| `infra-plugin` | Inspect and interact with Docker, Kubernetes, and Terraform resources — used for checking container health, reading logs, and validating infra config |

## Usage Guidelines

- Always invoke Python via `uv run <command>` -- for example `uv run pytest`, `uv run alembic upgrade head`, `uv run uvicorn app.main:app`. Never call `pip`, `python -m pip`, or bare `python` directly.
- Use `dev-tools-plugin` to run the full test suite (`uv run pytest`) before marking any implementation task complete. A task with failing tests is not done.
- Use `infra-plugin` to tail container logs when debugging a live issue (Stripe webhook delivery failures, AI job polling errors, database connection problems) -- do not attempt to modify Kubernetes resources without CTO approval.
- When generating an Alembic migration, always review the generated SQL in the migration file before applying it. Use `dev-tools-plugin` to read the file immediately after generation.
- Use `dev-tools-plugin` for all file edits -- schema models, route handlers, Pydantic schemas, test fixtures. Keep changes atomic per issue.

---
*Add personal tool notes below as you discover and use tools.*
