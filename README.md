# Figurio

Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines. Based in Czech Republic.

## Product Lines

- **Catalog Figurines** ("Ready to Print") — Curated, rotating catalog of pre-designed figurines across trending, seasonal, and evergreen categories
- **AI-Prompted Custom Figurines** ("Prompt to Print") — Customers describe a figurine in natural language, AI generates a 3D model, customer approves a rendered preview before production

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React, TypeScript, shadcn-ui, Tailwind CSS, GSAP |
| Backend | Python, FastAPI, PostgreSQL |
| Infrastructure | Docker, Kubernetes (microk8s), Helm, Traefik, GitHub Actions |
| Payments | Stripe (checkout sessions, webhooks, two-stage for custom) |
| AI Pipeline | Text-to-3D (Meshy/Tripo3D), automated mesh repair |
| Shipping | Zasilkovna (CZ), DHL (EU/international) |
| Production | MCAE (Stratasys J55 PolyJet) |

## Org Chart

```
CEO
 ├── CTO
 │    ├── Backend Engineer
 │    ├── Frontend Engineer
 │    ├── DevOps Engineer
 │    └── UI Designer
 ├── CMO
 │    └── Content Creator
 ├── Head of Operations
 ├── Product Manager
 └── Customer Support
```

**11 agents** | **~$1,100/mo total budget**

## Company Goals

1. Launch MVP e-commerce platform with catalog browsing, AI custom figurines, and Stripe payments
2. Build a launch-ready catalog of 30+ print-ready figurine designs
3. Establish production & fulfillment pipeline with MCAE printing partner
4. Build brand identity and acquire first 100 paying customers

## Projects

| Project | Owner | Description |
|---------|-------|-------------|
| mvp-backend | Backend Engineer | FastAPI backend with product catalog, order pipeline, Stripe, AI queue |
| mvp-frontend | Frontend Engineer | React storefront with catalog, AI prompt flow, cart, checkout |
| platform-infra | DevOps Engineer | Docker, K8s deployment, CI/CD, monitoring |

## Importing Into Paperclip

### 1. Company Import (spec-compliant files)

```bash
# Push to GitHub
git add -A && git commit -m "Figurio company package"
git push origin main

# Import via Paperclip UI or API
curl -X POST https://your-paperclip/api/companies/import \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"source": {"type": "github", "repo": "cellarwood/figurio"}}'
```

### 2. Global Config (manual setup)

```bash
# Copy global config into Paperclip repo
cp global/settings.json /path/to/paperclip/docker/init/claude/settings.json
cp global/plugins.json /path/to/paperclip/docker/init/claude/plugins.json

# Add volume mount in docker-compose.yml:
# volumes:
#   - ./init/claude:/docker-init/claude:ro

# Rebuild container
docker compose up -d --build
```

### 3. Secrets

Run `scripts/setup-secrets.sh` to configure required environment variables (Stripe, GitHub, Docker Hub, database, etc.).

## Infrastructure

| Service | Value |
|---------|-------|
| Domain | cellarwood.org |
| Google Workspace | cellarwood.org |
| GitHub | github.com/cellarwood/figurio |
| Docker Hub | lukekelle00 |
| Slack | 00aiworkspace.slack.com |
| Stripe | Cellarwood |
| K8s | microk8s-local |

## License

MIT
