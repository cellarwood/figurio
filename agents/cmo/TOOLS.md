# Tools -- CMO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Create and edit structured documents, spreadsheets, and presentations for briefs, reports, and planning materials |
| `media-plugin` | Process images and video assets, take screenshots, generate audio via ElevenLabs, and capture web pages for competitive research |
| `design-plugin` | Generate and iterate on visual assets, mockups, ad creatives, and brand materials |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`cmo@cellarwood.org`).

**Services:**
- **Gmail** (`gws-gmail`) -- read, triage, send, and reply to email. Primary channel for influencer outreach, vendor communication, and executive updates.
- **Drive** (`gws-drive`) -- store and share brand assets, campaign briefs, strategy documents, and reports. Treat Drive as the single source of truth for all marketing materials.
- **Docs** (`gws-docs`) -- write campaign briefs, brand voice guidelines, SEO strategy documents, and creative direction docs.
- **Sheets** (`gws-sheets`) -- maintain the marketing calendar, influencer outreach tracker, marketing spend log, and acquisition metrics dashboard.
- **Calendar** (`gws-calendar`) -- track campaign launch dates, seasonal deadlines, review milestones, and Content Creator check-ins.
- **Forms** (`gws-forms`) -- collect customer feedback, run post-purchase surveys, or gather audience research data.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use `design-plugin` to produce reference visuals and mockups when briefing the Content Creator — a visual brief produces better output than a text description alone.
- Use `media-plugin` to screenshot competitor social accounts, capture reference content, and process any raw image assets from print production before passing them to the Content Creator.
- All campaign briefs should live in Google Drive (Docs) and be linked from the corresponding Paperclip issue — never attach docs only to a comment.
- The influencer tracker and marketing spend log must be kept in Google Sheets and updated every session. These are the source of truth the CEO reviews.
- Use Gmail for all external outreach (influencers, PR contacts, vendors). Keep outreach threads labeled and tracked so follow-ups don't fall through.

---
*Add personal tool notes below as you discover and use tools.*
