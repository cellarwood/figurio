# Figurio

Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines. Based in the Czech Republic, powered by Stratasys J55 PolyJet technology via MCAE.

## Product Lines

- **Catalog** ("Ready to Print") — curated figurine collection for immediate ordering
- **AI Custom** ("Prompt to Print") — text-to-3D pipeline for custom figurines
- **Scan-to-Print** ("Scan Yourself") — Phase 2, personalized figurines from 3D scans

## Org Chart

```
Board Operator (Human)
  |
  CEO ($100/mo)
  |
  +-- CTO ($150/mo)
  |    +-- Backend Engineer ($200/mo)
  |    +-- Frontend Engineer ($200/mo)
  |    +-- DevOps Engineer ($150/mo)
  |
  +-- CMO ($120/mo)
  |    +-- Content Creator ($80/mo)
  |
  +-- Head of Operations ($100/mo)
```

**Total monthly budget:** $1,100/mo

## Tech Stack

- **Frontend:** React/TypeScript, shadcn-ui, Tailwind CSS
- **Backend:** Python/FastAPI, PostgreSQL, uv
- **Infrastructure:** Docker, Kubernetes (microk8s), Traefik, GitHub Actions
- **Payments:** Stripe
- **AI/3D:** Text-to-3D API, Blender mesh repair
- **Shipping:** Zasilkovna (CZ)

## Importing Into Paperclip

### Before `docker compose up`

**Step 1: Global Config**
```bash
cp global/settings.json <paperclip-repo>/.company/claude/settings.json
cp global/plugins.json <paperclip-repo>/.company/claude/plugins.json
```

**Step 2: Google Workspace credentials**
```bash
cp <your-gws-service-account>.json <paperclip-repo>/.company/gws/figurio.json
```

**Step 3: Import GWS skills**
```bash
bash <paperclip-repo>/paperclip-plugin/skills/gws-cli/scripts/import-gws-skills.sh .
```

**Step 4: Start Paperclip**
```bash
cd <paperclip-repo>/docker && docker compose up -d
```

### After Paperclip is running

**Step 5: Company Import**
```bash
# Push this package to GitHub first, then:
curl -X POST http://localhost:3100/api/companies/import \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"source": {"type": "github", "url": "https://github.com/cellarwood/figurio"}, "target": {"mode": "new_company"}}'
```

**Step 6: Secrets**
```bash
# Edit scripts/setup-secrets.sh with your COMPANY_ID, AUTH_TOKEN, and secret values
bash scripts/setup-secrets.sh
```

## Infrastructure

| Resource | Value |
|----------|-------|
| Domain | cellarwood.org |
| GitHub | github.com/cellarwood/figurio |
| Docker Hub | lukekelle00 |
| K8s Cluster | microk8s-local |
| Slack | 00aiworkspace.slack.com |
| Stripe | Cellarwood account |
| Google Workspace | info@cellarwood.org |

## License

MIT
