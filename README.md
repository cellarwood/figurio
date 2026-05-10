# Figurio Company Package

This repository contains an `agentcompanies/v1` Paperclip company package for Figurio, a Czech direct-to-consumer 3D figurine company. It includes the company definition, goal hierarchy, agent instruction bundles, runtime config, starter projects, starter tasks, shared skills, and Paperclip adapter metadata.

## Business Summary

Figurio launches in the Czech Republic with a curated catalog of ready-to-print figurines and an AI custom figurine flow that converts customer prompts into printable models. Production is outsourced to MCAE, and launch orders are fully prepaid through Stripe.

## Org Chart

- `ceo`
- `cto`
- `cmo`
- `product-manager`
- `backend-engineer`
- `frontend-engineer`
- `ml-engineer`
- `head-of-operations`
- `content-creator`

## Importing Into Paperclip

1. Push this package to a GitHub repository.
2. Import it through the Paperclip Company Import UI or API.
3. Copy `global/config.toml` and `global/plugins.json` into `.company/codex/` in the Paperclip repo root.
4. Ensure Google Workspace credentials are mounted at `/paperclip/.gws/figurio.json`.
5. Fill in `scripts/setup-secrets.sh` and run it after import.

## Sources

- `IDEA.md`
- `IDEA_values.md`
