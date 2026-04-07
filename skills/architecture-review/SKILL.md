---
name: Architecture Review
description: Architecture review checklist and ADR format for Figurio's technical decisions
---

# Architecture Review

## Review Checklist

When reviewing an architecture proposal or significant technical change:

### Fit
- [ ] Does it align with the monorepo structure (apps/web, services/api)?
- [ ] Does it use the approved tech stack (React/TS, FastAPI/Python, PostgreSQL)?
- [ ] Does it fit within the single-database, single-API architecture?

### Simplicity
- [ ] Is this the simplest solution that works? (No speculative abstractions)
- [ ] Could this be done with fewer moving parts?
- [ ] Does it introduce a new dependency? Is that dependency justified?

### Scalability (within reason)
- [ ] Will this work for 100 orders/day? 1,000? (Don't over-engineer for 100,000)
- [ ] Are database queries indexed appropriately?
- [ ] Are external API calls (Stripe, text-to-3D) handled asynchronously?

### Security
- [ ] Are secrets managed via environment variables / K8s secrets?
- [ ] Is user input validated at API boundaries?
- [ ] Are Stripe webhooks verified with signature checking?
- [ ] Is authentication required on all non-public endpoints?

### Operability
- [ ] Can this be deployed with the existing Helm chart + GitHub Actions pipeline?
- [ ] Are there health check endpoints?
- [ ] Is there logging sufficient for debugging production issues?

## ADR (Architecture Decision Record) Format

```markdown
# ADR-{number}: {Title}

**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-{n}
**Date:** {YYYY-MM-DD}
**Decider:** CTO

## Context
{What is the issue? Why does a decision need to be made?}

## Decision
{What was decided?}

## Consequences
{What are the positive and negative effects of this decision?}

## Alternatives Considered
{What other options were evaluated and why were they rejected?}
```
