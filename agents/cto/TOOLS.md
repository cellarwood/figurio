# Tools -- CTO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code search, file read/write, grep, static analysis, diff review, ADR authoring |
| `infra-plugin` | Inspect K8s cluster state, read deployment configs, check service health on microk8s |
| `office-plugin` | Issue and project management: create, update, comment, assign, and transition tasks |

## MCP Servers

None assigned.

## Usage Guidelines

- Use `dev-tools-plugin` to read existing code before making architectural recommendations -- do not prescribe solutions based on assumptions about the codebase.
- Use `infra-plugin` to verify the actual cluster state before assigning infra tasks to DevOps; a misconfigured service you can see is a blocker you can diagnose.
- Use `office-plugin` to create subtasks with `parentId` and `goalId` every time you delegate work -- untracked delegation is invisible delegation.
- When writing an ADR, save it to `$AGENT_HOME/adrs/` with a filename format `NNN-short-title.md` and update `$AGENT_HOME/adrs/index.md`.
- Do not use `dev-tools-plugin` to write production application code directly into the repo -- write specs and ADRs, then delegate implementation.

---
*Add personal tool notes below as you discover and use tools.*
