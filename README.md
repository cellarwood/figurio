# Figurio

A Paperclip company package (`agentcompanies/v1`) for a direct-to-consumer e-commerce platform selling high-quality full-color 3D-printed figurines.

## What Figurio Does

Figurio designs, produces, and delivers 3D-printed figurines through a web platform. Three product lines:

1. **Catalog Figurines** — curated collection of trending, seasonal, and collectible designs
2. **AI Custom Figurines** — customers describe a figurine in natural language, get a 3D preview, approve, and order
3. **Scan-to-Print** (Phase 2) — photogrammetry scanning at events for personalized figurines

All production is outsourced to MCAE (mcae.cz) using Stratasys J55 PolyJet technology. Orders are prepaid via Stripe.

## Org Chart

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   └── DevOps Engineer
├── CMO
│   └── Content Creator
├── COO
└── Product Manager
```

**9 agents** | **$860/mo total budget**

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React/TypeScript, shadcn-ui, Tailwind CSS, Vite |
| Backend | Python/FastAPI, PostgreSQL, Stripe SDK, uv |
| Infrastructure | Docker, Kubernetes (microk8s), Traefik, GitHub Actions |
| AI Pipeline | Text-to-3D APIs (Meshy, Tripo3D), automated mesh repair |
| Monitoring | Sentry |

## Company Goals

1. Launch MVP e-commerce platform
2. Build AI-powered custom figurine pipeline
3. Establish brand and acquire first 500 customers
4. Operationalize production and fulfillment with MCAE
5. Validate unit economics and path to profitability

## Projects

- **mvp-backend** — FastAPI backend with catalog, payments, orders (6 tasks)
- **mvp-frontend** — React storefront with browsing, checkout, tracking (6 tasks)
- **platform-infrastructure** — Docker/K8s/CI/CD/monitoring (5 tasks)
- **7 company-level strategic tasks** — vendor negotiation, brand identity, financial model, etc.

## Importing Into Paperclip

### Via Paperclip UI/API

1. Push this package to GitHub (`github.com/cellarwood/figurio`)
2. Import via Paperclip UI (Company Import page) or API: `POST /companies/import` with `source.type: "github"`
3. Run `scripts/setup-secrets.sh` to configure required secrets

### Global Config (manual)

1. Copy `global/settings.json` and `global/plugins.json` into `.company/claude/` in the Paperclip repo root
2. Rebuild/restart the container

## Required Secrets

Run `scripts/setup-secrets.sh` or manually configure:

- `GH_TOKEN` — GitHub personal access token
- `DOCKER_HUB_USERNAME` / `DOCKER_HUB_TOKEN` — Docker Hub credentials
- `STRIPE_SECRET_KEY` / `STRIPE_WEBHOOK_SECRET` — Stripe API keys
- `DATABASE_URL` — PostgreSQL connection string
- `GEMINI_API_KEY` — Google Gemini for media generation
- `ELEVENLABS_API_KEY` — ElevenLabs for text-to-speech
- `SENTRY_DSN` — Sentry error tracking

## License

MIT
