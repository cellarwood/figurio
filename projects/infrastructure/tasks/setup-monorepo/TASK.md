---
name: Set Up Monorepo Structure
assignee: devops-engineer
project: infrastructure
---

Establish the monorepo structure for Figurio with clear separation between frontend, backend, and shared packages.

## Requirements

- Root-level package.json with workspace configuration
- Directory structure:
  ```
  apps/
    web/          # React/TS storefront
    api/          # Python/FastAPI backend
    admin/        # Admin dashboard (optional, can be part of web)
  packages/
    shared/       # Shared types, constants, utilities
  infra/
    docker/       # Dockerfiles
    k8s/          # Kubernetes manifests
    helm/         # Helm charts
  scripts/        # Build and deployment scripts
  ```
- Shared TypeScript types for API contracts between frontend and backend
- Root-level linting and formatting configuration
- Git hooks for pre-commit validation (lint, type-check)

## Acceptance Criteria

- Both frontend and backend can be developed independently
- Shared types are importable from both apps
- `npm install` at root sets up all workspaces
- `uv sync` in api/ sets up Python dependencies
