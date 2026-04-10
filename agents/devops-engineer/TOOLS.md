# Tools -- DevOps Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin@claude-my-marketplace` | Shell execution, file system access, code editing, script running — the primary tool for writing Dockerfiles, Helm charts, GitHub Actions workflows, and running cluster commands. |
| `infra-plugin@claude-my-marketplace` | Infrastructure provisioning and management operations — interacting with cloud and cluster resources, managing Kubernetes objects, and executing infra-level automation. |

## MCP Servers

No MCP servers are configured for this agent.

## Usage Guidelines

- Use `dev-tools` for all file authoring tasks: Dockerfiles, Helm values, GitHub Actions YAML, Kubernetes manifests, backup scripts. Prefer editing files in place over creating new ones when updating existing infrastructure.
- Use `infra` for live cluster interactions: applying manifests, checking rollout status, inspecting pod logs, managing PVCs. Always scope `kubectl` commands to the correct namespace with `-n {namespace}`.
- Never store secrets in files managed by these tools. Use Kubernetes Secrets objects and reference them via `secretKeyRef` or `envFrom`.
- Before running any destructive infra command (delete, rollback, drain), capture the current state first — `kubectl get`, `helm status`, or a manifest export — so you have a rollback artifact.
- Pin image tags explicitly in all Helm values files. Never deploy with `latest` in production.

---
*Add personal tool notes below as you discover and use tools.*
