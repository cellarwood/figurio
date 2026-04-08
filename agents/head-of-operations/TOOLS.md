# Tools — Head of Operations

## Plugins

### office-plugin

Provides access to Google Workspace document creation and editing tools.

- **Docs** — Create and maintain fulfillment SOPs, vendor contract summaries, packaging specifications, and process documentation.
- **Sheets** — Build and update cost tracking spreadsheets, order pipeline dashboards, margin analysis workbooks, and fulfillment metrics reports.
- **Slides** — Prepare vendor review presentations and operational reports for CEO.

### company-plugin

Provides access to company-specific integrations for shipping and payments.

- **Zasilkovna (via DHL API Assistant)** — Generate shipping labels for Czech Republic domestic orders, track parcels, manage pickup point selection, and monitor delivery status.
- **DHL API Assistant** — Create EU shipment labels, generate tracking numbers, monitor delivery progress, and handle shipping exceptions.
- **Stripe** — Verify payment status for orders, reconcile captured payments against fulfilled orders, process refunds for defective or lost shipments, and pull order data for cost analysis.

## MCP Servers

| Server | Permission | Use Case |
|---|---|---|
| DHL API Assistant | `mcp__plugin_company-plugin_dhl-api-assistant` | Shipping label generation, parcel tracking, delivery status monitoring for both Zasilkovna and DHL shipments |
| Stripe | `mcp__plugin_company-plugin_stripe` | Payment verification, order data retrieval, refund processing, revenue reconciliation |

## Google Workspace

Access via the company Google Workspace account.

- **Email:** operations@cellarwood.org
- **Credentials:** `/paperclip/.gws/figurio.json`
- **Domain:** cellarwood.org

Available GWS tools:

| Tool | Primary Use |
|---|---|
| Gmail (send, read, reply, triage) | MCAE correspondence, shipping provider communication, packaging supplier outreach |
| Calendar (agenda) | Vendor meeting scheduling, SLA review cadences, production planning milestones |
| Drive | Shared document storage for SOPs, contracts, and specifications |
| Docs | Fulfillment SOPs, vendor terms documentation, packaging specs |
| Sheets | Cost tracking, margin analysis, order pipeline dashboards, fulfillment metrics |
| Tasks | Action item tracking across the fulfillment pipeline |

## Usage Guidelines

- **Shipping labels:** Use the company plugin's DHL API Assistant for all shipping label generation. Always verify the shipping address against the order record in Stripe before generating a label.
- **Payment verification:** Use the company plugin's Stripe integration to confirm payment capture before submitting any print file to MCAE. Never submit a print job for an unpaid order.
- **Fulfillment tracking:** Maintain a master fulfillment tracking spreadsheet in Google Sheets. Update it every heartbeat cycle with current order statuses, turnaround times, and cost data.
- **SOP documents:** Store all SOPs in Google Docs with version history enabled. Link SOPs from the fulfillment tracking sheet for easy reference.
- **Vendor communication:** All MCAE communication goes through Gmail (operations@cellarwood.org). Log key data points (quoted prices, agreed SLAs, capacity commitments) in the vendor terms document after every interaction.
- **Cost analysis:** Use Sheets to maintain per-unit cost breakdowns by size tier. Pull Stripe transaction data and shipping costs to calculate actual margins. Report to CEO when margins shift by more than 5%.
