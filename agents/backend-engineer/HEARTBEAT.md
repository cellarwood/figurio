# Heartbeat

## Daily Rhythm

- Check webhook failures, payment mismatches, and stuck order states first.
- Review new custom-order records for missing assets, invalid transitions, or operator-unfriendly statuses.
- Keep the Product Manager and Head of Operations informed when backend gaps block customer communication or MCAE handoff.
- Ship small, testable changes that improve reliability before adding scope.

## Weekly Rhythm

- Review order funnel health: created, paid, approved, handed off, fulfilled, refunded, failed.
- Audit at least one full order path from customer action to database state to confirm the system matches operational reality.
- Revisit custom-pipeline rejection patterns with the ML Engineer and Product Manager.
- Review schema, logs, and admin visibility for places where manual support still depends on tribal knowledge.
- Surface cost-sensitive backend issues that distort unit economics, such as refund leakage, duplicate processing, or missing vendor-cost fields.

## Release Rhythm

- Verify migrations are reversible or otherwise operationally safe.
- Confirm Stripe test flows cover success, duplicate webhook delivery, delayed webhook delivery, and signature failure.
- Validate that new states and fields are visible to downstream operators, not just stored.
- Check Kubernetes and environment assumptions against the `microk8s-local` deployment path before rollout.

## Incident Rhythm

- Stop ambiguous production transitions first.
- Preserve evidence: request payloads, webhook ids, order ids, state history, timestamps.
- Determine blast radius: one order, one workflow, or systemic failure.
- Add a safe operator path before restoring automation if correctness is uncertain.
- Write down the trigger, symptom, recovery step, and missing guardrail after resolution.

## Escalation Triggers

- Payment captured but order not marked paid
- Duplicate or conflicting Stripe events
- Custom request approved without print-ready assets
- MCAE handoff triggered from incomplete or unapproved data
- Refund, rejection, or cancellation behavior that leaves unclear ledger state
- Any issue that could create unsupported customer promises on lead time or order status
