# Figurio

Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines. Based in Czech Republic, powered by Stratasys J55 PolyJet technology via MCAE partnership.

## Product Lines

1. **Catalog Figurines ("Ready to Print")** — Curated, rotating catalog of pre-designed figurines
2. **AI Custom Figurines ("Prompt to Print")** — Describe a figurine in natural language, get a 3D-printed result
3. **3D Scan-to-Print ("Scan Yourself")** — Phase 2 future product line

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React, TypeScript, shadcn-ui, Tailwind CSS, Vite |
| Backend | Python, FastAPI, PostgreSQL, Alembic, uv |
| AI Pipeline | PyTorch, Blender Python API, text-to-3D service APIs |
| Payments | Stripe (cards, Apple Pay, Google Pay, SEPA) |
| Infrastructure | Docker, Kubernetes (microk8s), Traefik, GitHub Actions, Terraform |
| Shipping | Zasilkovna (Czech/EU), DHL (international) |

## Org Chart

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   ├── ML Engineer (3D Pipeline)
│   └── DevOps Engineer
├── CMO
│   └── Content Creator
└── Head of Operations
```

**9 agents** | **18 custom skills** | **18 subagents** | **~$980/mo total budget**

## Company Goals

1. Launch MVP e-commerce platform with catalog browsing, Stripe checkout, and order management
2. Build AI prompt-to-print pipeline for custom figurine generation with mesh repair and customer preview
3. Establish Figurio brand and acquire first 100 paying customers
4. Operationalize production and fulfillment with MCAE printing partnership

## Projects

| Project | Owner | Description |
|---------|-------|-------------|
| `mvp-backend` | Backend Engineer | FastAPI backend with catalog, Stripe, orders |
| `mvp-frontend` | Frontend Engineer | React storefront with cart, checkout, admin |
| `ai-pipeline` | ML Engineer | Text-to-3D generation, mesh repair, preview |
| `brand-and-marketing` | Content Creator | Brand identity, social media, SEO, campaigns |
| `operations` | Head of Operations | MCAE partnership, shipping, packaging, SOPs |

## Importing Into Paperclip

### Via Paperclip UI/API

1. Push this repo to GitHub
2. Import via Paperclip UI (Company Import page) or API:
   ```
   POST /companies/import
   { "source": { "type": "github", "url": "https://github.com/cellarwood/figurio" } }
   ```
3. The import deploys all agent configs, skills, projects, tasks, and runtime files

### Global Config (manual)

1. Copy `global/settings.json` and `global/plugins.json` into `.company/claude/` in the Paperclip repo root
2. Rebuild/restart the container

## Setup

After import, run the secrets setup script:

```bash
bash scripts/setup-secrets.sh
```

Required secrets:
- `GH_TOKEN` — GitHub personal access token
- `DOCKER_HUB_USERNAME` / `DOCKER_HUB_TOKEN` — Docker Hub credentials
- `STRIPE_SECRET_KEY` / `STRIPE_WEBHOOK_SECRET` — Stripe API keys
- `DATABASE_URL` — PostgreSQL connection string
- `GEMINI_API_KEY` — Google Gemini for media generation
- `ELEVENLABS_API_KEY` — ElevenLabs for text-to-speech (optional)

## License

MIT License. See [LICENSE](LICENSE).
