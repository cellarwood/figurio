---
name: Set up GitHub repos, Docker Hub, K8s cluster, and CI/CD pipelines
assignee: devops-engineer
---

Infrastructure setup:
- GitHub repo structure (monorepo or multi-repo decision)
- Docker Hub registry (lukekelle00) — image naming conventions
- K8s cluster setup on microk8s-local
- Traefik ingress controller configuration
- GitHub Actions CI/CD pipelines (build, test, deploy)
- Secrets management (Stripe keys, DB credentials, API keys)
- DNS configuration for figurio domain
- Monitoring and alerting basics (health checks, error tracking via Sentry)
