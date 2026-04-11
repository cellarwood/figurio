# Tools -- Head of Operations

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Google Workspace access via the `gws` CLI -- Gmail, Drive, Docs, Sheets, Calendar, Tasks |
| `company-plugin` | Stripe MCP (payment events, refunds, disputes) and DHL API Assistant MCP (shipment creation, label generation, tracking) |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `plugin_company-plugin_stripe` | `mcp__plugin_company-plugin_stripe` | Query Stripe payment intents, monitor charge events, process refunds, retrieve dispute details |
| `plugin_company-plugin_dhl-api-assistant` | `mcp__plugin_company-plugin_dhl-api-assistant` | Create DHL shipments, generate shipping labels, track parcels, manage EU and international carrier handoffs |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`ops@cellarwood.org`).

**Services:** Gmail (vendor and carrier comms, order escalations), Google Sheets (SLA register, cost model, fulfillment cycle log), Google Docs (fulfillment SOPs, vendor contracts, packaging specs), Google Drive (print files, QA photos, agreements, packaging assets), Google Calendar (MCAE submission deadlines, QA windows, vendor review calls), Google Tasks (personal follow-up queue).

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use the Stripe MCP to confirm payment status before triggering any fulfillment action -- never ship against an unconfirmed payment.
- Use the DHL MCP for all EU and international label generation; do not generate DHL labels manually through the portal.
- Triage `ops@cellarwood.org` via `gws gmail` on every heartbeat -- MCAE and carrier messages require same-day response.
- Store all finalized SOPs, vendor agreements, and packaging specs in Google Drive under a consistent folder structure; link the Drive URL in the relevant Paperclip issue.
- Use Google Sheets for any data that needs version history or formula-based cost calculations -- do not store cost models in issue comments.

---
*Add personal tool notes below as you discover and use tools.*
