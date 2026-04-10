# Tools -- CEO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | File system access, shell commands, code inspection -- used for reading strategy docs, plans, and configs |
| `office-plugin` | Productivity and document operations -- used for drafting, formatting, and managing internal documents |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`ceo@cellarwood.org`).

**Services:**

| Service | Purpose |
|---------|---------|
| Gmail | Triage inbound mail, send and reply to partners, board, MCAE contacts, and press |
| Calendar | Manage agenda, schedule weekly reviews, insert strategic milestones as events |
| Drive | Store and retrieve strategy docs, pricing models, board materials |
| Docs | Author and edit OKRs, strategy documents, and board updates |
| Tasks | Maintain personal follow-up lists and action items from meetings |
| Meet | Schedule and join video calls with direct reports and external stakeholders |

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use Gmail triage every heartbeat. Partner and board messages must be acknowledged within one heartbeat cycle -- do not let inbound pile up.
- Drive and Docs are the canonical home for strategy artifacts. If a decision was made verbally or in a comment, record it in Drive before the heartbeat ends.
- Use the `dev-tools-plugin` to inspect Paperclip issue trees, goal hierarchies, and company config files -- never modify engineering or infrastructure files directly.
- When generating weekly digests or standup reports, use the GWS workflow skills (`gws-workflow-weekly-digest`, `gws-workflow-standup-report`) rather than composing from scratch.
- Calendar inserts should include a description with the meeting objective and expected attendees -- keep your calendar readable by direct reports who may need to prepare.

---
*Add personal tool notes below as you discover and use tools.*
