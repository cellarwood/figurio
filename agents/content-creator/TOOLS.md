# Tools -- Content Creator

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Create and edit documents, spreadsheets, and structured text files; manage content calendar entries |
| `media-plugin` | Generate images and visual mockups, capture screenshots via Playwright, produce voiceover scripts via ElevenLabs, handle media assets |
| `design-plugin` | Create branded graphics, social media visuals, and marketing assets aligned with Figurio's visual identity |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-content@cellarwood.org`).

**Services:**

- **Gmail** — send collaboration emails, read replies from partners, respond to content-related threads
- **Calendar** — manage the content calendar, schedule publish dates, coordinate review deadlines with the CMO
- **Drive** — store and organize all content drafts, brand assets, image exports, and campaign files
- **Docs** — write long-form content (blog posts, email copy, web page drafts) for CMO review and approval
- **Sheets** — track the content calendar, keyword research, SEO performance notes, and campaign metrics

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Write all content drafts in Google Docs before publishing anywhere. Use a consistent naming convention: `[TYPE] Title -- DRAFT vN` (e.g., `[BLOG] How PolyJet Printing Works -- DRAFT v1`).
- Store final approved assets in Drive under a folder hierarchy: `Content / {Channel} / {Quarter}` (e.g., `Content / Blog / Q2-2026`).
- Use `media-plugin` to generate visual mockups or product renders when real photography is not yet available; label all generated images clearly as mockups in Drive.
- Use `design-plugin` for any social graphic or branded asset — do not improvise visual identity decisions; when in doubt, ask the CMO for brand direction.
- Run `gws sheets` to update the content calendar and SEO tracker after every published piece. Stale spreadsheets are useless spreadsheets.

---
*Add personal tool notes below as you discover and use tools.*
