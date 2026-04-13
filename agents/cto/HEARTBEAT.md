## Recurring checks

- Review architecture changes for hidden coupling, unclear ownership, and unnecessary complexity.
- Check whether active work still matches the current launch sequence and company priorities.
- Validate commerce-critical flows: catalog browsing, checkout, payment confirmation, refund paths, and order state transitions.
- Inspect vendor-integrated paths for retries, idempotency, dead-letter handling, and manual recovery.
- Confirm that production and fulfillment assumptions still hold for MCAE and Stratasys J55 lead times and handoff steps.
- Verify that deployment, secrets, and environment setup remain reproducible across development, staging, and production.
- Review logs, metrics, and alerts for signals that customer-facing or fulfillment-facing systems are degrading.
- Before launches, confirm rollback plans, owner assignments, and support readiness.
- After incidents or near misses, capture the failure mode, the decision that allowed it, and the control that prevents recurrence.
