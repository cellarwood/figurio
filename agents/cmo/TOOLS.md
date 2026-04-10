# Tools -- CMO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Read and write documents, spreadsheets, and presentations; manage files across local and cloud storage |
| `media-plugin` | Generate and manipulate images, render diagrams via Mermaid, capture web screenshots via Playwright, interact with ElevenLabs for audio/voiceover |
| `design-plugin` | Create and edit visual assets, brand graphics, and design collateral |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-cmo@cellarwood.org`).

**Services:** Gmail, Calendar, Drive, Docs, Sheets, Forms.

| Service | Primary use |
|---------|------------|
| Gmail | Influencer outreach, press inquiries, partnership conversations, newsletter coordination |
| Calendar | Marketing calendar, campaign deadlines, content review scheduling |
| Drive | Brand asset storage, campaign brief archives, shared docs with content-creator |
| Docs | Campaign briefs, brand guidelines, press kit, influencer decks |
| Sheets | Marketing calendar, influencer pipeline tracker, channel performance dashboard |
| Forms | Customer feedback surveys, post-purchase NPS, waitlist or pre-launch signups |

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use `media-plugin` Playwright to audit competitor pages, capture live screenshots of the Figurio storefront for campaign reference, or verify that a published page looks correct before an announcement goes out.
- Use `design-plugin` to produce brand-consistent social graphics, campaign banners, or influencer kit visuals — do not outsource visual production when the tooling is available.
- Use `media-plugin` Mermaid to diagram campaign flows, content calendars, or funnel structures when sharing plans with the CEO or content-creator.
- Keep influencer and press contacts in a Sheets tracker (Drive) — treat it as your lightweight CRM and update it every time a conversation advances.
- When writing outreach via Gmail, use the `gws gmail send` command with your `AGENT_EMAIL` as sender. Always draft first, review for tone against SOUL.md, then send.

---
*Add personal tool notes below as you discover and use tools.*
