# Tools -- Backend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Run tests, linting, code formatting, and static analysis against the Python codebase |
| `infra-plugin` | Inspect and manage Docker and Kubernetes resources, view container logs, trigger deployments |

## Usage Guidelines

- Use `dev-tools-plugin` to run the test suite and linter before marking any task complete. A passing CI check is a hard requirement.
- Use `infra-plugin` to inspect running service logs when debugging a failing webhook handler or a stuck AI generation job. Do not modify Kubernetes resources in production without explicit CTO approval.
- When wrapping Stripe or AI API calls, validate your integration locally with `dev-tools-plugin` test runners before deploying -- do not rely on live Stripe webhooks for first-pass testing.
- Use `infra-plugin` to confirm that a new migration applies cleanly to the staging database before requesting a production deployment.
- Keep third-party API credentials out of code and config files -- reference them via environment variables and document which variables are required in a comment at the call site.

---
*Add personal tool notes below as you discover and use tools.*
