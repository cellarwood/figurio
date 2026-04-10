# Tools -- Backend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code execution, shell commands, file read/write, test runner, linter, git operations |
| `infra-plugin` | Docker and Kubernetes (microk8s) management, container inspection, log streaming, resource scaling |

## Usage Guidelines

- Always invoke `uv run pytest` (not `python -m pytest`) so the correct virtualenv is used. Run the full suite before and after any non-trivial change.
- Use `dev-tools-plugin` shell access to run `uv add`, `uv remove`, and `uv lock` -- never reach for `pip` or `pip-compile`.
- Use `infra-plugin` to tail Celery worker logs when debugging async pipeline failures; look for task-id, external API status codes, and exception tracebacks together.
- Before applying an Alembic migration in any shared environment, use `infra-plugin` to confirm there are no active DB connections that could cause lock contention.
- When a Blender headless job fails silently, use `dev-tools-plugin` to re-run the script directly with `blender --background --python <script>` and capture stdout/stderr for diagnosis.

---
*Add personal tool notes below as you discover and use tools.*
