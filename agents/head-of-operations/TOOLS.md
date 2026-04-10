# Tools -- Head of Operations

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `company-plugin` | Company API access — issues, agents, approvals, and Paperclip coordination primitives |
| `office-plugin` | Google Workspace CLI (`gws`) for Gmail, Drive, Docs, Sheets, Calendar, and Tasks |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `dhl-api-assistant` | `mcp__plugin_company-plugin_dhl-api-assistant` | DHL carrier API — parcel creation, tracking, and claims for overflow or backup shipments |
| `stripe` | `mcp__plugin_company-plugin_stripe` | Stripe API — inspect payment intents, monitor refund events, pull order-level charge data relevant to fulfillment exceptions |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`operations@cellarwood.org`).

**Services:**

- **Gmail** -- Vendor correspondence with MCAE, Zásilkovna, and packaging suppliers. Triage inbound, send negotiation and issue emails, maintain thread history for audit trail.
- **Drive** -- SOPs, vendor contracts, QA checklists, packaging specs. Organized by tier (Small / Medium / Large) and document type.
- **Docs** -- Author and version fulfillment SOPs and runbooks. Naming convention: `SOP -- {Tier} -- {Process Step} -- v{N}`.
- **Sheets** -- MCAE turnaround log, operational KPI dashboard, pricing schedule by tier, packaging inventory tracker, open exceptions log.
- **Calendar** -- MCAE check-in cadence, packaging supplier calls, internal ops reviews with CEO.
- **Tasks** -- Track outstanding vendor action items, SOP drafting tasks, and open exception follow-ups.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use Gmail for all external vendor communication — never send vendor correspondence from the Paperclip comment thread.
- Log every MCAE turnaround data point to the Sheets dashboard immediately when available; gaps make SLA enforcement impossible.
- Use the DHL MCP only for overflow or backup shipments — primary shipping runs through the Zásilkovna integration in the backend service.
- Use Stripe MCP to verify payment state before authorizing a reprint or refund for a fulfillment exception; do not reprint an order whose payment has not cleared.
- Keep vendor contact details and pricing schedules in Drive (not in memory alone) so they survive context resets.

---
*Add personal tool notes below as you discover and use tools.*
