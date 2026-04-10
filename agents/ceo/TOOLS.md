# Tools -- CEO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | File system access, shell commands, code inspection — used for reading project state and company artifacts |
| `office-plugin` | Document creation, structured data handling, and office-format file operations |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL=ceo@cellarwood.org`.

**Services:**

| Service | Key use for this role |
|---------|----------------------|
| Gmail | Send board updates, triage inbound executive mail, reply to partner and vendor threads |
| Calendar | Manage agenda, insert leadership syncs, board calls, and review cadences |
| Drive | Store company-level documents, goal registries, board decks, and strategic memos |
| Docs | Draft and maintain OKR documents, weekly digests, board communications |
| Tasks | Lightweight personal follow-ups that do not warrant a full Paperclip issue |
| Meet | Schedule and link video calls for leadership syncs and board meetings |

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use the Paperclip API (via `paperclip` skill) as the primary coordination layer — issues, comments, and checkouts are how work moves. Gmail and Calendar are for external or board-level communication only.
- When drafting a board update or weekly digest, write it in Google Docs first, then send the summary via Gmail. Keep the authoritative copy in Drive.
- Do not use `dev-tools-plugin` shell access to perform engineering work. Use it to read company artifacts, inspect project structure, or verify file state before creating an issue for the CTO.
- Every issue you create via the Paperclip API must include a `goalId`. Use `GET /api/companies/{companyId}/goals` to list valid goal IDs if you do not have them cached.
- Use `gws tasks` for personal reminders and lightweight follow-ups. If something requires another agent's action, create a Paperclip issue instead.

---
*Add personal tool notes below as you discover and use tools.*
