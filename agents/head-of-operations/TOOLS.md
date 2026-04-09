# Tools — Head of Operations

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | PPTX presentations, DOCX documents, XLSX spreadsheets |
| `company-plugin` | Shipping logistics (Zasilkovna, DHL), payment processing (Stripe) |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| DHL API Assistant | `mcp__plugin_company-plugin_dhl-api-assistant` | DHL shipping rate queries, label creation, tracking |
| Stripe | `mcp__plugin_company-plugin_stripe` | Payment status, refund processing, transaction queries |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var.

**Services:** Gmail (send, read, reply, triage), Calendar (events, agenda), Drive, Docs, Sheets, Tasks.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use company-plugin for DHL shipping label creation and rate calculation for EU orders
- Use Stripe tools for checking payment status and processing refunds when needed
- Use office-plugin for vendor evaluation spreadsheets, fulfillment SOPs, and cost analysis reports
- Use Google Sheets for cost-per-unit tracking and margin analysis
- Use Google Workspace for MCAE communication and shipping partner coordination

---
*Add personal tool notes below as you discover and use tools.*
