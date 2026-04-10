---
name: Set up Docker multi-stage builds
slug: setup-docker-builds
assignee: devops-engineer
project: platform-infrastructure
recurring: false
---

Create multi-stage Dockerfiles for frontend (Node build → nginx serve) and backend (Python/uv build → slim runtime). Docker Compose for local development with PostgreSQL, hot-reload for both services.
