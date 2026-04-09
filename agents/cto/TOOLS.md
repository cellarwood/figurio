# Tools — CTO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Git workflows, dead-code analysis, dependency updates, docs generation |
| `office-plugin` | PPTX presentations, DOCX documents, XLSX spreadsheets |
| `infra-plugin` | K8s/GKE, Helm, Terraform, Traefik, auth configuration |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| mermaid | `mcp__plugin_media-plugin_mermaid` | Architecture diagrams and flowcharts |
| media-playwright | `mcp__plugin_media-plugin_media-playwright` | Browser-based testing and screenshots |

## Usage Guidelines

- Use dev-tools-plugin for code review, dependency auditing, and repo health checks
- Use infra-plugin for reviewing K8s configs, Helm charts, and Terraform plans — delegate actual changes to DevOps Engineer
- Use office-plugin for technical documentation and architecture presentations
- Use mermaid for creating system architecture diagrams and data flow charts
- Focus on reviewing and deciding, not implementing

---
*Add personal tool notes below as you discover and use tools.*
