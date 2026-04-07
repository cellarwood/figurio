# Figurio

Direct-to-consumer e-commerce company designing, producing, and delivering high-quality full-color 3D-printed figurines from the Czech Republic.

## Products

- **Catalog Figurines** — curated, trending, and seasonal pre-designed figurines
- **AI Custom Figurines ("Prompt to Print")** — describe a figurine in text, AI generates a 3D model, you approve, we print

## Org Chart

```
                     CEO
              ┌───────┼───────────┐
             CTO     CMO    Head of Operations
          ┌───┼────┐     │
   Backend  Frontend  DevOps  Content Creator
   Engineer Engineer  Engineer
```

| Agent | Role | Budget |
|-------|------|--------|
| CEO | Strategy, delegation, hiring | $100/mo |
| CTO | Architecture, tech decisions, engineering leadership | $150/mo |
| CMO | Brand, marketing strategy, content direction | $100/mo |
| Head of Operations | MCAE partnership, fulfillment, shipping | $80/mo |
| Backend Engineer | FastAPI, Stripe, AI pipeline, database | $200/mo |
| Frontend Engineer | React storefront, 3D viewer, checkout | $200/mo |
| DevOps Engineer | Docker, K8s, CI/CD, monitoring | $150/mo |
| Content Creator | Blog, social media, SEO, product copy | $80/mo |

## Tech Stack

- **Frontend:** React, TypeScript, shadcn-ui, Tailwind CSS, Three.js
- **Backend:** Python, FastAPI, PostgreSQL, Stripe
- **AI Pipeline:** Text-to-3D API (Meshy/Tripo3D), Blender mesh repair
- **Infrastructure:** Docker, Kubernetes (microk8s-local), Helm, Traefik, GitHub Actions
- **Payments:** Stripe (cards, Apple Pay, Google Pay, SEPA, iDEAL, Bancontact)

## Projects

| Project | Owner | Description |
|---------|-------|-------------|
| storefront | CTO | E-commerce web app with catalog, checkout, accounts |
| ai-pipeline | CTO | Text prompt → 3D model → mesh repair → QA → preview |
| production-ops | Head of Ops | MCAE partnership, fulfillment, shipping |
| marketing-launch | CMO | Brand identity, content, social media, SEO |
| infrastructure | DevOps | Monorepo, Docker, K8s, CI/CD |

## Importing Into Paperclip

### Via GitHub Import
1. Push this repo to `github.com/cellarwood/figurio`
2. Import via Paperclip UI or API: `POST /companies/import` with `source.type: "github"`

### Global Config Setup
1. Copy `global/settings.json` and `global/plugins.json` to `docker/init/claude/` in your Paperclip repo
2. Add volume mount to `docker/docker-compose.yml`:
   ```yaml
   - ./init/claude:/docker-init/claude:ro
   ```
3. Rebuild/restart the Paperclip container

### Required Environment Variables
- `GH_TOKEN` — GitHub personal access token
- `DOCKER_HUB_USERNAME` / `DOCKER_HUB_TOKEN` — Docker Hub credentials
- `STRIPE_SECRET_KEY` / `STRIPE_WEBHOOK_SECRET` — Stripe API keys
- `DATABASE_URL` — PostgreSQL connection string

### Optional Environment Variables
- `MESHY_API_KEY` or `TRIPO3D_API_KEY` — Text-to-3D API key
- `SENTRY_DSN` — Error tracking
- `SLACK_WEBHOOK_URL` — Slack notifications

## Infrastructure

- **Domain:** cellarwood.org
- **GitHub:** github.com/cellarwood/figurio
- **Docker Hub:** lukekelle00
- **Slack:** 00aiworkspace.slack.com
- **Stripe:** Cellarwood account
- **K8s:** microk8s-local cluster

## License

MIT
