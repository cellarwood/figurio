# Tools -- CMO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin@claude-my-marketplace` | Document and spreadsheet creation, editing, and reading for briefs, trackers, and reports |
| `media-plugin@claude-my-marketplace` | Web browsing via Playwright, media capture, Mermaid diagram generation, ElevenLabs audio synthesis |
| `design-plugin@claude-my-marketplace` | Image and visual asset generation for campaign graphics, social content, and mood boards |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`cmo@cellarwood.org`).

**Services:**

- **Gmail** -- influencer outreach, press and partnership emails, internal coordination. Triage inbox, send and reply to threads.
- **Drive** -- store and share campaign briefs, brand guidelines, content calendars, influencer lists.
- **Docs** -- write campaign briefs, brand voice documents, SEO content briefs, press releases.
- **Sheets** -- content calendar, influencer pipeline tracker, campaign performance dashboard, customer acquisition funnel metrics.
- **Calendar** -- schedule campaign launches, seasonal moment deadlines, influencer content delivery dates.
- **Forms** -- post-purchase customer surveys, influencer application or interest forms.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use the **design plugin** to generate visual references and mood boards when briefing Content Creator -- a visual brief is clearer than a written description alone.
- Use the **media plugin's Playwright capability** to audit competitor social presence, check influencer follower counts and engagement rates, and verify live campaign landing pages.
- Keep the **influencer pipeline Sheets tracker** as the source of truth for outreach status -- update it after every email sent or reply received via Gmail.
- Use **Google Docs** for all campaign briefs shared with Content Creator so they have comment access and a stable link to attach to issues.
- Use **ElevenLabs** (via media plugin) sparingly -- consider it for short audio promos or brand voice demos when the channel warrants it, not as a default output.

---
*Add personal tool notes below as you discover and use tools.*
