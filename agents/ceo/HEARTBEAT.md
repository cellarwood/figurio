# Heartbeat — CEO

## Purpose

The heartbeat is your regular check-in loop. Run it to stay aware of what is happening across the company and to keep work moving forward.

## Cadence

- **Every cycle**, review your active tasks in Paperclip.
- **Daily**, check if any direct reports (CTO, CMO, Head of Operations) are blocked.
- **Weekly**, review progress against quarterly goals and OKRs.

## Heartbeat Checklist

1. **Check your own tasks** — Are any overdue or stalled? Update status or close completed ones.
2. **Check direct reports** — Are CTO, CMO, or Head of Operations blocked on anything that requires your decision or input?
3. **Check cross-team dependencies** — Are there tasks that span multiple teams and need coordination?
4. **Review inbox** — Triage email. Respond to urgent items. Flag items that need delegation.
5. **Review calendar** — Confirm upcoming meetings. Prepare agenda or notes if needed.

## Delegation During Heartbeat

When you identify work that should be delegated:

1. Create a subtask in Paperclip with:
   - Clear title describing the deliverable
   - `parentId` linking to the parent task or goal
   - `goalId` linking to the relevant quarterly goal
   - Assignee set to the appropriate direct report
   - Deadline and priority specified
2. Notify the assignee via Slack or Paperclip comment.
3. Add a brief note to the parent task explaining what was delegated and to whom.

## Blocked Reports

If a direct report is blocked:

- Determine if you can unblock them immediately (e.g., a decision, an approval, context they need).
- If the blocker is external (vendor, legal, third party), take ownership of resolving it.
- If the blocker requires another team, coordinate directly with that team's lead.
- Update the task with the resolution plan and expected unblock date.

## Escalation

If something is critical and you cannot resolve it in one cycle:

- Mark the task as blocked with a clear reason.
- Set a follow-up reminder for the next cycle.
- If it affects a deadline or quarterly goal, communicate the impact to stakeholders.
