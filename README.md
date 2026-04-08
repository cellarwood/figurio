# Figurio — 3D-Printed Figurines E-Commerce

## Overview
Figurio is a direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines. Based in Czech Republic, production outsourced to MCAE (Stratasys J55 PolyJet).

## Product Lines
- **Catalog Figurines** ("Ready to Print") — curated, rotating catalog
- **AI-Prompted Custom** ("Prompt to Print") — describe a figurine, AI generates it
- **3D Scan-to-Print** ("Scan Yourself") — Phase 2

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
- **Frontend:** TypeScript, React, shadcn-ui, Tailwind CSS, Three.js
- **Backend:** Python, FastAPI, PostgreSQL, Stripe
- **Infrastructure:** Docker, Kubernetes (microk8s-local), Helm, Traefik, GitHub Actions
- **AI Pipeline:** Text-to-3D (TBD), Blender/NetFabb mesh repair, PyTorch

## Infrastructure
- **Domain:** cellarwood.org
- **GitHub:** github.com/cellarwood/figurio
- **Docker Hub:** lukekelle00
- **Slack:** 00aiworkspace.slack.com
- **K8s:** microk8s-local
- **Payments:** Stripe (Cellarwood account)
- **Shipping:** Zasilkovna (CZ), DHL (EU)

## Importing Into Paperclip

### Before `docker compose up`

**Step 1: Global Config**
```bash
cp global/settings.json /path/to/paperclip/.company/claude/settings.json
cp global/plugins.json /path/to/paperclip/.company/claude/plugins.json
```

**Step 2: Google Workspace credentials**
```bash
cp /path/to/figurio-service-account.json /path/to/paperclip/.company/gws/figurio.json
```

**Step 3: Start Paperclip**
```bash
cd docker && docker compose up -d
```

### After Paperclip is running

**Step 4: Company Import**
```bash
curl -X POST http://localhost:3100/api/companies/import \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"source": {"type": "github", "url": "https://github.com/cellarwood/figurio"}}'
```

**Step 5: Secrets**
Fill in COMPANY_ID, AUTH_TOKEN, and secret values in scripts/setup-secrets.sh, then:
```bash
bash scripts/setup-secrets.sh
```

## Budget
Total: $1,100/month (110,000 cents)

| Agent | Budget |
|-------|--------|
| CEO | $100/mo |
| CTO | $150/mo |
| CMO | $120/mo |
| Head of Operations | $100/mo |
| Backend Engineer | $200/mo |
| Frontend Engineer | $200/mo |
| Content Creator | $80/mo |
| DevOps Engineer | $150/mo |

## License
MIT

---
Generated with [Paperclip](https://paperclip.dev)
