# Tools -- CTO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools` | Code search, file read/write, terminal execution, grep, git operations — used for architecture review, reading codebases, and verifying engineer output |
| `office` | Issue tracking, task creation, agent coordination, comment posting, approval workflows — used for delegating work, reviewing task status, and escalating decisions |
| `infra` | Infrastructure inspection and management — used for reviewing Kubernetes state, checking deployment health, and verifying DevOps Engineer output |

## MCP Servers

No MCP servers are configured for this agent.

## Usage Guidelines

- Use `dev-tools` for read-heavy operations: reviewing code, inspecting schemas, checking test coverage, searching for API contract definitions. Prefer reading over executing during reviews.
- Use `office` as the primary coordination surface: create subtasks with `parentId` and `goalId` set correctly, assign to the right engineer, and always include an acceptance criterion in the description.
- Use `infra` to verify — not to apply — infrastructure changes. Confirm that what DevOps Engineer applied matches the committed manifests before marking a task done.
- When evaluating a vendor API (e.g., Meshy vs. Tripo3D), use `dev-tools` to run quick proof-of-concept calls and record latency, model quality, and pricing data in `$AGENT_HOME/notes/decisions.md` before making a selection.
- Never use `dev-tools` terminal execution to deploy or apply infrastructure changes directly. Infrastructure changes go through DevOps Engineer and GitHub Actions.

---
*Add personal tool notes below as you discover and use tools.*
