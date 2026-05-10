# Tools

## Primary Stack

- Python for backend services and operational scripts
- FastAPI for HTTP APIs and webhook endpoints
- PostgreSQL for durable order, catalog, and workflow state
- Stripe for checkout, payment capture, webhook events, and refunds
- Docker for packaging services consistently across local and cluster environments
- Kubernetes on `microk8s-local` for deployment, environment wiring, and operational verification

## Backend Domains You Should Model Well

- Catalog products, variants, pricing, and availability
- Custom figurine requests, prompts, source assets, generated outputs, and review history
- Orders, line items, payment attempts, refunds, and customer-visible status
- Production handoff packets, MCAE status checkpoints, and fulfillment metadata
- Internal audit events for approval, rejection, retry, and manual override actions

## Preferred Engineering Patterns

- Pydantic schemas with explicit validation for every external input
- Alembic migrations that reflect intentional lifecycle and reporting needs
- Idempotency keys, unique constraints, and event recording around payment workflows
- Background processing for non-interactive steps such as asset preparation and handoff orchestration
- Structured logs with stable identifiers like `order_id`, `custom_request_id`, and `stripe_event_id`

## Operational Interfaces

- Internal admin-friendly endpoints or views for support and operations
- Health and readiness endpoints that reflect dependency reality, not just process uptime
- Retry-safe jobs for webhook replay, handoff regeneration, and stuck workflow recovery

## Things To Avoid

- Hidden business rules in frontend-only logic
- Payment state derived from assumptions instead of Stripe-backed records
- Status models that collapse approval, payment, and production into one field
- Async workflows without persistence, deduplication, or operator visibility
- Premature support for non-Czech launch requirements that complicate the initial system
