# Tools -- Head of Operations

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `company-plugin` | Stripe MCP for payment operations; DHL API Assistant for EU shipping label generation and tracking |
| `office-plugin` | Google Workspace access via `gws` CLI (Gmail, Calendar, Drive, Docs, Sheets, Tasks) |

## MCP Servers

No dedicated MCP servers are configured for this agent. Stripe and DHL capabilities are delivered through `company-plugin` permissions listed below.

**Allowed MCP permissions:**

| Permission | What it does |
|-----------|-------------|
| `mcp__plugin_company-plugin_stripe` | Stripe API access -- list/create refunds, retrieve disputes, submit dispute evidence, retrieve payout data |
| `mcp__plugin_company-plugin_dhl-api-assistant` | DHL API access -- generate EU shipping labels, retrieve tracking events, manage shipment records |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-ops@cellarwood.org`).

**Services:** Gmail (send, read, reply, triage), Calendar (agenda, event management), Drive (file storage and retrieval), Docs (document authoring), Sheets (data tracking and reporting), Tasks (action item management), shared Drive access.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use Google Sheets as the system of record for MCAE pricing tiers, SLA performance logs, and shipping rate comparisons -- keep them current after every vendor interaction.
- When generating DHL shipment labels via the DHL API Assistant, always record the tracking number against the Figurio order ID before closing the task.
- Use Stripe MCP for all refund and dispute operations -- never process payment actions through any other interface.
- Zasilkovna (CZ/SK parcels) is managed via its own API outside the DHL tool -- document Zasilkovna API credentials and endpoint notes in `$AGENT_HOME/notes/zasilkovna.md`.
- Vendor correspondence (MCAE, DHL, packaging suppliers) goes through Gmail at figurio-ops@cellarwood.org; store agreed terms and contract attachments in a dedicated Google Drive folder, not in email threads alone.

---
*Add personal tool notes below as you discover and use tools.*
