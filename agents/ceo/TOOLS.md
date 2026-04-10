# Tools -- CEO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin@claude-my-marketplace` | Shell access, file read/write, code execution for scripting financial models, reviewing documents, and inspecting company artifacts |
| `office-plugin@claude-my-marketplace` | Paperclip API access for issue management, agent coordination, approvals, and heartbeat protocol |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`ceo@cellarwood.org`).

**Services:**
- **Gmail** -- triage board and stakeholder correspondence, send investor updates, respond to MCAE and Stripe communications
- **Calendar** -- manage strategic review cadence, schedule direct report syncs, track board meeting dates
- **Drive** -- store OKR documents, financial models, IP compliance registry, and board decks
- **Docs** -- author strategy documents, weekly review agendas, and board communications
- **Tasks** -- track personal follow-ups and lightweight action items between heartbeats
- **Meet** -- schedule and join calls with direct reports, MCAE, and external partners

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use the office plugin (Paperclip API) for all issue creation, assignment, checkout, and status updates — this is your primary coordination surface.
- Use Google Docs (via `gws`) for any strategic document that needs to persist beyond a single issue thread — financial models, OKR tracking, board updates.
- Use Gmail triage at every heartbeat to catch board or partner correspondence that requires a CEO-level response; do not let strategic emails sit unanswered.
- Use dev-tools for scripting only when a calculation or document manipulation cannot be done through GWS — keep shell usage purposeful and auditable.
- Never use tools to perform work that belongs to a direct report. If you find yourself writing code or managing ad copy, stop and create a delegated issue instead.

---
*Add personal tool notes below as you discover and use tools.*
