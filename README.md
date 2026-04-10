# Figurio

A Paperclip Agent Company (`agentcompanies/v1`) for a direct-to-consumer e-commerce business selling high-quality full-color 3D-printed figurines.

## What is Figurio?

Figurio designs, produces, and delivers 3D-printed figurines from the Czech Republic. Two product lines:

- **Catalog Figurines** — curated, pre-designed figurines available for immediate order
- **AI Custom Figurines ("Prompt to Print")** — customers describe a figurine in natural language, AI generates a 3D model, customer approves a preview, then it prints

All production is outsourced to MCAE (mcae.cz) using Stratasys J55 PolyJet technology. Orders are prepaid via Stripe.

## Org Chart

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   ├── ML/AI Engineer
│   └── DevOps Engineer
├── CMO
│   └── Content Creator
└── Head of Operations
```

**9 agents** | **~$980/mo total budget**

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React, TypeScript, shadcn-ui, Tailwind CSS, Three.js |
| Backend | Python, FastAPI, PostgreSQL, Stripe SDK |
| AI Pipeline | Meshy/Tripo3D APIs, Blender scripting, PyTorch |
| Infrastructure | Docker, Kubernetes (microk8s), Helm, Traefik |
| CI/CD | GitHub Actions |
| Payments | Stripe |
| Shipping | Zasilkovna (CZ), DHL (EU) |

## Projects

| Project | Owner | Description |
|---------|-------|-------------|
| mvp-backend | Backend Engineer | FastAPI API with catalog, orders, Stripe, AI pipeline |
| mvp-frontend | Frontend Engineer | React storefront with catalog, cart, checkout, 3D preview |
| infrastructure | DevOps Engineer | Docker, K8s, CI/CD, monitoring |
| brand-and-marketing | Content Creator | Brand identity, content, social media, SEO |
| operations-setup | Head of Operations | MCAE partnership, fulfillment, shipping |

## Importing Into Paperclip

### Via Paperclip UI/API

1. Push this package to GitHub
2. Import via Paperclip UI (Company Import page) or API:
   ```
   POST /companies/import
   ```
   with `source.type: "github"` pointing to this repo
3. The import handles all files: COMPANY.md, agents, projects, tasks, skills, .paperclip.yaml
4. Runtime files (settings.json, mcp.json, subagents) are deployed to agent workspaces

### Global Config (manual)

1. Copy `global/settings.json` and `global/plugins.json` into `.company/claude/` in the Paperclip repo root
2. Rebuild/restart the container

### Secrets Setup

Run the generated script to configure required secrets:

```bash
bash scripts/setup-secrets.sh
```

Required secrets: `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `GH_TOKEN`, `DOCKER_HUB_USERNAME`, `DOCKER_HUB_TOKEN`, `DATABASE_URL`, `GEMINI_API_KEY`

## Infrastructure

| Service | Value |
|---------|-------|
| GitHub | cellarwood/figurio |
| Docker Hub | lukekelle00 |
| K8s Cluster | microk8s-local |
| Domain | cellarwood.org |
| GWS Domain | cellarwood.org |
| Slack | 00aiworkspace.slack.com |
| Stripe | Cellarwood |

## License

MIT
