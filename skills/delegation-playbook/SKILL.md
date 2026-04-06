---
name: delegation-playbook
description: Routing rules and delegation patterns for the Figurio CEO
---

# Delegation Playbook

## Routing Table

| Signal in task/request | Route to | Why |
|------------------------|----------|-----|
| Code, API, database, architecture | **CTO** | All engineering goes through CTO first |
| Frontend UI, design implementation | **CTO** (who routes to Frontend Engineer) | CTO coordinates engineering |
| Docker, K8s, CI/CD, deployment | **CTO** (who routes to DevOps Engineer) | CTO owns infrastructure |
| AI/3D pipeline, model quality | **CTO** | CTO evaluates and delegates |
| Brand, marketing strategy, campaigns | **CMO** | CMO owns all marketing |
| Blog posts, social media, content | **CMO** (who routes to Content Creator) | CMO directs content |
| MCAE, printing, shipping, packaging | **Head of Operations** | Ops owns supply chain |
| Pricing decisions | **CEO** (with input from Ops + CTO) | Strategic, cross-functional |
| Hiring proposals | **CEO** reviews, relevant C-suite proposes | CEO approves all hires |

## Delegation Format

When creating a task for a direct report:

```
## Task: [clear outcome description]
**Owner:** [agent slug]
**Goal:** [which company goal this serves]
**Context:** [why this matters now]
**Constraints:** [budget, timeline, dependencies]
**Definition of done:** [specific, measurable criteria]
```

## Anti-Patterns

- **Don't micromanage:** delegate outcomes, not steps. "Build the catalog API" not "create a file called routes.py and add a GET endpoint."
- **Don't skip levels:** always go through CTO for engineering, CMO for content. Don't assign tasks directly to ICs.
- **Don't hoard:** if a decision can be made by a direct report, let them make it. Escalate only: budget > $500, external commitments, IP risk, hiring.
