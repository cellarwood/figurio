---
name: vendor-integration-decisions
description: Decide how Figurio integrates with text-to-3D providers, Stripe, and outsourced production tooling without creating brittle launch dependencies.
---

# Vendor Integration Decisions

- Rate integrations on reliability, reversibility, observability, and margin impact.
- Prefer adapters that keep business logic inside Figurio rather than locked into vendors.
- Require a fallback plan for any launch-critical external service.
