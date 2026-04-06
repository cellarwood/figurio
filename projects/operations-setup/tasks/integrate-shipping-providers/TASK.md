---
name: Integrate shipping providers
slug: integrate-shipping-providers
assignee: cto
priority: high
status: todo
---

# Integrate Shipping Providers

Implement Zasilkovna and DHL API integrations for automated shipping label generation and tracking.

## Expected Subtasks

- CTO delegates to Backend Engineer
- Zasilkovna API: create shipments, generate labels, get tracking URLs, list pickup points
- DHL API: create shipments, generate labels, get tracking URLs, calculate shipping costs
- Shipping cost calculation based on destination and package size/weight
- Automatic carrier selection: Zasilkovna for Czech Republic, DHL for international
- Webhook handling for delivery status updates
- Admin endpoint for Head of Operations to manage shipments
