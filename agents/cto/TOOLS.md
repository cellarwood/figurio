# Tools -- CTO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code search, file inspection, running scripts, calling external APIs for provider evaluation and benchmarking |
| `infra-plugin` | Inspect and query infrastructure state: K8s cluster, Terraform outputs, Traefik config, resource utilization |
| `office-plugin` | Create and manage issues, comments, subtasks, and approvals in the Paperclip workspace |

## Usage Guidelines

- Use `dev-tools-plugin` when evaluating AI text-to-3D providers -- call their APIs directly, capture response times and output quality, write benchmark results to `$AGENT_HOME/notes/provider-eval.md` before making a build-vs-buy recommendation.
- Use `infra-plugin` to review infrastructure state when making architecture decisions -- confirm current resource usage, check cluster topology, and validate Terraform outputs before approving infra changes from the DevOps Engineer.
- Use `office-plugin` to create all delegated subtasks with explicit `parentId` and `goalId` -- never delegate verbally in a comment without a tracked issue.
- When reviewing cross-service designs, use `dev-tools-plugin` to read existing API contracts and schema files before commenting -- do not critique what you have not read.
- Record every significant build-vs-buy decision as a comment on the relevant issue before delegating implementation -- the decision and rationale must be traceable.

---
*Add personal tool notes below as you discover and use tools.*
