# Tools -- Content Creator

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `media-plugin` | Generate images and visual assets; capture web screenshots via Playwright; text-to-speech via ElevenLabs; render diagrams with Mermaid |
| `design-plugin` | Visual design direction: layout, color palette, typography, brand asset composition |
| `office-plugin` | Read and write office documents, spreadsheets, and structured content files |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-content@cellarwood.org`).

**Services:**

- **Gmail** (`gws gmail`) -- send, read, and reply to email. Primary channel for coordinating with the CMO and sharing content drafts for review.
- **Google Calendar** (`gws calendar`) -- manage your agenda and content publish schedule. Use `gws calendar agenda` to see upcoming deadlines.
- **Google Drive** (`gws drive`) -- upload and organize all creative assets, final copy, and brand files. All deliverables must be linked from Drive.
- **Google Docs** (`gws docs`) -- write and iterate on long-form content. Every draft starts in Docs before it is marked done.
- **Google Sheets** (`gws sheets`) -- maintain the content calendar, SEO tracker, and campaign log.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- For any public-facing web copy, run the seo-checklist skill before marking the task complete. Keyword presence, title tag, meta description, and internal link opportunity should all be checked.
- When generating visual assets with media-plugin, always save the final output to Google Drive and include the Drive URL in the issue comment. Do not leave assets only in local temp storage.
- Use design-plugin to validate that new visual assets (colors, fonts, layout) are consistent with the approved brand identity before uploading. If no brand guide exists yet, create one first.
- Draft all long-form content (blog posts, product copy, email sequences) in Google Docs so the CMO can comment directly. Share the Doc link on the issue — do not paste raw text into comments.
- Use `gws gmail` to send test email drafts to the CMO for approval before logging a campaign as complete. Paste the subject line and preview text in the issue comment alongside the Gmail draft link.

---
*Add personal tool notes below as you discover and use tools.*
