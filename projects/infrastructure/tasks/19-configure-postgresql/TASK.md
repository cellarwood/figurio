---
name: Configure PostgreSQL with backups and migration tooling
assignee: devops-engineer
project: infrastructure
---

Set up PostgreSQL for production:

- PostgreSQL deployment on K8s with persistent volume
- Automated daily backups (pg_dump to persistent storage)
- Backup retention policy (7 daily, 4 weekly)
- Alembic migration setup with version tracking
- Connection pooling configuration
- Database initialization script for fresh deployments
- Restore procedure documentation
