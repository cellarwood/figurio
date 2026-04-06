# Figurio

Direct-to-consumer e-commerce company selling high-quality full-color 3D-printed figurines, based in the Czech Republic.

**Domain:** cellarwood.org
**Storefront:** figurio.cellarwood.org

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
- **Backend:** Python, FastAPI, SQLAlchemy, PostgreSQL
- **Infrastructure:** Docker, Kubernetes (microk8s-local), Helm, Traefik
- **Payments:** Stripe
- **Shipping:** Zásilkovna (CZ), DHL (EU)
- **Production:** MCAE (Stratasys J55 PolyJet)

## Projects

| Project | Owner | Description |
|---------|-------|-------------|
| mvp-storefront | CTO | Catalog storefront with Stripe checkout and order management |
| infrastructure-setup | CTO | Monorepo, Docker, K8s, CI/CD, monitoring |
| marketing-launch | CMO | Brand identity, content, social media |

## Importing Into Paperclip

### 1. Spec-compliant files (via Paperclip import)

Push this package to GitHub, then import via:
- **UI:** Company Import page
- **API:** `POST /companies/import` with `source.type: "github"`

This handles: COMPANY.md, agents, projects, tasks, and .paperclip.yaml.

### 2. Global config (manual setup)

```bash
# Copy global config into the Paperclip repo
cp global/settings.json <paperclip-repo>/docker/init/claude/settings.json
cp global/plugins.json <paperclip-repo>/docker/init/claude/plugins.json
```

Add volume mount to `docker/docker-compose.yml`:

```yaml
volumes:
  - ./init/claude:/docker-init/claude:ro
```

Rebuild/restart the container.

## Manual Steps Required

1. **Stripe:** Create a Stripe account, get test/live API keys, configure webhook endpoint
2. **MCAE:** Contact mcae.cz to negotiate pricing (Head of Operations task)
3. **Shipping:** Set up Zásilkovna and DHL accounts
4. **DNS:** Configure `figurio.cellarwood.org` A record pointing to the K8s cluster
5. **Docker Hub:** Create account for container image registry
6. **Sentry:** Create project for error tracking
