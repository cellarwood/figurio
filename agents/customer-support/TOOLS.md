# Tools -- Customer Support

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Read and write Google Docs and Sheets; maintain FAQ document and support log spreadsheet |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`support@cellarwood.org`).

**Services:** Gmail (read, send, reply, reply-all, forward, triage), Google Docs (FAQ authoring and maintenance), Google Sheets (support issue log, CSAT tracking), Google Calendar (follow-up scheduling and reminders), Shared Drive (evidence attachments, print quality photos).

Run `gws --help` or `gws <service> --help` for CLI documentation.

Key workflows:
- `gws gmail triage` -- scan and categorize new inbound messages
- `gws gmail reply <message-id>` -- reply to a specific message thread
- `gws gmail send` -- compose and send a new outbound message
- `gws docs edit <doc-id>` -- update the customer FAQ
- `gws sheets append <sheet-id>` -- log new support entries or CSAT scores

The `gws-workflow-email-to-task` skill converts an inbound support email directly into a Paperclip issue. Use this for any new customer request that needs tracking.

## Usage Guidelines

- Always look up the order ID and tracking status before replying to order or shipping questions — never ask the customer for information you could retrieve yourself.
- When creating Paperclip escalation issues, include a `parentId` pointing to the originating customer support issue so the chain is traceable.
- Use Google Sheets to maintain a running support log: one row per ticket, columns for date, customer email, issue type, status, escalation target, and resolution date.
- Store print quality complaint photos and customer-submitted reference files in Shared Drive, linked from the Paperclip issue — do not attach large files directly to issue comments.
- Use Google Calendar to set follow-up reminders on any escalated or blocked issue so no ticket goes silent past 48 hours.

---
*Add personal tool notes below as you discover and use tools.*
