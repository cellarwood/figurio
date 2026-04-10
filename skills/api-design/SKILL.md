---
name: api-design
description: >
  REST API conventions for the Figurio e-commerce platform (FastAPI/Python).
  Covers endpoint naming for catalog, orders, and AI generation jobs; pagination;
  error responses; Stripe webhook handling; order state machine transitions; and
  AI job queue patterns using Celery+Redis.
allowed-tools:
  - Read
  - Grep
  - Bash
metadata:
  paperclip:
    tags: [engineering, backend, api]
---

# API Design

## URL Structure

Base path: `/api/v1/`

| Resource | Collection | Single Item |
|----------|------------|-------------|
| Catalog figurines | `GET /api/v1/catalog` | `GET /api/v1/catalog/{slug}` |
| Orders | `GET /api/v1/orders` | `GET /api/v1/orders/{order_id}` |
| AI generation jobs | `GET /api/v1/ai-jobs` | `GET /api/v1/ai-jobs/{job_id}` |
| Stripe webhooks | — | `POST /api/v1/webhooks/stripe` |
| Admin | `GET /api/v1/admin/orders` | `GET /api/v1/admin/orders/{order_id}` |

Rules:
- Resource names are **plural, kebab-case** nouns: `ai-jobs`, not `aiJob` or `ai_job`
- IDs are UUIDs throughout; never expose sequential integer PKs in URLs
- Nested sub-resources only one level deep: `GET /api/v1/orders/{order_id}/items`

## FastAPI Router Layout

Group routers by domain. Each router module lives at `app/routers/<domain>.py`:

```
app/
  routers/
    catalog.py
    orders.py
    ai_jobs.py
    webhooks.py
    admin.py
```

Register with prefix in `app/main.py`:

```python
app.include_router(catalog.router, prefix="/api/v1/catalog", tags=["catalog"])
app.include_router(orders.router, prefix="/api/v1/orders", tags=["orders"])
app.include_router(ai_jobs.router, prefix="/api/v1/ai-jobs", tags=["ai-jobs"])
app.include_router(webhooks.router, prefix="/api/v1/webhooks", tags=["webhooks"])
```

## Pagination

All list endpoints use **cursor-based pagination** (not offset). Query params:

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `limit` | int | 20 | Max items, capped at 100 |
| `cursor` | str | — | Opaque cursor from previous response |

Response envelope:

```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTIzfQ==",
    "has_more": true,
    "limit": 20
  }
}
```

Cursors are base64-encoded JSON of the last item's sort key. Never expose raw DB row IDs in cursors.

## Error Responses

All errors return `application/json` with this shape:

```json
{
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order f47ac10b-... does not exist.",
    "details": {}
  }
}
```

Error code conventions:
- `SCREAMING_SNAKE_CASE` strings, domain-prefixed: `ORDER_NOT_FOUND`, `AI_JOB_FAILED`, `CATALOG_ITEM_UNAVAILABLE`
- HTTP status must match semantics: 400 validation, 404 not found, 409 conflict, 422 unprocessable, 503 downstream unavailable

Use a shared exception handler — never let raw Python exceptions surface:

```python
# app/exceptions.py
class FigurioError(HTTPException):
    def __init__(self, code: str, message: str, status_code: int, details: dict = {}):
        super().__init__(status_code=status_code)
        self.code = code
        self.message = message
        self.details = details
```

## Order State Machine

Orders move through these states only in the permitted transitions below:

```
PENDING_PAYMENT
    └─► PAYMENT_CAPTURED
            └─► FILE_PREPARATION
                    └─► SENT_TO_MCAE
                            └─► PRINTING
                                    └─► SHIPPED
                                            └─► DELIVERED
                                    └─► PRINT_FAILED → FILE_PREPARATION (retry)
    └─► PAYMENT_FAILED
PAYMENT_CAPTURED
    └─► CANCELLED (before SENT_TO_MCAE only)
```

For AI-custom orders, additional states sit between `PAYMENT_CAPTURED` and `FILE_PREPARATION`:

```
PAYMENT_CAPTURED → AI_JOB_QUEUED → AI_JOB_PROCESSING → PREVIEW_PENDING_APPROVAL
    └─► PREVIEW_APPROVED → FILE_PREPARATION
    └─► PREVIEW_REJECTED → AI_JOB_QUEUED (re-run, max 3 revisions)
    └─► SECOND_PAYMENT_PENDING → SECOND_PAYMENT_CAPTURED → FILE_PREPARATION
```

Enforce transitions in `app/services/order_state.py` — reject invalid transitions with `ORDER_INVALID_TRANSITION` (409).

## Stripe Webhook Handling

Endpoint: `POST /api/v1/webhooks/stripe`

Always verify the Stripe signature before processing:

```python
import stripe

@router.post("/stripe")
async def stripe_webhook(request: Request):
    payload = await request.body()
    sig = request.headers.get("stripe-signature")
    try:
        event = stripe.Webhook.construct_event(
            payload, sig, settings.STRIPE_WEBHOOK_SECRET
        )
    except stripe.error.SignatureVerificationError:
        raise HTTPException(status_code=400, detail="Invalid signature")

    await handle_stripe_event(event)
    return {"received": True}
```

Events to handle and their order transitions:

| Stripe Event | Action |
|---|---|
| `payment_intent.succeeded` | `PENDING_PAYMENT → PAYMENT_CAPTURED` |
| `payment_intent.payment_failed` | `PENDING_PAYMENT → PAYMENT_FAILED` |
| `checkout.session.completed` | Confirm second-payment for AI orders |
| `charge.dispute.created` | Flag order, notify admin |

Webhook handler must be **idempotent** — check `stripe_event_id` in DB before processing. Return 200 immediately; do heavy work in a Celery task.

## AI Generation Job Queue Patterns

Jobs are dispatched via Celery with Redis as the broker.

### Enqueue on Order Creation

```python
# app/services/ai_jobs.py
from app.worker import celery_app

def enqueue_ai_job(order_id: str, prompt: str) -> str:
    task = celery_app.send_task(
        "tasks.generate_model",
        args=[order_id, prompt],
        queue="ai_generation",
    )
    return task.id  # stored as ai_job.celery_task_id
```

### Job Status Polling

`GET /api/v1/ai-jobs/{job_id}` returns:

```json
{
  "job_id": "uuid",
  "order_id": "uuid",
  "status": "PROCESSING",
  "progress_pct": 45,
  "preview_url": null,
  "error": null,
  "created_at": "2026-04-10T10:00:00Z",
  "updated_at": "2026-04-10T10:03:12Z"
}
```

Job statuses: `QUEUED | PROCESSING | PREVIEW_READY | APPROVED | REJECTED | FAILED`

Celery tasks must update the `ai_jobs` table at each phase transition — never trust Celery task state as the source of truth.

### Retry Policy

```python
@celery_app.task(bind=True, max_retries=3, default_retry_delay=60)
def generate_model(self, order_id: str, prompt: str):
    try:
        ...
    except TransientError as exc:
        raise self.retry(exc=exc)
    except PermanentError:
        # update job status to FAILED, no retry
        ...
```

## Anti-patterns

- Do not expose internal DB IDs or Celery task IDs directly in public API responses — always use the application-level UUID
- Do not use GET endpoints for state-changing operations (no `GET /orders/{id}/cancel`)
- Do not process Stripe webhooks synchronously in the request thread — always hand off to Celery
- Do not use offset pagination on large tables (orders, ai-jobs) — use cursor pagination
- Do not return stack traces or SQLAlchemy error messages in error responses
