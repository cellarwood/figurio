---
name: tech-decisions
description: Build-vs-buy evaluation criteria and technology decision framework for Figurio
---

# Tech Decisions

## Build vs. Buy Framework

For every significant technology choice, evaluate:

| Factor | Build | Buy/Use SaaS |
|--------|-------|--------------|
| Time to first value | Weeks-months | Days-weeks |
| Ongoing maintenance | We own it | Vendor owns it |
| Customization | Full control | Limited to API |
| Cost at low volume | Dev time only | Per-unit/monthly fee |
| Cost at high volume | Fixed (infra) | Scales with usage |
| Vendor lock-in risk | None | Medium-high |

### Figurio-Specific Decisions

| Decision | Recommendation | Rationale |
|----------|---------------|-----------|
| 3D generation | **Buy** (API) | Core differentiator but not our core competence. Use API, swap later. |
| Mesh repair | **Build** (Blender scripts) | Custom quality needs, runs headless, low API cost. |
| Payment processing | **Buy** (Stripe) | Never build payments. Stripe handles compliance. |
| Email sending | **Buy** (SendGrid/Resend) | Not worth building. |
| Auth | **Build** (FastAPI + JWT) | Simple enough, full control over user data. |
| Search | **Build** (PostgreSQL full-text) | Start simple. Add Elasticsearch when catalog > 1000 items. |
| Image hosting | **Buy** (S3/Cloudflare R2) | Commodity storage. |

## Decision Record

When making a tech decision, document:

1. **What** — the decision and alternatives considered
2. **Why** — the primary driver (cost, speed, quality, risk)
3. **Trade-offs** — what we're giving up
4. **Reversibility** — how hard is it to change later?
5. **Action** — who implements, by when
