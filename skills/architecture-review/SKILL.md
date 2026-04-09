---
name: architecture-review
description: >
  Architecture review checklist for Figurio's e-commerce platform and AI pipeline —
  evaluating API design, service boundaries, data flow, security, and scalability
  for the figurine storefront and text-to-3D pipeline.
---

# Architecture Review

## When to Use

When reviewing a technical proposal, PR with architectural changes, or system design document.

## Review Checklist

### API Design
- [ ] RESTful conventions followed (resource-based URLs, proper HTTP methods)
- [ ] Consistent error response format across all endpoints
- [ ] Pagination on list endpoints
- [ ] Input validation at the API boundary
- [ ] OpenAPI documentation present

### Data Model
- [ ] Proper normalization (no redundant data across tables)
- [ ] Indexes on frequently queried columns
- [ ] Foreign key constraints enforced
- [ ] Alembic migration included
- [ ] No breaking schema changes without migration path

### Security
- [ ] No hardcoded secrets or API keys
- [ ] User input sanitized (SQL injection, XSS prevention)
- [ ] Authentication required on protected endpoints
- [ ] Stripe webhook signature verification
- [ ] Content moderation for AI prompts (IP infringement prevention)

### AI Pipeline Specifics
- [ ] Async job processing (not blocking the API response)
- [ ] Mesh repair validates against printability constraints
- [ ] Failed AI generations handled gracefully (retry, fallback, user notification)
- [ ] Generated models stored securely with access control

### Scalability
- [ ] Stateless services (no server-side session state)
- [ ] Database connection pooling
- [ ] Appropriate use of caching (product catalog, not order state)
- [ ] Task queue for long-running operations (AI generation, mesh repair)
