---
name: Set up monitoring stack
assignee: devops-engineer
project: infrastructure-setup
---

Deploy monitoring and observability tools for the Figurio platform.

## Components

### Prometheus
- Deploy via Helm chart (kube-prometheus-stack)
- Scrape metrics from FastAPI backend (using prometheus-fastapi-instrumentator or similar)
- Scrape Kubernetes node and pod metrics

### Grafana
- Deploy via kube-prometheus-stack Helm chart
- Dashboards:
  - API latency and request rate (p50, p95, p99)
  - Order pipeline: orders created, payments captured, AI jobs started/completed/failed
  - Infrastructure: CPU, memory, disk per pod
  - Stripe webhook processing latency and error rate

### Sentry
- Frontend: `@sentry/react` for React error boundary and performance tracing
- Backend: `sentry-sdk[fastapi]` for exception tracking and performance
- Environment-specific DSNs (dev, staging, prod)

### Loki (optional, lower priority)
- Log aggregation from all pods
- Grafana data source for log querying

## Acceptance Criteria

- Prometheus scraping backend metrics
- Grafana accessible with at least 2 dashboards (API performance, infrastructure)
- Sentry capturing errors from both frontend and backend in dev environment
- Alert rules for: API error rate > 5%, order processing failures
