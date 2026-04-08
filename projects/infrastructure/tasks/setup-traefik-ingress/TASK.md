---
name: Set up Traefik ingress with Let's Encrypt SSL
assignee: devops-engineer
project: infrastructure
---

# Set up Traefik ingress with Let's Encrypt SSL

Configure Traefik as K8s ingress controller. Set up IngressRoute for figurio web and API. Configure Let's Encrypt cert-manager for automatic SSL. Route: figurio.cellarwood.org -> web service, api.figurio.cellarwood.org -> api service. Enable HTTPS redirect.
