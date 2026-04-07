---
name: Set up shipping integration with Zasilkovna and DHL
assignee: head-of-operations
project: production-ops
---

Integrate shipping providers for Czech and EU delivery.

- Zasilkovna (Packeta) for Czech Republic:
  - Register for API access
  - Integrate label generation and pickup point selection
  - Set up tracking number retrieval
  - Test with real parcel shipment
- DHL for EU delivery:
  - Register for DHL business account
  - Integrate DHL Parcel API for label generation
  - Configure EU-wide shipping zones and rates
  - Test with real parcel shipment
- Define shipping rate structure for customers (flat rate, weight-based, or free-over-threshold)
- Coordinate with Backend Engineer on shipping API integration points
- Document shipping rates and delivery time estimates per region
