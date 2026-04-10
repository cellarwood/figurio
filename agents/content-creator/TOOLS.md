# Tools -- Content Creator

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Read and write structured documents and spreadsheets; manage content calendars, keyword trackers, and copy libraries |
| `media-plugin` | Browser screenshots via Playwright, image preview, media asset inspection, ElevenLabs audio generation for TikTok voiceover scripts |
| `design-plugin` | Visual asset creation, image composition review, graphic brief generation |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`content@cellarwood.org`).

**Services:**

- **Gmail** -- receive briefs from the CMO, coordinate with contributors, send drafts for review, reply to editorial feedback
- **Drive** -- store and organize all content drafts, published archives, asset libraries, and the email copy library
- **Docs** -- write long-form blog posts and email sequences for collaborative CMO review before publishing
- **Sheets** -- maintain the content calendar, keyword research tracker, social scheduling log, and performance data
- **Calendar** -- track publishing deadlines, campaign go-live dates, and content review checkpoints

Run `gws --help` or `gws <service> --help` for full CLI documentation.

## Usage Guidelines

- Use `media-plugin` Playwright to screenshot live product pages or published blog posts for quality checks before sharing with the CMO.
- Use `design-plugin` to generate or review visual asset briefs when a social post requires custom imagery — always attach the brief to the relevant issue before marking content done.
- Store every finalized content artifact in Google Drive in the appropriate folder (blog/, product-descriptions/, email-library/, social/) before closing an issue.
- Use Google Sheets as the single source of truth for the content calendar — update it whenever a post is drafted, approved, or published.
- Use ElevenLabs (via `media-plugin`) only for internal script read-through checks or TikTok voiceover prototypes; do not publish AI-generated audio without CMO sign-off.

---
*Add personal tool notes below as you discover and use tools.*
