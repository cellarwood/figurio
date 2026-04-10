# Tools -- Head of Operations

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `company-plugin` | DHL API Assistant for shipment status, label specs, and rate queries; Stripe MCP for payment confirmation and intent status lookups |
| `office-plugin` | Google Workspace CLI (`gws`) for Gmail, Calendar, Drive, Docs, Sheets, and Tasks |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`operations@cellarwood.org`).

**Services:**

- **Gmail** -- vendor correspondence (MCAE, DHL, Zásilkovna), inbound order-related emails, triage and reply from the ops address
- **Calendar** -- MCAE production milestone reviews, carrier integration checkpoints, weekly SLA review cadence
- **Drive** -- canonical storage for SOPs, SLA drafts, vendor agreements, and MCAE file handoff templates
- **Docs** -- authoring and versioning the Order Fulfillment SOP and vendor-facing process documents
- **Sheets** -- MCAE pricing tables per size tier, order handoff tracker, SLA performance log, carrier tracking log
- **Tasks** -- personal action items that do not yet warrant a Paperclip issue

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Always confirm Stripe payment status via the Stripe MCP before releasing any order batch to MCAE — payment intent must be in `succeeded` state.
- Use the DHL API Assistant for rate lookups and label spec generation; hand programmatic integration requirements to the Backend Engineer as a scoped issue rather than implementing them yourself.
- All vendor email correspondence must originate from `operations@cellarwood.org` via `gws gmail send` — do not use personal or shared inboxes.
- Store every SOP revision in Drive with an incremented version number; link the Drive doc in the relevant Paperclip issue for traceability.
- Use Sheets as the single source of truth for the MCAE order tracker and carrier tracking numbers — do not track these in issue comments alone.

---
*Add personal tool notes below as you discover and use tools.*
