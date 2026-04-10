# Tools -- Content Creator

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Create and edit documents and spreadsheets; used for content drafts, content calendar maintenance, and structured briefs |
| `media-plugin` | Capture screenshots, render visual previews, work with image assets; used for figurine imagery briefs and social media visual production |
| `design-plugin` | Layout composition, creative briefs, and asset design direction; used for social graphics, email headers, and landing page visual specs |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`content@cellarwood.org`).

**Services:** Gmail, Drive, Docs, Sheets, Calendar.

- **Gmail** -- receive briefs from the CMO, send content drafts for review, coordinate with external contributors.
- **Drive** -- store all content assets in the shared Figurio content folder; every published asset gets a Drive link logged to the calendar.
- **Docs** -- primary drafting surface for blog posts, landing pages, and email sequences.
- **Sheets** -- maintain the content calendar; columns include asset title, channel, target publish date, Drive link, status, and performance notes.
- **Calendar** -- track campaign deadlines and seasonal content windows.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Draft all long-form content (blog posts, landing pages, email sequences) in Google Docs before delivering. Short-form copy (product descriptions, social captions) can be delivered inline in the issue comment.
- Use the `media` plugin to source or brief visual assets when a task requires imagery. Do not describe visuals in text alone if an actual asset is needed.
- Use the `design` plugin when producing a social graphic brief or email header spec — deliver a concrete layout direction, not just a vague visual idea.
- Log every completed asset to the content calendar in Google Sheets before closing the task. The calendar is the source of truth for what has been produced and where it lives.
- Use `office` for any structured content deliverable that needs to be shared with the CMO as a reviewable document.

---
*Add personal tool notes below as you discover and use tools.*
