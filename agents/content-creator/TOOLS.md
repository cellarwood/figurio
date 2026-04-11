# Tools -- Content Creator

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Draft, format, and manage structured documents; produce newsletter copy and long-form content in office-compatible formats |
| `media-plugin` | Handle images and media assets, run Playwright-based web research for competitive content and keyword analysis, integrate ElevenLabs for audio/voiceover scripts |
| `design-plugin` | Coordinate with brand visual assets, support layout briefs, and assist with design-adjacent content such as alt text, image captions, and visual concept notes |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`content@cellarwood.org`).

**Services:**

- **Gmail** (`gws gmail`) -- Send email newsletters, receive campaign briefs from the CMO, manage content review threads.
- **Drive** (`gws drive`) -- Upload finished content assets: blog drafts, product copy documents, newsletter templates, social copy banks.
- **Docs** (`gws docs`) -- Author and collaborate on long-form content: blog posts, product PDP copy, email drafts, and the brand voice guide.
- **Sheets** (`gws sheets`) -- Maintain the editorial calendar, keyword tracker, newsletter send log, and content performance notes.
- **Calendar** (`gws calendar`) -- Check publish deadlines, campaign milestones, and social scheduling windows.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Before writing any product description or blog post, confirm the target keyword with the SEO checklist skill -- never write first and optimize later.
- Use media-plugin's Playwright capability to research competitor content, inspect SERPs for a target keyword, or pull reference material from the web before drafting.
- Store every finished content asset in Google Drive with a consistent naming convention: `[type]-[slug]-[YYYY-MM-DD]` (e.g., `blog-3d-printing-gift-guide-2026-04-11`).
- Use Google Docs as the single source of truth for drafts -- paste finalized copy into the issue comment as a link, not inline text.
- When writing TikTok or Instagram scripts that require audio, use ElevenLabs via media-plugin to prototype voiceovers for CMO review.

---
*Add personal tool notes below as you discover and use tools.*
