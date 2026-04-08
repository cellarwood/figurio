---
name: architecture-review
description: Checklist for reviewing architectural decisions and system designs at Figurio, covering API design, AI pipeline, and infrastructure
---

# Architecture Review

Use this skill when reviewing system designs, API contracts, or architectural proposals.

## Review Checklist

### API Design
- [ ] RESTful conventions followed (proper HTTP methods, status codes, resource naming)
- [ ] Pagination strategy defined (cursor-based preferred for large collections)
- [ ] Authentication and authorization model specified
- [ ] Error response format standardized (error code, message, details)
- [ ] Rate limiting considered for public endpoints
- [ ] API versioning strategy defined

### Data Model
- [ ] Database schema normalized appropriately
- [ ] Indexes defined for common query patterns (catalog filtering, order lookup)
- [ ] Migration strategy defined (Alembic for Python/PostgreSQL)
- [ ] Soft delete vs. hard delete decision documented
- [ ] File storage strategy for 3D models (S3-compatible or local volume)

### AI Pipeline
- [ ] Text-to-3D service abstracted behind an interface (swap providers easily)
- [ ] Async processing with status tracking (don't block on generation)
- [ ] Mesh repair pipeline is idempotent (re-running produces same result)
- [ ] Failure handling: what happens when generation fails? when repair fails?
- [ ] Model file format standardized (STL, OBJ, glTF)

### Infrastructure
- [ ] Services are stateless (state in database/object storage, not in containers)
- [ ] Health check endpoints defined for K8s liveness/readiness probes
- [ ] Secret management — no secrets in code or Docker images
- [ ] Resource limits set for K8s pods (CPU, memory)
- [ ] Logging strategy defined (structured JSON logs)

## Output Format

```markdown
## Architecture Review: {Component}

**Verdict:** Approve / Approve with changes / Redesign needed

**Strengths:** {what's good}
**Concerns:** {issues found, ordered by severity}
**Required changes:** {must-fix before implementation}
**Recommendations:** {nice-to-have improvements}
```
