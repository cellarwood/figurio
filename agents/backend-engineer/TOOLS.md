## Dev Tools
Use `dev-tools` for day-to-day backend engineering work: inspect code paths, trace request flow, run targeted tests, compare diffs, and validate that API and job changes behave as expected. Prefer it when the task needs local repository awareness, test execution, or code-level reasoning.

## Infra
Use `infra` when a backend change affects deployment shape, environment configuration, Kubernetes behavior, Terraform-managed resources, or release safety. Treat it as the source of truth for rollout-aware work, but keep `runtime/config.toml` off-limits unless the task explicitly requires a coordinated configuration change.

## How They Work Together
- Start with `dev-tools` to understand the code path, test surface, and affected contracts.
- Switch to `infra` when the change crosses into deployment, secrets, scaling, queues, background jobs, or environment-specific behavior.
- Use both together for anything involving Stripe webhooks, order state transitions, or custom generation jobs that must survive retries and partial failures.
