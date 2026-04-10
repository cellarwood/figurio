# Figurio

A Paperclip Agent Company package for **Figurio** — a Czech Republic-based direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines.

## Product Lines

- **Catalog Figurines** — curated, rotating collection of pre-designed 3D figurines (viral, seasonal, collectible)
- **AI-Prompted Custom Figurines** — customers describe a figurine in natural language, AI generates a 3D model for approval
- **Scan-to-Print** (Phase 2) — personalized figurines from 3D body scans at events and pop-ups

## Org Chart

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   └── DevOps Engineer
├── CMO
│   ├── Content Creator
│   └── UI Designer
└── Head of Operations
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React, TypeScript, shadcn-ui, Tailwind CSS, Three.js |
| Backend | Python, FastAPI, PostgreSQL, async SQLAlchemy |
| AI Pipeline | Text-to-3D (Meshy/Tripo3D), automated mesh repair |
| Payments | Stripe (cards, Apple Pay, Google Pay, SEPA) |
| Infrastructure | Docker, Kubernetes (microk8s), Terraform, Traefik |
| CI/CD | GitHub Actions, Docker Hub |
| Monitoring | Sentry, Prometheus |

## Company Goals

1. Launch MVP e-commerce platform with catalog and AI-prompted custom figurines
2. Establish supply chain and fulfillment pipeline with MCAE printing partner
3. Validate market strategy through competitive analysis and pricing model
4. Build Figurio brand and acquire first 100 paying customers

## Projects

| Project | Owner | Description |
|---------|-------|-------------|
| `mvp-backend` | Backend Engineer | FastAPI backend with catalog, orders, AI generation, Stripe |
| `mvp-frontend` | Frontend Engineer | React storefront with catalog, AI prompt, checkout |
| `infrastructure` | DevOps Engineer | Docker, K8s, CI/CD, monitoring |
| `operations` | Head of Operations | MCAE partnership, fulfillment, shipping |
| `brand-launch` | Content Creator | Brand identity, content, marketing channels |

## Importing Into Paperclip

### Via Paperclip UI/API

1. Push this package to a GitHub repo
2. Import via Paperclip UI (Company Import page) or API: `POST /companies/import` with `source.type: "github"`
3. The import handles all files: COMPANY.md, agent bundles, projects, tasks, skills, .paperclip.yaml

### Global Config (manual)

1. Copy `global/settings.json` and `global/plugins.json` into `.company/claude/` in the Paperclip repo root
2. Rebuild/restart the container

## Infrastructure

| Service | Value |
|---------|-------|
| Domain | cellarwood.org |
| Google Workspace | cellarwood.org |
| GitHub | cellarwood/figurio |
| Docker Hub | lukekelle00 |
| Slack | 00aiworkspace.slack.com |
| Stripe | Cellarwood |
| K8s | microk8s-local |

## License

MIT
