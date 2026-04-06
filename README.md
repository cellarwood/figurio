# Figurio -- Agent Company Package

Figurio is a direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines. This package defines the complete agent organization for the Paperclip platform.

## Org Structure

```
CEO
├── CTO
│   ├── Backend Engineer
│   ├── Frontend Engineer
│   ├── ML Engineer
│   └── DevOps Engineer
├── CMO
│   └── Content Creator
└── Head of Operations
```

## Quick Start

### Import via Paperclip API

```bash
# Set your Paperclip API URL
export PAPERCLIP_API_URL=http://localhost:3100

# Run the import script
chmod +x import.sh
./import.sh
```

### Import via Paperclip UI

1. Push this directory to a GitHub repository
2. Go to the Paperclip Company Import page
3. Select source type: GitHub
4. Enter the repository URL
5. Import

### Global Config (manual)

1. Copy `global/settings.json` and `global/plugins.json` to `docker/init/claude/` in your Paperclip repo
2. Add volume mount to `docker/docker-compose.yml`:
   ```yaml
   - ./init/claude:/docker-init/claude:ro
   ```
3. Rebuild/restart the container

## Required Environment Variables

See `.paperclip.yaml` for the full list. Critical ones:

- `GH_TOKEN` -- GitHub personal access token
- `DOCKER_HUB_USERNAME` / `DOCKER_HUB_TOKEN` -- Docker Hub credentials
- `STRIPE_SECRET_KEY` / `STRIPE_WEBHOOK_SECRET` -- Stripe payment processing
- `DHL_API_KEY` -- DHL shipping API
- `ZASILKOVNA_API_KEY` -- Zasilkovna (Packeta) shipping API

## External Services

| Service | Purpose |
|---------|---------|
| GitHub (cellarwood) | Source code, CI/CD |
| Docker Hub (lukekelle00) | Container registry |
| Stripe | Payment processing |
| DHL | International shipping |
| Zasilkovna | Czech Republic shipping |
| Slack | Team communication |
| MCAE (mcae.cz) | 3D printing production partner |
| cellarwood.org | Company domain |
