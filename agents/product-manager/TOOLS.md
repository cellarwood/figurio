# Tools -- Product Manager

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `office-plugin@claude-my-marketplace` | Document creation, spreadsheet manipulation, and office productivity workflows; used for PRD authoring, roadmap tracking, and prioritization matrices |

## Google Workspace

Available via the `gws` CLI. Email configured via `AGENT_EMAIL` env var (`pm@cellarwood.org`).

**Services:**

| Service | Primary Use |
|---------|-------------|
| Gmail | Triage stakeholder requests; send PRD review requests; follow up on blocked decisions |
| Calendar | Schedule sprint planning and phase-gate reviews; read agenda before stakeholder syncs |
| Drive | Store and share PRDs, roadmap files, prioritization matrices |
| Docs | Author PRDs and user story documents; collaborate with CTO and CEO on review |
| Sheets | Maintain prioritization matrix (RICE scores), pricing test tracker, launch criteria checklist |
| Tasks | Personal follow-up list for open stakeholder decisions and pending approvals |

Run `gws --help` or `gws <service> --help` for CLI documentation.

## Usage Guidelines

- Every PRD must be a Google Doc stored in Drive with a stable share link posted to the linked issue. Do not keep PRDs only in issue comments.
- Use Sheets for any decision involving comparison across multiple features or options — a table in a Doc is not a substitute for a sortable, formula-driven prioritization matrix.
- When sending PRD review requests via Gmail, include the Doc link, the review deadline, and the specific question you need answered. Do not send open-ended "please review" emails.
- Use Calendar to create phase-gate review meetings at least one week in advance; attach the relevant roadmap doc or launch criteria checklist to the invite.
- Keep the Sheets prioritization matrix current. Score new requests before the next planning cycle, not during it.

---
*Add personal tool notes below as you discover and use tools.*
