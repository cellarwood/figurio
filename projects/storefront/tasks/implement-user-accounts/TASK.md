---
name: Implement user accounts with order history
assignee: backend-engineer
project: storefront
---

Build user authentication and account management.

- User registration with email and password (validation, duplicate check)
- Login endpoint returning JWT access token + refresh token
- Password reset flow via email (reset link with expiring token)
- User profile endpoint (GET /users/me, PATCH /users/me)
- Order history endpoint tied to authenticated user
- Rate limiting on auth endpoints (login, register, password reset)
- Password hashing with bcrypt
- JWT token refresh endpoint
- Email verification flow (optional for MVP, but design the schema for it)
