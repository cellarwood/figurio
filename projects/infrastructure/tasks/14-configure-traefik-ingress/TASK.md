---
name: Configure Traefik ingress and domain routing
assignee: devops-engineer
project: infrastructure
---

Set up Traefik as the ingress controller.

## Requirements
- Traefik IngressRoute for figurio domain
- TLS termination with Let's Encrypt
- Path-based routing: / → frontend, /api → backend
- Rate limiting middleware
- CORS configuration
- Health check routes
