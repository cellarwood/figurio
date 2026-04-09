# Tools — Content Creator

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | PPTX presentations, DOCX documents, XLSX spreadsheets |
| `media-plugin` | AI image/video/music/speech generation, SVG icons, charts, diagrams |
| `design-plugin` | Creative direction, styleguides, typography, color systems, design review |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| mermaid | `mcp__plugin_media-plugin_mermaid` | Infographic diagrams for blog posts |
| media-playwright | `mcp__plugin_media-plugin_media-playwright` | Visual content capture and testing |
| media-mcp | `mcp__plugin_media-plugin_media-mcp` | AI image generation for social media and marketing visuals |
| ElevenLabs | `mcp__plugin_media-plugin_ElevenLabs` | Voiceover generation for video content |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var.

**Services:** Gmail (send, read, reply), Calendar (events, agenda), Drive (files, upload), Docs (write), Sheets.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use media-mcp for generating product lifestyle images, social media visuals, and blog hero images
- Use design-plugin for ensuring visual content follows brand guidelines
- Use office-plugin for content calendar spreadsheets and campaign briefs
- Use Google Drive to upload and organize all finished content assets
- Use ElevenLabs for video voiceovers and audio content when needed
- Always check generated images for IP compliance before publishing

---
*Add personal tool notes below as you discover and use tools.*
