# Tools — CMO

## Plugins

### Office Plugin (`office-plugin@claude-my-marketplace`)

Create and manage documents for marketing operations:

- **Presentations (PPTX)** — Campaign pitch decks, quarterly marketing reviews, influencer partnership proposals, product launch plans.
- **Documents (DOCX)** — Campaign briefs, brand guidelines, marketing strategy documents, influencer outreach templates, press kits.
- **Spreadsheets (XLSX)** — Content calendars, campaign performance trackers, influencer databases, budget tracking, A/B test results.

### Media Plugin (`media-plugin@claude-my-marketplace`)

Generate visual and audio assets for marketing:

- **AI image generation** — Product mockups, social media graphics, campaign visuals, lifestyle imagery concepts, ad creative variations.
- **AI video generation** — Short-form video content, product reveal animations, social media video ads, story content.
- **Mermaid diagrams** — Campaign flowcharts, customer journey maps, content pipeline diagrams, funnel visualizations, seasonal campaign timelines.
- **Playwright browser automation** — Competitive research, social media monitoring, screenshot capture for inspiration boards, landing page audits.
- **ElevenLabs audio** — Voiceovers for video content, podcast intros, audio ads, branded sound bites.

### Design Plugin (`design-plugin@claude-my-marketplace`)

Maintain brand consistency across all marketing assets:

- **Style guides** — Define and enforce Figurio's visual identity: colors, typography, logo usage, photography style, illustration style.
- **Brand systems** — Component libraries for social media templates, email templates, and marketing collateral.

## MCP Servers and Permissions

The following MCP server tools are available to this agent:

| Permission | Server | Purpose |
|---|---|---|
| `mcp__plugin_media-plugin_mermaid` | Mermaid | Campaign diagrams, customer journey maps, funnel charts, content pipeline flows |
| `mcp__plugin_media-plugin_media-playwright` | Playwright | Browser automation for competitive research, social monitoring, landing page screenshots |
| `mcp__plugin_media-plugin_media-mcp` | Media MCP | AI-generated images, videos, music, and speech for marketing content |
| `mcp__plugin_media-plugin_ElevenLabs` | ElevenLabs | Text-to-speech for video voiceovers, audio ads, podcast content |

## Google Workspace

Full Google Workspace access is configured for marketing operations:

- **Email:** cmo@cellarwood.org
- **Domain:** cellarwood.org
- **Credentials:** /paperclip/.gws/figurio.json

Available GWS skills: `gws-gmail`, `gws-gmail-send`, `gws-gmail-read`, `gws-gmail-reply`, `gws-gmail-triage`, `gws-calendar`, `gws-calendar-agenda`, `gws-drive`, `gws-docs`, `gws-sheets`, `gws-forms`, `gws-shared`.

## Usage Guidelines

### When to use Media tools

- **Product mockups** — Generate lifestyle mockups of figurines in different settings (desk, shelf, gift box) for social media and website.
- **Social content** — Create eye-catching graphics, carousels, and video content for Instagram, TikTok, and Pinterest.
- **Campaign visuals** — Generate ad creative variations for A/B testing. Produce hero images for seasonal campaigns.
- **Voiceovers** — Use ElevenLabs for video narration, product description audio, and podcast-style content.

### When to use Design tools

- **Brand consistency** — Reference and update the Figurio style guide before creating any public-facing asset.
- **Template creation** — Build reusable templates for social posts, email headers, and product cards.
- **Visual identity audits** — Periodically review published content against brand guidelines for consistency.

### When to use Office tools

- **Campaign briefs** — Write structured campaign briefs as DOCX for Content Creator delegation.
- **Analytics reports** — Build campaign performance reports as PPTX for CEO reviews.
- **Content calendars** — Maintain the rolling content calendar as XLSX with tabs per month.
- **Budget tracking** — Track marketing spend and ROI in XLSX with formulas for CAC and ROAS calculations.

### When to use Mermaid diagrams

- **Campaign flowcharts** — Map out multi-channel campaign sequences.
- **Customer journey maps** — Visualize the path from discovery to purchase to repeat buy.
- **Content pipeline** — Diagram the content creation workflow from brief to publication.
- **Seasonal planning** — Timeline diagrams for seasonal campaign preparation milestones.
