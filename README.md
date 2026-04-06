# Figurio

Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines. Based in Czech Republic.

## Product Lines

1. **Catalog Figurines ("Ready to Print")** — curated collection of pre-designed figurines
2. **AI-Prompted Custom Figurines ("Prompt to Print")** — customers describe a figurine in natural language, AI generates a 3D model, customer approves a preview, then it's printed

## Org Chart

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

## Tech Stack

- **Frontend:** React, TypeScript, shadcn-ui, Tailwind CSS
- **Backend:** Python, FastAPI, PostgreSQL
- **Infrastructure:** Docker, Kubernetes (microk8s), Helm, Traefik
- **AI Pipeline:** Text-to-3D API (Meshy/Tripo3D), Blender mesh repair
- **Payments:** Stripe
- **CI/CD:** GitHub Actions, Docker Hub

## Import into Paperclip

### 1. Spec-compliant files (via Paperclip import)

```bash
# Push to GitHub
git push origin main

# Import via Paperclip API
POST /companies/import
{
  "source": {
    "type": "github",
    "url": "https://github.com/cellarwood/figurio"
  }
}
```

Or use the Paperclip UI Company Import page.

### 2. Global config (manual setup)

```bash
# Copy global config into Paperclip repo
cp global/settings.json <paperclip-repo>/docker/init/claude/settings.json
cp global/plugins.json <paperclip-repo>/docker/init/claude/plugins.json
```

Add volume mount to `docker/docker-compose.yml`:

```yaml
volumes:
  - ./init/claude:/docker-init/claude:ro
```

Rebuild/restart the container.

## Environment Variables Required

| Variable | Description |
|----------|-------------|
| `GITHUB_TOKEN` | GitHub CLI authentication |
| `DOCKER_HUB_USERNAME` | Docker Hub push access |
| `DOCKER_HUB_TOKEN` | Docker Hub authentication |
| `STRIPE_SECRET_KEY` | Stripe payment processing |
| `STRIPE_PUBLISHABLE_KEY` | Stripe client-side key |
| `STRIPE_WEBHOOK_SECRET` | Stripe webhook signature verification |
| `TEXT_TO_3D_API_KEY` | Meshy/Tripo3D API access |
| `SLACK_BOT_TOKEN` | Slack integration |

## Infrastructure

| Service | Details |
|---------|---------|
| Domain | cellarwood.org |
| GitHub | github.com/cellarwood/figurio |
| Docker Hub | lukekelle00 |
| Kubernetes | microk8s-local |
| Slack | 00aiworkspace.slack.com |
| Stripe | Cellarwood account |
| Printing Partner | MCAE (mcae.cz) — Stratasys J55 PolyJet |
| Shipping (CZ) | Zásilkovna (Packeta) |
| Shipping (EU) | DHL, DPD, GLS |

## License

MIT
