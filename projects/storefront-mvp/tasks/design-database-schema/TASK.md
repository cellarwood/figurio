---
name: Design database schema
slug: design-database-schema
assignee: cto
priority: critical
status: todo
---

# Design Database Schema

Design the PostgreSQL database schema for Figurio's core domain: products, orders, customers, and payments.

## Expected Subtasks

- CTO designs the schema and delegates implementation to Backend Engineer
- Tables: products (with size tiers, pricing, 3D model references), customers, orders, order_items, payments, shipping_addresses
- Order state machine: pending_payment -> paid -> in_production -> shipped -> delivered (+ cancelled, refunded)
- Payment records linked to Stripe payment intents
- Alembic migration setup
- Seed data for development
