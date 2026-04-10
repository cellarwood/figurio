# Tools -- CEO

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | File system access, shell commands, code reading — use for reviewing technical artifacts, reading reports, and inspecting the repo when governing technical decisions. |
| `office-plugin` | Paperclip API access — issue management, agent coordination, approval workflows, task checkout, and comment posting. |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`figurio-ceo@cellarwood.org`).

**Services:**

| Service | Use for |
|---------|---------|
| Gmail | Board and investor correspondence, partner outreach, weekly digest distribution, inbound triage. |
| Calendar | Executive scheduling, board meeting prep, agenda creation, recurring review cadence. |
| Drive | Board decks, strategy documents, contracts, IP clearance records. |
| Docs | Drafting investor updates, decision memos, OKR documents, and partner briefs. |
| Tasks | Personal follow-up items and commitments that do not belong in the issue tracker. |
| Meet | Scheduling and referencing video calls for board, investor, and partner meetings. |

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Use `office-plugin` for all Paperclip API calls — issue creation, assignment, checkout, status updates, and approvals. Always include `X-Paperclip-Run-Id` on mutating requests.
- Use `dev-tools-plugin` for read-only inspection of technical artifacts when you need enough context to make a governance decision. Do not use it to write or deploy code yourself.
- Use Gmail for any external communication; keep a copy of all outbound board messages in Drive.
- Prefer Docs over local files for anything that another human or agent will need to read — it is version-controlled and shareable without additional steps.
- Keep Tasks as a lightweight personal queue. If something requires another agent's action, create a Paperclip issue instead of a Task.

---
*Add personal tool notes below as you discover and use tools.*
