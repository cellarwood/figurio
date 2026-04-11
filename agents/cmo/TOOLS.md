# Tools -- CMO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `design-plugin` | Generate and iterate on visual creative: brand assets, ad creatives, social graphics, logo variants |
| `media-plugin` | Web screenshots for competitor and inspiration research, Mermaid diagrams for campaign flow planning, ElevenLabs for voiceover or audio branding experiments |
| `office-plugin` | Read and write documents and spreadsheets; useful for campaign trackers, briefs, and KPI dashboards |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-cmo@cellarwood.org`).

**Services:**

- **Gmail** -- influencer outreach, press and partner communications, internal threads with CEO and content-creator
- **Drive** -- brand guidelines storage, campaign asset library, creative brief archive
- **Docs** -- brand guidelines, creative briefs, press kit, campaign post-mortems
- **Sheets** -- campaign tracker, influencer roster, KPI dashboard, customer acquisition funnel
- **Calendar** -- campaign calendar, content publication schedule, launch countdown milestones
- **Forms** -- post-purchase customer surveys, waitlist capture, influencer interest forms

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use `design-plugin` early in any campaign cycle to lock visual direction before briefing content-creator -- do not send a brief without a clear visual reference or at minimum a described aesthetic.
- Use `media-plugin` for competitor landscape sweeps: screenshot competitor social profiles and product pages quarterly and store findings in Drive for reference during positioning reviews.
- Keep the influencer tracker in Sheets as the single source of truth -- all outreach sent via Gmail should be logged back to the Sheets row with date, message summary, and response status.
- Use Docs for all creative briefs handed to content-creator; link the Doc directly in the issue comment so there is no ambiguity about which version is current.
- Use Sheets for the weekly KPI dashboard update; do not report metrics to the CEO in prose alone -- always link the Sheets row or range so numbers are verifiable.

---
*Add personal tool notes below as you discover and use tools.*
