# Figurio

A Paperclip company package (`agentcompanies/v1`) for Figurio — a direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines.

## Product Lines

- **Catalog Figurines** — curated, rotating catalog of pre-designed figurines (seasonal, viral, collectible)
- **AI Custom Figurines** — describe a figurine in natural language, AI generates a 3D model, automated mesh repair, customer preview and approval
- **Scan-to-Print (Phase 2)** — 3D scanning at events and pop-ups for personalized figurines

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React, TypeScript, shadcn-ui, Tailwind CSS, Three.js |
| Backend | Python, FastAPI, SQLAlchemy, Alembic, Celery, Redis |
| Infrastructure | Docker, Kubernetes (microk8s), Traefik, GitHub Actions |
| Payments | Stripe |
| AI Pipeline | Text-to-3D (Meshy/Tripo3D), Blender mesh repair |
| Shipping | Zasilkovna (CZ/SK), DHL (EU) |
| Production | MCAE (Stratasys J55 PolyJet) |

## Organization

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   └── DevOps Engineer
├── CMO
│   └── Content Creator
└── Head of Operations
```

**8 agents** | **5 projects** | **34 tasks** | **5 goals** | **16 custom skills** | **20 subagents**

## Projects

| Project | Owner | Description |
|---------|-------|-------------|
| platform-backend | Backend Engineer | FastAPI API with catalog, orders, Stripe, AI pipeline |
| platform-frontend | Frontend Engineer | React storefront with catalog, checkout, 3D preview |
| infrastructure | DevOps Engineer | Docker, K8s, CI/CD, monitoring |
| operations | Head of Operations | MCAE vendor management, shipping, packaging |
| marketing | Content Creator | Brand identity, content, SEO, social media |

## Importing Into Paperclip

### Via Paperclip UI/API

1. Push this package to GitHub (`cellarwood/figurio`)
2. Import via Paperclip UI (Company Import page) or API:
   ```
   POST /companies/import
   { "source": { "type": "github", "repo": "cellarwood/figurio" } }
   ```
3. The import handles all files: COMPANY.md, agents, projects, tasks, skills, .paperclip.yaml

### Global Config (manual)

1. Copy `global/settings.json` and `global/plugins.json` into `.company/claude/` in the Paperclip repo root
2. Rebuild/restart the container

### Secrets Setup

Run the generated setup script for required environment variables:
```bash
bash scripts/setup-secrets.sh
```

Required secrets: `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `GH_TOKEN`, `DOCKER_HUB_USERNAME`, `DOCKER_HUB_TOKEN`, `DATABASE_URL`, `GEMINI_API_KEY`

## Infrastructure

| Service | Value |
|---------|-------|
| Domain | cellarwood.org |
| GitHub | cellarwood/figurio |
| Docker Hub | lukekelle00 |
| K8s Context | microk8s-local |
| Slack | 00aiworkspace.slack.com |
| Stripe | Cellarwood |
| GWS | cellarwood.org |

## License

MIT
