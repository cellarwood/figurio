---
name: Set up monitoring
assignee: devops-engineer
project: infrastructure-setup
---

Deploy monitoring and observability stack for the Figurio services.

## Requirements

### Prometheus
- Deploy to the monitoring namespace
- Scrape metrics from FastAPI (using `prometheus-fastapi-instrumentator` or similar)
- Scrape Kubernetes pod metrics
- Configure alerting rules: high error rate (>5% 5xx), high latency (>2s p95), pod restarts

### Grafana
- Deploy with Prometheus data source pre-configured
- Create dashboard: API request rate, response time (p50/p95/p99), error rate, active orders
- Create dashboard: Kubernetes pod status, CPU/memory usage

### Sentry
- Integrate Sentry SDK in FastAPI backend (error tracking, performance monitoring)
- Integrate Sentry SDK in React frontend (error boundary, performance)
- Configure source maps upload for frontend

### Loki (optional, lower priority)
- Log aggregation from all pods
- Grafana data source for log queries

## Technical Notes

- Use Helm charts for Prometheus and Grafana deployment
- Sentry requires a project and DSN — document the setup steps
- Alert notifications via Slack #alerts channel (when Slack is set up)
