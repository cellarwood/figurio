# Tools — DevOps Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Git workflows, dead-code analysis, dependency updates, docs generation |
| `infra-plugin` | K8s/GKE, Helm, Terraform, Traefik, auth configuration |

## Usage Guidelines

- Use infra-plugin for Kubernetes cluster management, Helm chart authoring, Terraform planning, and Traefik configuration
- Use dev-tools-plugin for CI/CD pipeline management and Docker build optimization
- Always `terraform plan` before `terraform apply`
- Test Helm chart changes in staging namespace before production
- Keep Docker images under 200MB using multi-stage builds with Alpine/distroless base

---
*Add personal tool notes below as you discover and use tools.*
