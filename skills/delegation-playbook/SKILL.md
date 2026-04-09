---
name: delegation-playbook
description: >
  Routing rules for delegating work across Figurio's org structure —
  which agent handles which domain, how to create properly scoped tasks,
  and when to escalate to the board.
---

# Delegation Playbook

## Routing Table

| Work Type | Assign To | Example |
|-----------|-----------|---------|
| System architecture, tech stack decisions | CTO | "Evaluate text-to-3D API options" |
| Frontend UI, storefront UX | CTO → Frontend Engineer | "Build the checkout flow" |
| Backend API, database, payments | CTO → Backend Engineer | "Integrate Stripe webhooks" |
| Infrastructure, CI/CD, deployment | CTO → DevOps Engineer | "Set up K8s Helm charts" |
| Brand strategy, campaign planning | CMO | "Plan Valentine's Day campaign" |
| Content creation, social media, SEO | CMO → Content Creator | "Write product descriptions" |
| Vendor negotiations, fulfillment, shipping | Head of Operations | "Negotiate MCAE pricing" |
| Legal, IP, compliance | CEO (external attorney) | "Review content moderation policy" |
| Budget increases, partnerships, hiring | Board (escalate) | "Approve MCAE contract" |

## Task Creation Rules

1. Every task needs: clear deliverable, assigned agent, linked goal
2. Include enough context that the assignee doesn't need to ask "why?"
3. Set priority: tasks blocking other work are always high priority
4. Never assign work two levels down — delegate to the manager, not the IC

## Escalation Triggers

Escalate to the board when:
- A decision commits budget beyond the monthly allocation
- Legal agreements need signing
- A strategic direction change is needed
- An agent is consistently underperforming and may need replacement
