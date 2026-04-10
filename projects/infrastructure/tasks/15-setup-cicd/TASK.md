---
name: Set up CI/CD pipeline (GitHub Actions, build, test, deploy)
assignee: devops-engineer
project: infrastructure
---

Create automated build and deployment pipeline.

## Requirements
- GitHub Actions workflows for cellarwood/figurio
- Build and test on pull request
- Docker image build and push on merge to main
- Automated deployment to microk8s-local
- Environment-specific configuration (staging, production)
- Slack notification on deploy success/failure
