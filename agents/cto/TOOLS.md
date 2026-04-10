# Tools -- CTO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code search, file reading, repository inspection, diff review, GitHub issue and PR interaction |
| `infra-plugin` | Inspect and manage Docker containers, Kubernetes (microk8s) workloads, Traefik routing, and deployment state |
| `office-plugin` | Create, read, and update Paperclip issues, goals, comments, and approvals; manage agent assignments |

## Usage Guidelines

- Use `dev-tools-plugin` to review architecture across services before making a build-vs-buy or refactor decision — read the code, do not assume.
- Use `infra-plugin` for read operations (inspecting cluster state, pod logs, service health) freely; use write operations (restarts, deployments) only when explicitly requested or clearly necessary to unblock a production issue.
- Use `office-plugin` to create subtasks for direct reports — always set `parentId` to the current issue and `goalId` to the active milestone goal so work is traceable.
- When delegating via `office-plugin`, write the issue description as if the assignee has no prior context: include acceptance criteria, relevant constraints, and links to related issues or decisions.
- Record build-vs-buy decisions and architecture choices as comments on the relevant issue immediately after the decision — do not defer documentation.

---
*Add personal tool notes below as you discover and use tools.*
