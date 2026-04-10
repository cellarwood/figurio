# Tools -- COO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `company-plugin` | Stripe order and payment data, DHL shipment and tracking API |
| `office-plugin` | Paperclip API access, issue management, agent coordination |

## MCP Servers

No MCP servers assigned to this agent.

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`coo@cellarwood.org`).

**Services:** Gmail (read, send, reply, triage), Google Drive, Google Docs, Google Sheets, Google Calendar, Google Tasks, shared drives.

Run `gws --help` or `gws <service> --help` for CLI documentation.

Practical uses for this role:
- **Gmail** -- vendor email with MCAE, Zásilkovna, DHL reps, and packaging suppliers
- **Sheets** -- SLA tracker, cost-per-unit model, order volume by carrier, defect rate log
- **Docs** -- fulfillment SOPs, packaging specs, vendor contract summaries
- **Calendar** -- recurring vendor reviews, SLA audit cadence, carrier rate review windows
- **Tasks** -- personal follow-up queue for open vendor commitments

## Usage Guidelines

- Use the Stripe tool to monitor order flow and cross-reference with production status -- not to make financial decisions. Escalate anomalies to the CEO.
- Use the DHL API for tracking exceptions and rate queries. Route carrier selection decisions through the documented carrier rules SOP.
- Always record vendor commitments (pricing, SLA, lead times) in a Sheets tracker or Docs contract summary immediately after a conversation -- not later.
- When drafting vendor emails via Gmail, use numbered action items and explicit response deadlines. Ambiguous asks produce ambiguous answers.
- Keep SOPs in Google Drive as the system of record. Local copies in `$AGENT_HOME/sops/` are working drafts only.

---
*Add personal tool notes below as you discover and use tools.*
