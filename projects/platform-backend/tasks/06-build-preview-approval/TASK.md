---
name: Build preview and approval workflow with 3D renders and deposit payment
assignee: backend-engineer
project: platform-backend
---

Build the customer preview and approval system:

- 3D render generation from approved mesh (multiple angles)
- Preview delivery to customer (email + in-app)
- Customer approval/revision request API
- Revision handling: re-queue for generation or manual adjustment
- Second payment capture on approval (remaining 50%)
- Preview expiry (auto-cancel after N days without response)
- Maximum revision limit per order
