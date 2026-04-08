# Tools — DevOps Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| **dev-tools** | Git workflows (branching, committing, diffing, PR management), dependency management, code search, repository navigation, file management |
| **infra** | Kubernetes manifest generation and management, Helm chart authoring and templating, Terraform configuration, Traefik ingress rule configuration, infrastructure-as-code tooling |

## MCP Servers

No MCP servers configured.

## Tool Usage Guidelines

- Use **infra** for all Kubernetes manifest generation, Helm chart authoring, and Traefik ingress configuration. When creating or modifying Helm charts, use `helm template` to validate output before applying. Use infra tooling for Kubernetes resource definitions (Deployments, Services, Ingresses, ConfigMaps, Secrets, HPA, NetworkPolicies).
- Use **dev-tools** for CI/CD pipeline management — authoring and updating GitHub Actions workflows, managing workflow dependencies, and reviewing pipeline run results. Also use for dependency updates, git operations (branch management, PR creation, diff review), and navigating the monorepo.
- When generating Kubernetes manifests, always include resource requests and limits, health checks (liveness and readiness probes), and appropriate labels and annotations.
- When authoring Helm charts, use values files for environment-specific configuration. Keep templates DRY with named templates and helpers.
- When configuring Traefik, define ingress routes as Kubernetes IngressRoute CRDs. Use middleware for rate limiting, headers, and redirects.
- Always check tool availability before attempting to use a tool that may not be configured.
