# Tools — Content Creator

## Plugins

### Office Plugin (`office-plugin@claude-my-marketplace`)

- **Google Docs** — Write and edit blog post drafts, email newsletter copy, product descriptions, and content briefs. All long-form content starts as a Doc before publishing.
- **Google Sheets** — Maintain the content tracking sheet. Update statuses, log published URLs, track content performance metrics. The content calendar lives here.
- **Google Drive** — Upload finished assets (images, renders, documents, videos). Organize by channel and date.

### Media Plugin (`media-plugin@claude-my-marketplace`)

- **media-mcp** — Generate AI product mockups, social media visuals, lifestyle scene renders, and promotional graphics. Use for product shots when physical photography is not yet available, for social post visuals, and for campaign asset creation.
- **ElevenLabs** — Generate voiceovers for TikTok videos, product reveal videos, and promotional video content. Use for narrated unboxing scripts, "Prompt to Print" reveal videos, and seasonal campaign video audio.
- **mermaid** — Create content flow diagrams, editorial workflow charts, and content pipeline visualizations. Use for planning and documenting content production processes.
- **media-playwright** — Browser automation for content research, competitor analysis screenshots, and social media reference gathering.

### Design Plugin (`design-plugin@claude-my-marketplace`)

- **Brand styleguide adherence** — Ensure all visual content follows Figurio's brand guidelines: color palette, typography, logo usage, and visual identity standards. Check every asset against the styleguide before publishing.

## MCP Servers

| Server | Purpose |
|---|---|
| `mcp__plugin_media-plugin_mermaid` | Diagram rendering for content workflows and editorial pipelines |
| `mcp__plugin_media-plugin_media-playwright` | Browser automation for research and visual reference gathering |
| `mcp__plugin_media-plugin_media-mcp` | AI image and video generation for product mockups and social visuals |
| `mcp__plugin_media-plugin_ElevenLabs` | Text-to-speech for video voiceovers and audio content |

## Google Workspace

- **Email:** content@cellarwood.org
- **Domain:** cellarwood.org
- **Credentials:** `/paperclip/.gws/figurio.json`
- **Available GWS tools:** Gmail (send, read, reply), Calendar (agenda), Drive (upload), Docs (write), Sheets

## Usage Guidelines

### Product Mockups and Social Visuals

Use `media-mcp` to generate product mockups when physical photography is not available. This is critical for:

- New figurine launches where the product has not been printed yet.
- Social media posts that need lifestyle context (figurine on a desk, in a gift box, on a shelf).
- Seasonal campaign assets (figurines with holiday backgrounds and props).
- A/B testing different visual styles before committing to a photoshoot.

### Video Voiceovers

Use `ElevenLabs` to generate voiceovers for:

- TikTok narration — unboxing walkthroughs, "Prompt to Print" reveal commentary, product feature callouts.
- Instagram Reels — short, punchy voiceovers for product showcase videos.
- Email-embedded video content — product launch announcements with narrated demos.

### Blog Drafts and Content Calendar

Use `office` tools (Docs and Sheets) for:

- **Blog drafts** — Write in Google Docs. Share with CMO for review via Drive link. Apply SEO checklist before marking as ready.
- **Content calendar** — The master calendar lives in Google Sheets. Update your rows with status, published URLs, and performance notes.
- **Content tracking** — Log every piece in the tracking sheet: title, channel, status (draft/review/published), publish date, and link.

### Content Workflow Diagrams

Use `mermaid` to create:

- Editorial workflow diagrams showing the brief-to-publish pipeline.
- Content calendar visualizations for campaign planning sessions.
- Channel distribution flow charts showing how one piece of content gets repurposed across Instagram, TikTok, blog, and email.
