# Tools -- CMO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Create and edit documents, spreadsheets, and presentation files; manage structured content like campaign calendars and briefs |
| `media-plugin` | Capture web screenshots (Playwright), generate diagrams (Mermaid), work with images and media assets, ElevenLabs audio generation |
| `design-plugin` | Visual design asset creation and manipulation; useful for mood boards, brand asset drafts, and image compositing |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`cmo@cellarwood.org`).

**Services:**

- **Gmail** (`gws gmail`) -- triage influencer and press replies, send outreach, manage campaign correspondence
- **Calendar** (`gws calendar`) -- maintain the campaign deadline calendar, schedule content reviews, influencer calls, and launch milestones
- **Drive** (`gws drive`) -- store brand guidelines, campaign briefs, asset libraries, analytics exports, and post-mortems
- **Docs** (`gws docs`) -- author creative briefs, brand voice guides, influencer outreach templates, campaign post-mortems
- **Sheets** (`gws sheets`) -- campaign calendar, influencer tracker, SEO keyword map, channel performance dashboards
- **Forms** (`gws forms`) -- influencer interest collection, post-purchase UGC consent, customer feedback surveys

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Write every creative brief as a Google Doc and link it in the corresponding Paperclip issue before assigning work to the Content Creator.
- Maintain the campaign calendar in a single Google Sheet in Drive -- one row per campaign, columns for owner, deadline, status, and linked brief.
- Use `media-plugin` Playwright screenshots to capture competitor ads, landing pages, and social posts as research artifacts stored in Drive.
- Use `media-plugin` Mermaid diagrams to map campaign funnel flows or influencer seeding timelines when briefing the CEO on strategy.
- Keep the influencer tracker in Google Sheets (name, handle, follower count, niche, outreach date, reply status, seeding status, UGC received) -- update it every heartbeat cycle.

---
*Add personal tool notes below as you discover and use tools.*
