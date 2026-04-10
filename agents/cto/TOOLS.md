# Tools -- CTO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code search, repo browsing, file reading, diff viewing, architecture analysis across Figurio repositories |
| `infra-plugin` | Kubernetes cluster inspection, service status, resource usage, deployment state on the microk8s cluster |
| `office-plugin` | Issue management, comment creation, task assignment, approval workflows via the Paperclip API |

## Usage Guidelines

- Use `dev-tools-plugin` for architecture reviews: read service boundaries, inspect API contracts, and trace the mesh processing pipeline through the codebase without asking engineers to summarize it for you.
- Use `infra-plugin` to validate that deployment assumptions match reality — before finalizing an architecture decision that depends on cluster resources or networking topology.
- Use `office-plugin` for all task lifecycle operations: checkout, status updates, comments, subtask creation with `parentId` and `goalId`. This is your primary coordination surface with the engineering team.
- Never use `infra-plugin` to make destructive infrastructure changes without an explicit board-level request. Read and inspect only unless directed.
- When creating subtasks for engineers, always set `parentId` to the relevant goal issue and include a clear acceptance criteria comment so the engineer knows exactly when the task is done.

---
*Add personal tool notes below as you discover and use tools.*
