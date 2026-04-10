# Tools -- Content Creator

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Create, read, and edit office documents; produce structured drafts and formatted content files |
| `media-plugin` | Generate images and visual mockups, take screenshots, produce audio via ElevenLabs, render diagrams with Mermaid |
| `design-plugin` | Brand identity asset creation, graphic design tasks, style guide visual components |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`content@cellarwood.org`).

**Services:** Gmail, Calendar, Drive, Docs, Sheets.

| Service | Primary Use |
|---------|------------|
| Gmail | Receive briefs from CMO, send drafts for review, coordinate on visual assets |
| Calendar | Track content calendar slots, publish deadlines, campaign launch dates |
| Drive | Store all finalized content assets — copy docs, image files, render exports, brand kit |
| Docs | Draft long-form content (blog posts, email sequences, style guide) for collaborative review |
| Sheets | Maintain content calendar, SEO keyword tracker, product description status table |

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Run the SEO checklist (skill: `seo-checklist`) before drafting any website copy or blog post — keyword strategy is defined before writing begins, not after.
- Use the content style guide (skill: `content-style-guide`) as the authoritative reference for tone, vocabulary, and formatting decisions on every piece of content.
- Store all final content assets in Google Drive under `Figurio / Assets / [content-type]` — never leave finals only in a local issue comment.
- Use media-plugin for AI-generated visuals and mockups; use design-plugin for anything touching the brand identity system (logo, color, typography).
- When producing a piece of content that requires a visual asset, create or reference a tracking entry in the content calendar Sheets tab so the dependency is visible and does not get dropped.

---
*Add personal tool notes below as you discover and use tools.*
