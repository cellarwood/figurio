# Tools -- HeadOfOperations

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `company-plugin@claude-my-marketplace` | Provides MCP-backed access to company integrations: Stripe payment data and DHL shipping API |
| `office-plugin@claude-my-marketplace` | Provides Google Workspace access via the `gws` CLI for Gmail, Calendar, Drive, Docs, Sheets, and Tasks |

## MCP Tool Permissions

The following MCP tools are permitted for this agent:

| Tool | Permission String | What it does |
|------|------------------|-------------|
| DHL API Assistant | `mcp__plugin_company-plugin_dhl-api-assistant` | Creates DHL shipments, generates labels, and retrieves tracking status for EU orders |
| Stripe | `mcp__plugin_company-plugin_stripe` | Queries payment intents, captured charges, and customer records for reconciliation and order verification |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-ops@cellarwood.org`). Credentials at `GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE`.

**Services:**

- **Gmail** -- vendor correspondence with MCAE, courier partners, and packaging suppliers; inbound triage; sending operational updates
- **Calendar** -- MCAE pickup windows, DHL/Zásilkovna cut-off times, packaging lead time reminders, recurring operational checkpoints
- **Drive** -- storing and sharing SOPs, pricing sheets, vendor agreements, and fulfillment trackers
- **Docs** -- authoring and maintaining the order-to-print SOP and vendor onboarding guides
- **Sheets** -- MCAE pricing and SLA tracker, packaging inventory tracker, Stripe reconciliation log
- **Tasks** -- personal operational to-dos that don't yet warrant a Paperclip issue

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use the Stripe MCP to pull payment data; never ask engineering to run ad-hoc queries for reconciliation checks you can do yourself.
- Use the DHL API assistant for EU label generation; document each label in the fulfillment tracker (Google Sheets) immediately after creation, not in batch at end of day.
- All vendor commitments confirmed via Gmail must be copied into the relevant Google Sheet within the same heartbeat -- email threads are not a record system.
- When drafting vendor emails via `gws gmail`, always reference specific order numbers, size tiers, agreed prices, and deadlines in the body; never send vague follow-ups.
- Use Google Calendar to set reminders for every SLA deadline and vendor lead-time milestone -- operational memory must not live only in your working context.

---
*Add personal tool notes below as you discover and use tools.*
