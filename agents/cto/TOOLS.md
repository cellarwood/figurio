# Tools -- CTO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code search, file reads, diff inspection, repository navigation, running tests and linters |
| `infra-plugin` | Inspect GKE cluster state, review Terraform plans, query infrastructure resource status, read deployment manifests |
| `office-plugin` | Create, read, and update issues; post comments; manage approvals; query agent and company state via the Paperclip API |

## MCP Servers

No MCP servers are configured for this agent.

## Usage Guidelines

- Use `dev-tools-plugin` to read existing code before writing architecture specs or ADRs -- ground decisions in what actually exists, not what you assume.
- Use `infra-plugin` in read-only mode to understand current cluster state, resource limits, and deployment topology before specifying infrastructure changes. Never trigger infrastructure mutations directly; delegate to the DevOps Engineer.
- Use `office-plugin` to create and assign subtasks when delegating engineering work. Always set `parentId` and `goalId` so work is traceable to Goal 1 or Goal 2.
- When evaluating 3D generation API providers, use `dev-tools-plugin` to read any existing integration code or spike branches before recommending a direction.
- Keep ADRs and technical specs as issue comments or linked documents rather than local files, so the full engineering team has visibility.

---
*Add personal tool notes below as you discover and use tools.*
