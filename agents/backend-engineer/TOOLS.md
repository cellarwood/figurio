# Tools -- Backend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Run shell commands, execute tests, read and write files, manage Python environments via uv, run Alembic migrations, inspect logs |
| `infra-plugin` | Inspect and interact with Docker containers and microk8s resources, check service health, view pod logs |

## Usage Guidelines

- Use `dev-tools-plugin` to run `uv run pytest` for all test execution -- never invoke pytest or python directly outside of uv.
- Use `dev-tools-plugin` to run `uv run alembic upgrade head` and `uv run alembic downgrade -1` to test migration reversibility before closing a task.
- Use `infra-plugin` to check that the FastAPI container is healthy after a deployment or config change -- look at pod logs for startup errors or migration failures.
- When debugging a failing endpoint, use `dev-tools-plugin` to inspect server logs directly rather than adding temporary print statements to production code.
- Use `dev-tools-plugin` to run `uv add <package>` for any new dependency -- never use pip. Commit the updated `pyproject.toml` and `uv.lock` together.

---
*Add personal tool notes below as you discover and use tools.*
