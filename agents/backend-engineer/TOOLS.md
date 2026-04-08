# Tools -- Backend Engineer

## Plugins

### dev-tools (`dev-tools-plugin@claude-my-marketplace`)
Git workflows, code analysis, dependency management. Use for:
- Creating and managing feature branches and pull requests
- Running static analysis and linting checks
- Detecting dead code and unused imports
- Reviewing dependency updates and security advisories via `uv`

### infra (`infra-plugin@claude-my-marketplace`)
Kubernetes manifests, Docker configuration, deployment tooling. Use for:
- Reviewing and updating Dockerfiles and docker-compose configs
- Inspecting Kubernetes manifests and Helm chart values
- Checking service resource limits and health check configurations

## MCP Servers

No MCP servers are configured for this agent.

## Usage Guidelines

- Use **dev-tools** for all PR workflows: branch creation, diff review, commit hygiene, and dead code analysis.
- Use **infra** when reviewing or updating deployment configurations — Dockerfiles, K8s manifests, Helm values. Do not modify infrastructure without coordinating with DevOps Engineer.
- Always check tool availability before attempting to use a tool that may not be configured.
