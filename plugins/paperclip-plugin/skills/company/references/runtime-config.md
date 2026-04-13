# Runtime Configuration Reference

Runtime config is split into two scopes: global (all agents) and per-agent.

Codex resolves plugin state in layers: the Codex home (`~/.codex` or `/paperclip/.codex` in Docker) holds the shared cache and `config.toml`, while the per-agent runtime config controls which plugins and permissions are active for that agent.

## Global Config (`global/`)

Processed once at container startup by the Docker entrypoint. Affects all agents.

### `global/config.toml`

Baseline shared Codex config for the whole container. Keep this minimal; per-agent enablement belongs in each agent runtime config.

```toml
[plugins."paperclip-plugin@codex-my-marketplace"]
enabled = true
```

### `global/plugins.json`

Marketplace and plugin installation. Installs binaries globally so any agent can enable them.

```json
{
  "marketplaces": [
    {
      "name": "codex-my-marketplace",
      "source": "lukaskellerstein/codex-my-marketplace",
      "scope": "user"
    }
  ],
  "plugins": [
    { "name": "dev-tools-plugin@codex-my-marketplace", "scope": "user" },
    { "name": "office-plugin@codex-my-marketplace", "scope": "user" },
    { "name": "infra-plugin@codex-my-marketplace", "scope": "user" },
    { "name": "media-plugin@codex-my-marketplace", "scope": "user" },
    { "name": "design-plugin@codex-my-marketplace", "scope": "user" },
    { "name": "web-design-plugin@codex-my-marketplace", "scope": "user" },
    { "name": "company-plugin@codex-my-marketplace", "scope": "user" }
  ]
}
```

Only include plugins that at least one agent will use.

## Per-Agent Config (`agents/{slug}/runtime/`)

### `runtime/config.toml`

Controls which globally-installed plugins are active for this agent, plus any per-agent env vars or MCP servers.

```toml
[plugins."paperclip-plugin@codex-my-marketplace"]
enabled = true

[plugins."dev-tools-plugin@codex-my-marketplace"]
enabled = true

[plugins."design-plugin@codex-my-marketplace"]
enabled = true

[shell_environment_policy]
inherit = "all"

[shell_environment_policy.set]
SOME_VAR = "value"
```

See `role-plugin-matrix.md` in the company command references for exact assignments per role.

MCP server definitions now live in the same TOML file:

```toml
[mcp_servers.chrome-devtools]
command = "npx"
args = ["-y", "chrome-devtools-mcp@latest"]
```

### `runtime/agents/*.md` (Subagents)

Codex subagent definitions. Discovered from the active Codex runtime state.

Source: `agents/{slug}/runtime/agents/*.md`
Deployed to: `<workspace>/.codex/agents/*.md`

```markdown
---
name: code-reviewer
description: >
  Reviews code for quality and security. Never modifies code.
model: sonnet
disallowedTools: Edit, Write
color: blue
---

You are a senior code reviewer. Report findings with file paths and line numbers.
```

Use subagents for quick in-session tasks (review, test, search). Use Paperclip task delegation for tracked, cross-agent work.

## Available Plugins (marketplace)

| Plugin | What it provides | MCP servers |
|--------|-----------------|-------------|
| `dev-tools-plugin` | Git workflows, dead-code analysis, dependency updates, docs generation | — |
| `office-plugin` | PPTX presentations, DOCX documents, XLSX spreadsheets | — |
| `infra-plugin` | Kubernetes/GKE, Istio, Helm, Terraform, Traefik, auth | — |
| `media-plugin` | AI image/video/music/speech generation, stock photos, SVG icons, charts, diagrams | media-mcp, ElevenLabs, Mermaid Chart, Playwright |
| `design-plugin` | Creative direction, styleguides, aesthetic strategy, design review | — |
| `web-design-plugin` | End-to-end website/webapp design, visual testing. Depends on: design-plugin, media-plugin | Playwright |
| `company-plugin` | Shipping (Zasilkovna, DHL), payments (Stripe) | DHL API Assistant, Stripe |

Plugin names in `plugins` use: `{name}@codex-my-marketplace`

**Dependencies:** `web-design-plugin` depends on `design-plugin`, which depends on `media-plugin` and `office-plugin`. Enable dependencies too.
