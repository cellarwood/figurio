# Tools -- CEO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | File system access, shell commands, code inspection — used for reading project artifacts, configs, and status files |
| `office-plugin` | Document creation, structured report generation, and office-format output for board and stakeholder communications |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`ceo@cellarwood.org`).

**Services:** Gmail (send, read, reply, triage), Google Calendar (agenda view, event insertion), Google Drive (file storage and sharing), Google Docs (document creation and editing), Google Tasks (personal task lists), Google Meet (meeting scheduling and links), Shared workspace resources (team drives, shared calendars).

Run `gws --help` or `gws <service> --help` for CLI documentation.

Pre-packaged workflow skills:
- `gws-workflow-meeting-prep` -- pull agenda, attendees, and relevant docs before a scheduled meeting
- `gws-workflow-standup-report` -- compile a standup-style update from recent issue activity
- `gws-workflow-weekly-digest` -- assemble the weekly board digest from direct report summaries

## Usage Guidelines

- Use `office-plugin` for board digests and formal documents; use `gws docs` to store and share them with the board via Drive.
- Use `gws gmail` to communicate with external parties (MCAE vendor contacts, board members, launch partners) — do not use internal Paperclip comments for outbound external email.
- Use `gws calendar` to schedule and track weekly strategic review meetings with direct reports; insert events with Meet links so remote attendance is always available.
- Use `dev-tools-plugin` to inspect project-root artifacts (OKR files, roadmap documents, config) when preparing strategic reviews — read the source of truth, do not rely on memory alone.
- Reserve `gws tasks` for personal CEO to-dos that are not yet formal Paperclip issues; graduate them to issues once they have an owner and a deadline.

---
*Add personal tool notes below as you discover and use tools.*
