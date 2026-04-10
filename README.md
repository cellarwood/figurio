# Figurio

A Paperclip Agent Company (`agentcompanies/v1`) for a direct-to-consumer e-commerce business selling high-quality full-color 3D-printed figurines.

## What is Figurio?

Figurio designs, produces, and delivers 3D-printed figurines through a web platform. Two product lines:

- **Catalog Figurines** ("Ready to Print") — curated, rotating collection of pre-designed figurines spanning viral/meme culture, seasonal themes, and evergreen collectibles
- **AI Custom Figurines** ("Prompt to Print") — customers describe a figurine in natural language, review an AI-generated 3D preview, and order a physical print

Production is outsourced to MCAE (mcae.cz) using Stratasys J55 PolyJet technology. Payments via Stripe. Shipping via Zasilkovna. Based in Czech Republic.

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

**9 agents** | **18 custom skills** | **18 subagents** | **95 GWS skills**

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React, TypeScript, shadcn-ui, Tailwind CSS, GSAP |
| Backend | Python, FastAPI, PostgreSQL, Stripe SDK |
| AI Pipeline | PyTorch, Meshy/Tripo3D/Luma, Blender, NetFabb |
| Infrastructure | Docker, Kubernetes (microk8s/GKE), Helm, Terraform, Traefik |
| CI/CD | GitHub Actions, Docker Hub |
| Monitoring | Sentry |

## Goals

1. **Launch the Figurio E-Commerce Platform** — storefront, backend API, production deployment
2. **Launch AI Custom Figurine Pipeline** — text-to-3D generation, mesh repair, QA review, customer preview
3. **Build Brand Presence and Acquire First Customers** — social media, campaigns, SEO
4. **Establish Production and Fulfillment Operations** — MCAE pricing/SLAs, Zasilkovna shipping integration

## Projects

| Project | Owner | Tasks |
|---------|-------|-------|
| `platform-backend` | Backend Engineer | 6 |
| `platform-frontend` | Frontend Engineer | 6 |
| `ai-pipeline` | ML/AI Engineer | 4 |
| `infrastructure` | DevOps Engineer | 4 |
| `marketing-launch` | Content Creator | 4 |

Plus 3 company-level strategic tasks.

## Importing Into Paperclip

### Via Paperclip UI/API

1. Push this repo to GitHub (`cellarwood/figurio`)
2. Import via Paperclip UI (Company Import page) or API:
   ```
   POST /companies/import
   { "source": { "type": "github", "url": "https://github.com/cellarwood/figurio" } }
   ```
3. The import handles: COMPANY.md, agent instruction bundles, projects, tasks, skills, .paperclip.yaml
4. Runtime files (settings.json, mcp.json, subagents) are deployed to agent workspaces

### Global Config (manual)

1. Copy `global/settings.json` and `global/plugins.json` into `.company/claude/` in the Paperclip repo root
2. Rebuild/restart the container

### Secrets Setup

Run `scripts/setup-secrets.sh` to configure required environment variables:
- `GH_TOKEN`, `DOCKER_HUB_USERNAME`, `DOCKER_HUB_TOKEN`
- `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`
- `DATABASE_URL`
- `GEMINI_API_KEY`, `ELEVENLABS_API_KEY`
- `SENTRY_DSN`, `MEDIA_OUTPUT_DIR`
- `GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE`

## Infrastructure

| Service | Value |
|---------|-------|
| Domain | cellarwood.org |
| GitHub | cellarwood/figurio |
| Docker Hub | lukekelle00 |
| Kubernetes | microk8s-local (dev), GKE (prod) |
| Stripe | Cellarwood |
| Slack | 00aiworkspace.slack.com |
| GWS | cellarwood.org |

## License

MIT
