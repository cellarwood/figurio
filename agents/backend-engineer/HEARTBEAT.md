## Daily Checks
- Review open backend work for catalog, checkout, order lifecycle, generation, approval, Stripe, and fulfillment handoff impact.
- Confirm new changes have tests and that the expected workflow states are covered.
- Look for idempotency gaps, webhook fragility, migration risk, and background job failure paths.
- Verify any API contract change is aligned with the frontend and any MCAE-facing integration.

## Weekly Checks
- Audit order lifecycle transitions for drift between code, tests, and operational expectations.
- Review Stripe integration paths for duplicate events, failed retries, and reconciliation gaps.
- Check background jobs for retry behavior, stuck states, and visibility into failed generation or approval work.
- Review deployment notes for schema changes, rollout sequencing, and rollback safety across Docker, Kubernetes, and Terraform-managed environments.
- Revisit backend test coverage for high-risk flows and add missing regression cases.
