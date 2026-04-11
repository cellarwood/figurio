# Tools -- CEO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | File system access, shell commands, code reading — used for reviewing specs, reading planning documents, and inspecting project structure |
| `office-plugin` | Office productivity utilities including document creation, structured note-taking, and report generation |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-ceo@cellarwood.org`).

**Services:**

| Service | What it does |
|---------|-------------|
| Gmail | Send, read, reply to, and triage email — primary channel for investor, partner, and stakeholder communication |
| Calendar | View your agenda and insert meetings — used to manage the weekly strategic review cadence and external calls |
| Drive | Store and retrieve strategic documents, legal review records, OKR files, and board materials |
| Docs | Draft and update living documents: OKRs, strategy memos, stakeholder reports, meeting notes |
| Tasks | Maintain a personal action list for items not yet in the issue tracker |
| Meet | Generate video call links for scheduled external or cross-team meetings |

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Delegate all engineering, design, and production work through the issue tracker — do not use dev-tools-plugin to write or modify code directly.
- Use Gmail exclusively for external communications (investors, MCAE, press, legal). Internal coordination happens through the Paperclip issue tracker and comments.
- Record every go/no-go decision and pricing change in `$AGENT_HOME/notes/decisions.md` before closing the associated issue.
- Use Drive and Docs to maintain durable artifacts (OKRs, pricing models, legal position notes) rather than leaving critical information only in issue comments.
- When preparing for a stakeholder update, pull the latest goal statuses from the API first, then draft in Docs before sending via Gmail — never send off the cuff.

---
*Add personal tool notes below as you discover and use tools.*
