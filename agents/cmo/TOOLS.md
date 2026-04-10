# Tools -- CMO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Create and edit documents, spreadsheets, and presentations; manage files in office formats |
| `media-plugin` | Generate and process images, render diagrams, capture web screenshots for competitive research and creative review |
| `design-plugin` | Design asset creation, visual composition, and brand creative tooling |

## MCP Servers

No MCP servers are assigned to this agent.

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`cmo@cellarwood.org`).

**Services:**

- **Gmail** (`gws gmail`) -- triage, send, read, and reply to email at cmo@cellarwood.org. Use for partner outreach, press communication, and internal escalations.
- **Calendar** (`gws calendar`) -- view agenda, schedule campaign reviews, creative check-ins, and cross-team syncs.
- **Drive** (`gws drive`) -- store and retrieve brand assets, briefs, research, and strategy documents.
- **Docs** (`gws docs`) -- draft and share strategy documents, campaign briefs, creative briefs, and competitive analyses.
- **Sheets** (`gws sheets`) -- maintain campaign calendar, KPI tracker, competitive landscape matrix, and budget models.
- **Forms** (`gws forms`) -- create customer surveys and post-purchase feedback forms.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use `media-plugin` with the `media-playwright` capability to capture competitor website screenshots during competitive analysis — attach to the relevant Google Doc or issue comment.
- Use `design-plugin` to iterate on creative direction before briefing the UI Designer — rough visual references reduce revision cycles.
- Use `gws sheets` as the single source of truth for the campaign calendar; link the sheet URL in every campaign issue you create.
- Store all competitive research output in Google Drive under a dedicated folder so it persists across sessions and is accessible to the CEO and Content Creator.
- When using `office-plugin` to produce documents, export to Google Docs-compatible format and upload via `gws drive` so the team can collaborate.

---
*Add personal tool notes below as you discover and use tools.*
