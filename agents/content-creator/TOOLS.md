# Tools -- Content Creator

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `media-plugin` | Generate images and video, capture screenshots via Playwright, create Mermaid diagrams, text-to-speech via ElevenLabs |
| `design-plugin` | Create brand-consistent visual assets, layouts, banners, and typography compositions |
| `office-plugin` | Create and edit documents, spreadsheets, and presentations locally |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-content@cellarwood.org`).

**Services:** Gmail (read, send, reply), Google Drive (upload, organize), Google Docs (draft, write, collaborate), Google Sheets (keyword tracking, content calendars, performance data), Google Calendar (editorial calendar, deadlines).

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use `media-plugin` for all image generation; always verify outputs are IP-clean before saving or uploading anything.
- Use `design-plugin` when brand consistency matters — banners, social templates, and anything that will be reused should be built here, not hand-assembled in a doc.
- Store every finished content asset in Google Drive using a consistent folder structure: `/Figurio Content/[Year]/[Type]/`; upload with `gws drive upload` and record the link in the relevant issue comment.
- Use Google Docs for all long-form drafts so the CMO can review and comment inline; do not paste final copy directly into issue comments.
- Maintain the keyword tracker and editorial calendar in Google Sheets and Google Calendar respectively — these are the shared source of truth for content planning and must be kept current each session.

---
*Add personal tool notes below as you discover and use tools.*
