# Figurio — Agent Company Package

Figurio is a direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines. This package defines the complete Paperclip agent organization following the Agent Companies spec (`agentcompanies/v1`).

## Org Chart

```
Board Operator (Human)
  │
  CEO
  │
  ├── CTO
  │    ├── Frontend Engineer
  │    ├── Backend Engineer
  │    └── DevOps Engineer
  │
  ├── CMO
  │    └── Content Creator
  │
  └── Head of Operations
```

**8 agents | ~$380/month total budget**

## Importing Into Paperclip

### Before `docker compose up`

**Step 1: Global Config**
```bash
cp global/settings.json <paperclip-repo>/.company/claude/settings.json
cp global/plugins.json <paperclip-repo>/.company/claude/plugins.json
```

**Step 2: Google Workspace Credentials**
```bash
cp <your-gws-credentials>.json <paperclip-repo>/.company/gws/figurio.json
```

**Step 3: Start Paperclip**
```bash
cd <paperclip-repo>/docker && docker compose up -d
```

### After Paperclip is running

**Step 4: Company Import**
```bash
# Push this package to GitHub first
git push origin main

# Import via API
curl -X POST http://localhost:3100/api/companies/import \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"source": {"type": "github", "url": "https://github.com/cellarwood/figurio"}, "target": {"mode": "new_company"}}'
```

**Step 5: Secrets**
```bash
# Edit scripts/setup-secrets.sh with your COMPANY_ID, AUTH_TOKEN, and secret values
vim scripts/setup-secrets.sh
bash scripts/setup-secrets.sh
```

## Credentials Needed

| Secret | Where to Get |
|--------|-------------|
| `GH_TOKEN` | GitHub personal access token |
| `DOCKER_HUB_TOKEN` | Docker Hub access token (user: lukekelle00) |
| `STRIPE_SECRET_KEY` | Stripe dashboard (test mode: sk_test_...) |
| `STRIPE_WEBHOOK_SECRET` | Stripe webhook signing secret |
| `GEMINI_API_KEY` | Google AI Studio |
| `ELEVENLABS_API_KEY` | ElevenLabs dashboard |
| `DATABASE_URL` | PostgreSQL connection string |
| GWS credentials JSON | Google Cloud Console (service account) |

## Project Structure

```
figurio/
├── COMPANY.md              # Company definition
├── .paperclip.yaml         # Adapter config, budgets, env
├── agents/                 # 8 agent instruction bundles
├── goals/                  # Goal hierarchy (4 company goals)
├── projects/               # 2 projects (mvp-storefront, marketing-launch)
├── tasks/                  # 3 company-level strategic tasks
├── skills/                 # 16 custom + 95 GWS skills
├── teams/                  # 3 teams (engineering, marketing, operations)
├── global/                 # Global Claude Code settings
└── scripts/                # Setup automation
```

## License

MIT
