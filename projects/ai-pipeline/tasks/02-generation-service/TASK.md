---
name: Build async text-to-3D generation service with job queue
assignee: ml-engineer
project: ai-pipeline
---

Generation service:
- FastAPI service wrapping chosen text-to-3D API
- Async job queue (Redis/Celery or similar)
- Prompt preprocessing and content moderation (reject IP-infringing prompts)
- Generation result storage (S3 or local)
- Job status tracking API
- Retry logic and error handling
