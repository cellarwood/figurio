---
name: Set Up CI/CD Pipeline
assignee: devops-engineer
project: mvp-storefront
---

Configure GitHub Actions CI/CD pipeline for automated testing and deployment.

- Create GitHub Actions workflow for PR checks: lint, type-check, unit tests
- Create build workflow: multi-stage Docker builds for frontend and backend
- Push Docker images to Docker Hub (lukekelle00) with commit SHA and latest tags
- Create deploy workflow: Helm upgrade to MicroK8s cluster on merge to main
- Configure environment-specific secrets in GitHub Actions
- Add build status badges to README
- Ensure zero-downtime deployments with rolling update strategy
