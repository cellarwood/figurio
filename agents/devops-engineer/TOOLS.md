# Tools -- DevOps Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Run shell commands, execute scripts, interact with CI/CD tooling, inspect build artifacts and logs |
| `infra-plugin` | Manage cloud infrastructure resources, run Terraform commands, interact with Kubernetes clusters and Helm |

## Usage Guidelines

- Before any `terraform apply` in production, run `terraform plan` and post the plan summary as a comment on the relevant issue. Do not apply without that comment in place.
- When interacting with Kubernetes, always confirm the active context (`kubectl config current-context`) before running mutating commands. GKE and microk8s contexts must never be confused.
- Use `helm diff upgrade` before any Helm release update to production; include the diff in your issue comment so the CTO can review before or after the fact.
- Image tags pushed to Docker Hub (`lukekelle00/{service}`) must always be explicit version strings (e.g., `git-sha` or `v1.2.3`). The `latest` tag is forbidden for production images.
- After every deployment, validate health-check endpoints and confirm Sentry is receiving events from the new release before marking the issue complete.

---
*Add personal tool notes below as you discover and use tools.*
