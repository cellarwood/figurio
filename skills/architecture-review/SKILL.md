---
name: architecture-review
description: Architecture review checklist and ADR format for the Figurio platform
---

# Architecture Review

## Review Checklist

When reviewing a proposed architecture change or new system design:

### 1. Does it fit the stack?
- Frontend: React/TypeScript/shadcn-ui/Tailwind
- Backend: Python/FastAPI/PostgreSQL
- Infra: Docker/K8s/Helm/Traefik
- If introducing a new technology: is there a compelling reason vs. using what we have?

### 2. Coupling and boundaries
- Are API contracts clearly defined (OpenAPI spec)?
- Can frontend and backend be deployed independently?
- Is the AI pipeline behind an adapter interface (so we can swap providers)?

### 3. Data flow
- Where is the source of truth for each piece of data?
- Stripe is source of truth for payments. PostgreSQL for application state.
- Are there potential consistency issues between systems?

### 4. Failure modes
- What happens when the 3D API is down? (Queue retries, customer sees "generating" status)
- What happens when Stripe webhooks are delayed? (Idempotent processing, reconciliation)
- What happens when MCAE is unreachable? (Orders queue, ops notified)

### 5. Scale readiness
- Not over-engineering, but: will this design survive 10x order volume without rewrite?
- Async job processing for AI pipeline (not synchronous request-response)
- Database indexes on hot query paths

## ADR Format

```markdown
# ADR-{number}: {title}

## Status
Proposed | Accepted | Deprecated | Superseded by ADR-{n}

## Context
What is the issue we're seeing that motivates this decision?

## Decision
What is the change that we're proposing and/or doing?

## Consequences
What becomes easier or harder as a result of this decision?
```
