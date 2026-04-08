---
name: Set up monorepo with apps/web and services/api structure
assignee: devops-engineer
project: infrastructure
---

# Set up monorepo with apps/web and services/api structure

Initialize monorepo at github.com/cellarwood/figurio. Structure:

- apps/web (React/TS frontend)
- services/api (FastAPI backend)
- packages/shared (shared types/utils)
- infra/ (Helm charts, K8s manifests)

Set up root package.json for workspace management. Configure .gitignore, .editorconfig.
