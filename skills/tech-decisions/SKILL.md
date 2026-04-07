---
name: Tech Decisions
description: Build-vs-buy evaluation criteria and technology selection framework for Figurio
---

# Tech Decisions

## Build vs. Buy Framework

| Factor | Build | Buy/Use Third-Party |
|--------|-------|-------------------|
| Core differentiator | Build if it's part of the product moat | Buy if it's commodity |
| Time to market | Slower | Faster |
| Long-term cost | Lower (no per-unit fees) | Higher (API costs scale) |
| Control | Full | Limited by vendor |
| Maintenance | You own it | Vendor handles it |

**Figurio-specific guidance:**
- **Build:** Storefront, order management, checkout flow, admin dashboard — these ARE the product
- **Buy:** Text-to-3D generation (for now), payment processing (Stripe), hosting (K8s), email (transactional)
- **Evaluate:** Mesh repair (start with Blender scripting, evaluate commercial tools if quality is insufficient)

## Technology Selection Criteria

When evaluating a new tool, library, or service:

1. **Is it proven?** Prefer boring technology. FastAPI, PostgreSQL, React, Docker — known quantities with large communities.
2. **Does it have async support?** The AI pipeline requires async operations. Libraries must support asyncio.
3. **What's the lock-in risk?** Can we switch away in under a week? If not, the bar is higher.
4. **What's the cost at scale?** Model API costs at 100, 1,000, and 10,000 orders/month.
5. **Is the Python package on PyPI and compatible with `uv`?** No pip-only packages.

## Text-to-3D API Selection

Evaluate candidates on:
- Output quality (detail, color accuracy, geometric correctness)
- Printability (manifold geometry, minimum wall thickness compliance)
- Generation speed (target: under 5 minutes per model)
- Cost per generation
- API reliability and uptime
- Content moderation capabilities (can it reject copyrighted prompts?)

Candidates: Meshy, Tripo3D, Luma Genie, CSM 3D. Run benchmarks with 20 test prompts before selecting.
