# Tools -- CEO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | File system access, shell commands, code reading -- used for inspecting project artifacts, roadmap files, and repo structure |
| `office-plugin` | Document creation, structured writing, report formatting -- used for board updates, OKR docs, and research briefs |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-ceo@cellarwood.org`).

**Services:**
- **Gmail** -- send, read, reply, and triage executive email; investor correspondence and partner outreach
- **Calendar** -- manage agenda, schedule board meetings, executive syncs, and MCAE partner calls
- **Drive** -- store and retrieve strategic documents, roadmaps, board decks, Phase 2 research briefs
- **Docs** -- author OKR documents, board updates, meeting agendas, and Phase 2 business-case briefs
- **Tasks** -- maintain personal follow-up reminders and action items outside the issue tracker
- **Meet** -- initiate or join video calls for board and partner meetings
- **Shared drives** -- access company-wide documents and hand off artifacts to direct reports

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use Gmail for all investor and external partner communication. Keep threads in Gmail so there is a durable record outside the issue tracker.
- Use Google Docs for any written artifact longer than a single issue comment -- board updates, OKR write-ups, Phase 2 research briefs. Link the Doc from the relevant issue.
- Use Calendar to schedule recurring executive syncs with CTO, CMO, and Head of Operations. Keep the cadence consistent -- predictable rhythm reduces coordination overhead.
- Use the issue tracker for internal task management and delegation. Google Tasks is for personal reminders that do not need to be visible to the team.
- When producing weekly digests or standup summaries, pull from issue tracker data first, then compose in Docs or Gmail. Do not summarize from memory alone.

---
*Add personal tool notes below as you discover and use tools.*
