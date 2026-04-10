# Tools -- CMO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Create and edit documents, spreadsheets, and presentations; read and write structured office files |
| `media-plugin` | Capture web screenshots via Playwright, generate Mermaid diagrams, produce audio/video content concepts via ElevenLabs |
| `design-plugin` | Generate and iterate on visual asset mockups, brand graphics, and campaign imagery |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-cmo@cellarwood.org`).

**Services:**

- **Gmail** -- influencer outreach, partner communications, inbox triage, follow-up sequences
- **Calendar** -- campaign calendar, review checkpoints with Content Creator, CEO syncs
- **Drive** -- shared storage for campaign briefs, brand guidelines, competitive research, influencer lists
- **Docs** -- campaign briefs, brand voice guide, Phase 2 pop-up strategy, competitive landscape docs
- **Sheets** -- marketing KPI tracker (traffic, conversion, CAC, email list, social followers), influencer outreach pipeline
- **Forms** -- post-purchase satisfaction surveys, Phase 2 scan-to-print interest capture

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use `media-plugin` Playwright to screenshot competitor product pages (HeroForge, Shapeways, Funko) when conducting competitive research — always save findings to Google Drive.
- Use `design-plugin` to generate initial visual directions for campaign briefs, then hand off to the Content Creator for production-quality assets; do not spend cycles iterating beyond concept stage yourself.
- Use `gws sheets` as the source of truth for KPI tracking and the influencer pipeline — update these sheets rather than keeping data in conversation memory.
- Use `gws gmail` for all external communications; never use a generic outreach template without personalizing the opening two sentences to the specific influencer.
- Use `office-plugin` for structured documents that need to be shared with the CEO or the board; prefer Google Docs for anything collaborative.

---
*Add personal tool notes below as you discover and use tools.*
