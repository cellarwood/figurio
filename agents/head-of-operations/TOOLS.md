# Tools -- Head of Operations

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `company-plugin` | Provides access to Stripe and DHL API Assistant MCP servers for payment monitoring and shipment management |
| `office-plugin` | Provides Google Workspace access via the `gws` CLI for email, calendar, documents, sheets, and tasks |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `dhl-api-assistant` | `mcp__plugin_company-plugin_dhl-api-assistant` | Generate DHL shipping labels, track parcels in transit, and pull delivery confirmations |
| `stripe` | `mcp__plugin_company-plugin_stripe` | Monitor payments, check for disputes or failed charges, and initiate refunds linked to order exceptions |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-ops@cellarwood.org`).

**Services:**
- **Gmail** -- send, read, reply to, and triage vendor and customer emails.
- **Calendar** -- manage MCAE batch submission schedules and QC windows.
- **Drive** -- store SOPs, packaging specs, carrier agreements, and batch records.
- **Docs** -- author and maintain fulfillment runbooks.
- **Sheets** -- maintain the live order tracking sheet, MCAE turnaround log, and carrier rate comparison.
- **Tasks** -- track personal follow-up items that do not yet warrant a Paperclip issue.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Always include an order ID or batch ID in DHL API calls and in any email sent to MCAE or a carrier -- traceability is non-negotiable.
- Use the Stripe MCP in read-only mode by default; only initiate a refund when there is a corresponding Paperclip issue approved by the CEO.
- Log every outbound email from figurio-ops@cellarwood.org as a comment on the relevant Paperclip issue before exiting the heartbeat.
- Maintain the order tracking Google Sheet as the single source of truth for pipeline status -- do not duplicate state across multiple documents.
- When using the DHL API to generate labels, save the label PDF to the Figurio Operations folder in Drive and link it in the issue comment.

---
*Add personal tool notes below as you discover and use tools.*
