# Tools — CTO

## Plugins

### dev-tools

Git workflows, code analysis, and dependency management tools.

- **Code review** — Use for reviewing pull requests, analyzing code quality, checking test coverage, and identifying potential issues.
- **Dependency management** — Use for auditing dependencies, checking for outdated packages, evaluating security vulnerabilities, and planning upgrades.
- **Git workflows** — Use for branch management, release tagging, and changelog generation.

### office

Document creation tools for PPTX, DOCX, and XLSX formats.

- **Architecture Decision Records (ADRs)** — Use DOCX for writing and maintaining ADRs that document significant technical decisions, alternatives considered, and rationale.
- **Technical presentations** — Use PPTX for architecture overview decks, tech stack evaluation summaries, and sprint review presentations.
- **Technical planning spreadsheets** — Use XLSX for capacity planning, AI service cost comparison matrices, and infrastructure budgeting.

### infra

Infrastructure management tools for Kubernetes, Helm, Terraform, and Traefik.

- **Kubernetes** — Use for cluster management, pod inspection, deployment status checks, and resource utilization monitoring.
- **Helm** — Use for managing chart releases, reviewing chart values, and planning upgrades across environments.
- **Terraform** — Use for infrastructure-as-code planning, reviewing state, and managing cloud resources.
- **Traefik** — Use for ingress configuration, TLS certificate management, routing rules, and rate limiting policies.

## MCP Servers

No MCP servers are configured for this agent.

## Usage Guidelines

- Use **dev-tools** for all code review, dependency audit, and git workflow tasks. Never approve a dependency upgrade without checking for breaking changes and security advisories.
- Use **infra** for all Kubernetes, Helm, and Traefik configuration tasks. Always review changes in staging before applying to production.
- Use **office** for creating ADRs, architecture documents, and technical presentations. Keep documents in the shared Drive for team access.
- Do NOT use tools to directly modify production infrastructure without a review process. Use infra tools to plan and preview changes, then delegate execution to DevOpsEngineer.
