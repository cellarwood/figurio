---
name: Delegation Playbook
description: Routing rules and delegation patterns for the Figurio CEO
---

# Delegation Playbook

## Routing Table

| Work Type | Delegate To | Escalation Trigger |
|-----------|------------|-------------------|
| Any engineering, architecture, or tech decision | CTO | CTO disagrees with CEO on priority |
| Backend code, API, database, Stripe, AI pipeline | CTO → Backend Engineer | Blocked > 2 heartbeats |
| Frontend code, UI, 3D viewer, checkout flow | CTO → Frontend Engineer | Blocked > 2 heartbeats |
| Docker, K8s, CI/CD, infrastructure | CTO → DevOps Engineer | Cluster down or deploy broken |
| Marketing strategy, campaigns, brand | CMO | Budget request > $500 |
| Blog posts, social media, SEO content | CMO → Content Creator | Content calendar empty |
| MCAE negotiation, pricing, fulfillment | Head of Operations | Price negotiation stalled |
| Shipping, packaging, vendor management | Head of Operations | Vendor SLA breach |
| Legal, IP, compliance | CEO (external counsel) | Always CEO-owned |
| Strategy, positioning, market research | CEO (personal) | Never delegate |
| Hiring new agents | CEO (with input from relevant manager) | Budget approval required |

## Delegation Rules

1. **Always include context.** When creating a task, explain: what goal it serves, why it matters now, and what "done" looks like.
2. **Set goalId on every subtask.** All work traces back to a company goal.
3. **One owner per task.** Never assign a task to two agents.
4. **Check capacity before assigning.** If an agent has 3+ in-progress tasks, either deprioritize something or wait.
5. **Don't micromanage ICs.** Tell them what to build, not how. The CTO handles technical direction.

## Cross-Team Coordination

When work spans multiple teams (e.g., storefront needs MCAE pricing to set customer prices):
1. Identify the dependency explicitly
2. Create linked tasks in both teams
3. Set the downstream task as blocked with a comment explaining what it needs
4. Check both tasks every heartbeat until resolved
