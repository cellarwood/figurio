---
name: escalation-rules
description: Figurio escalation rules for support cases involving shipping failures, damaged items, custom approval conflicts, refunds, fraud risk, and trust-sensitive communications.
---

# Figurio Escalation Rules

Use this skill when deciding whether a support case must be escalated, how urgently it should move, and what information the receiving owner needs to act without re-triage.

## Core Rule

Escalate when support cannot safely resolve the issue, when customer trust is at risk, or when a decision requires operational, financial, or policy authority beyond frontline support.

## Escalate Immediately For

- Safety concerns or product-safety allegations.
- Repeated shipping failures or a shipment that appears lost after prior exceptions.
- Suspected fraud, spoofed identity, or chargeback risk.
- Customer threats involving public escalation, legal claims, or payment disputes.
- Any situation where a promise would materially affect trust and cannot be verified first.

## Escalate Same Day For

- Damaged-item cases with photos and order evidence.
- Refund requests that depend on policy judgment, exception approval, or partial credit decisions.
- Custom-approval disputes where the customer says they approved, but the record does not match.
- Orders stuck in production, approval, or fulfillment without a clear next owner.
- Carrier handoff failures, stalled tracking, or delivery exceptions that need investigation.

## Escalation Triage

Classify the case before handing it off:

- `fulfillment` for production, packing, handoff, and shipping exceptions.
- `quality` for damage, defects, or missing parts.
- `approval` for preview, revision, or approval-history conflicts.
- `refunds` for money movement or customer compensation.
- `trust` for any message that could damage confidence if handled loosely.

## Required Escalation Bundle

Do not escalate a blank case. Include:

- Order ID.
- Customer name and contact.
- Issue category.
- Short factual summary.
- Timeline of what happened.
- Evidence received, if any.
- What support already told the customer.
- The exact decision or action needed.

## Rules For Customer-Facing Language

- Do not tell the customer that an escalation guarantees a result.
- Do not mention internal debate, ownership gaps, or uncertainty in a way that undermines confidence.
- If the case is under review, say that it has been routed for decision and name the next checkpoint.
- If a customer asks for an exception, state that it must be reviewed before any commitment is made.

## Ownership Guidance

- Route operational exceptions to the team that can verify status or release work.
- Route financial exceptions to the owner who can approve refunds, credits, or adjustments.
- Route approval disputes to the owner of the approval record or workflow.
- Route repeated trust-sensitive complaints to leadership if the case may affect broader customer confidence.

## Escalation Quality Bar

- The receiving owner should not need to ask for the basics again.
- The summary should be factual, brief, and free of blame.
- Use direct language about what is being asked: investigate, approve, refund, replace, confirm, or reject.
- If a case is high urgency, say why in one sentence.

## Closeout Expectations

- Confirm back to the customer only after the responsible owner has answered.
- If the decision is negative, explain it plainly and respectfully.
- If the decision is positive, state the outcome and any next step, such as re-ship, refund, or updated approval path.
- If the answer remains open, provide the next checkpoint instead of leaving the customer with silence.

