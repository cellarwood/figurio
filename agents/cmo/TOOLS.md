# Tools — CMO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | PPTX presentations, DOCX documents, XLSX spreadsheets |
| `media-plugin` | AI image/video/music/speech generation, SVG icons, charts, diagrams |
| `design-plugin` | Creative direction, styleguides, typography, color systems, design review |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| mermaid | `mcp__plugin_media-plugin_mermaid` | Marketing funnel diagrams and campaign flowcharts |
| media-playwright | `mcp__plugin_media-plugin_media-playwright` | Visual content testing and screenshots |
| media-mcp | `mcp__plugin_media-plugin_media-mcp` | AI image, video, and music generation |
| ElevenLabs | `mcp__plugin_media-plugin_ElevenLabs` | AI voice and speech generation |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var.

**Services:** Gmail (send, read, reply, triage), Calendar (events, agenda), Drive, Docs, Sheets, Forms.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use design-plugin for brand identity development and style guide creation
- Use media-plugin for generating campaign visuals and social media assets
- Use office-plugin for campaign briefs, performance reports, and presentations to CEO
- Use Google Workspace for communication with external partners and campaign scheduling
- Delegate content production to Content Creator — use these tools for strategy and direction

---
*Add personal tool notes below as you discover and use tools.*
