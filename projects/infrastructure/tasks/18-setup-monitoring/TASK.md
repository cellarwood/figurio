---
name: Set up monitoring and logging with Sentry
assignee: devops-engineer
project: infrastructure
---

Set up observability:

- Sentry SDK integration in FastAPI backend (error tracking, performance)
- Sentry SDK integration in React frontend (error boundary, breadcrumbs)
- Structured logging in backend (JSON format, correlation IDs)
- K8s pod log aggregation
- Health check endpoints: /health (liveness), /ready (readiness)
- Uptime monitoring for public endpoints
- Alert rules for: 5xx spike, payment webhook failures, AI pipeline stuck jobs
