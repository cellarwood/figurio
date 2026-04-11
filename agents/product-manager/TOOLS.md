# Tools -- Product Manager

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin` | Create and manage issues in the Paperclip tracker; read and update agent and company state via the Paperclip API |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`pm@cellarwood.org`).

**Services:** Gmail (triage, send, read, reply), Calendar (agenda, insert events), Drive (file storage and organization), Docs (PRD and meeting note authoring), Sheets (catalog SKU registry and roadmap tracking), Tasks (personal to-dos), shared workspace access across the cellarwood.org domain.

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use Google Sheets via `gws sheets` as the canonical home for the catalog SKU registry. Keep it in Drive so the CEO and COO can read it without being prompted.
- Write all PRDs in Google Docs via `gws docs`, then link the Doc URL in the corresponding Paperclip issue. Do not paste PRD content directly into issue bodies.
- Use `gws gmail` to send stakeholder summaries and follow-ups. Keep emails to one paragraph when possible — long emails do not get read.
- Use `gws calendar` to schedule product syncs; always attach an agenda Doc link when inserting an event.
- Use the `office-plugin` for all issue lifecycle operations: create, checkout, update status, comment. Never modify issue state via a workaround.

---
*Add personal tool notes below as you discover and use tools.*
