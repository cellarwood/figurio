# Figurio

Figurio is a Paperclip company package for a Czech direct-to-consumer brand focused on premium full-color 3D-printed figurines. It covers a curated catalog launch, an AI-assisted custom figurine workflow, outsourced production through MCAE, and the operational and marketing systems needed to take the company to market.

## What This Package Contains

- `COMPANY.md` with `agentcompanies/v1` company metadata and measurable goals
- `agents/` with role definitions, operating instructions, runtime config, and subagents
- `goals/`, `projects/`, and `tasks/` generated from the confirmed launch plan
- `skills/` with custom company skills and imported Google Workspace skills
- `global/` with shared Codex plugin bootstrap files
- `.paperclip.yaml` with budgets and environment inputs

## Org Chart

- `ceo` -> overall strategy, launch decisions, partnerships
- `cto` -> platform architecture and technical execution
- `product-manager` -> requirements, workflow design, launch coordination
- `backend-engineer` -> APIs, order lifecycle, Stripe, custom pipeline backend
- `frontend-engineer` -> storefront, approval flows, order UI
- `qa-engineer` -> regression coverage and release confidence
- `cmo` -> brand, campaigns, growth loops
- `content-creator` -> product content, SEO, social assets
- `head-of-operations` -> supplier coordination, shipping, service levels
- `customer-support` -> support handling, escalation, customer trust

## Source Context

This package was generated from the business concept and infrastructure assumptions in:

- [IDEA.md](./IDEA.md)
- [IDEA_values.md](./IDEA_values.md)

## Importing Into Paperclip

### 1. Import via Paperclip UI or API

1. Push this package to a GitHub repository.
2. Import it through the Paperclip Company Import UI or `POST /companies/import` with `source.type: "github"`.
3. Let Paperclip ingest `COMPANY.md`, the agent bundles, goals, projects, tasks, skills, and `.paperclip.yaml`.
4. Verify that runtime files under `agents/*/runtime/` are deployed into the agent workspaces.

### 2. Use the Global Config Manually

1. Copy `global/config.toml` and `global/plugins.json` into `.company/codex/` at the Paperclip repo root.
2. Ensure the required secrets and plain env vars from `.paperclip.yaml` are configured in the target environment.
3. Rebuild or restart the container so Codex picks up the company configuration.

## Deployment Notes

1. Run `scripts/setup-secrets.sh` and provide the required credentials.
2. Confirm Google Workspace credentials are mounted at `/paperclip/.gws/figurio.json`.
3. Verify Stripe secrets, GitHub token, and Docker Hub credentials are available.
4. Run the Paperclip import flow.
5. After import, smoke-test plugin access, Google Workspace access, and the generated agent runtime configs.
