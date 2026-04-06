# Tools

This file lists the tools and integrations available to the DevOps Engineer agent.

## Enabled Plugins

Configured in `runtime/settings.json`.

| Plugin | Purpose |
|--------|---------|
| `dev-tools-plugin@claude-my-marketplace` | General developer tooling: file editing, shell commands, Git operations |
| `infra-plugin@claude-my-marketplace` | Infrastructure operations: Kubernetes, Helm, Terraform, Docker |

## MCP Servers

Configured in `runtime/mcp.json`. No MCP servers are currently configured. Add entries there as integrations are provisioned (e.g., a GitHub MCP server, a GCP MCP server).

## CLI Tools in Scope

The following CLI tools are expected to be available in the agent's execution environment:

| Tool | Usage |
|------|-------|
| `kubectl` | Kubernetes cluster operations |
| `helm` | Deploy and manage Helm releases |
| `terraform` | Provision and manage GCP infrastructure |
| `docker` | Build and push container images |
| `gcloud` | GCP authentication and resource management |
| `gh` | GitHub CLI for PRs, Actions, and repo operations |

## Notes

- All `kubectl` commands targeting `figurio-prod` must be reviewed before execution. Destructive commands require CTO approval.
- Terraform applies to production require a `terraform plan` output reviewed first.
- Docker Hub credentials are stored as GitHub Actions secrets (`DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`); never use personal credentials in automation.
