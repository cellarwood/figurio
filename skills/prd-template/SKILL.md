---
name: prd-template
description: >
  Product requirements document template for Figurio features. Covers the
  structured format for defining user problem, proposed solution, acceptance
  criteria, and scope across Figurio's core flows: catalog browsing, AI custom
  figurine configuration, Stripe checkout, and order tracking.
allowed-tools:
  - Read
  - Write
  - Grep
metadata:
  paperclip:
    tags:
      - product
      - documentation
---

# PRD Template

Use this template when writing a PRD for any Figurio feature. Fill every section — no section should be left empty or marked "TBD" before a PRD is considered ready for engineering review.

## When to Use

Invoke this skill whenever you need to produce a PRD for a new feature, a significant change to an existing flow, or a cross-functional initiative that touches the React/TS frontend, FastAPI backend, or Stripe integration.

## Template

Copy the structure below and fill in each section.

---

### `[Feature Name]` — Product Requirements Document

**Author:** [PM name]
**Created:** [YYYY-MM-DD]
**Status:** Draft | In Review | Approved
**Stakeholders:** [Engineering, Design, Ops, …]

---

#### 1. User Problem

_One to three sentences. Who is affected, what pain do they experience, and what is the evidence (user feedback, support tickets, conversion data)?_

> Example: Customers who want a fully custom figurine abandon the AI configuration flow at the pose-selection step (42% drop-off, April 2026 funnel data). They do not understand that the pose they select affects the final print price, because no price update is shown until checkout.

---

#### 2. Goal & Success Metrics

| Metric | Baseline | Target | Measurement |
|--------|----------|--------|-------------|
| [e.g., AI flow completion rate] | [x%] | [y%] | [Mixpanel funnel event] |
| [e.g., Support tickets re: pricing] | [n/week] | [n/week] | [Zendesk tag] |

---

#### 3. Proposed Solution

_Describe the solution in plain language. Include the affected Figurio flow (catalog, AI custom, checkout, or order tracking) and the layers touched (frontend component, FastAPI endpoint, Stripe object, or ops tooling)._

> Example: Show a real-time price estimate in the AI custom configurator sidebar. The FastAPI `/api/v1/quotes/estimate` endpoint already returns a price given model complexity; the frontend should call it on every pose or material change and render the result inline before the user reaches checkout.

---

#### 4. Scope

**In scope**
- [Bullet list of what is included]

**Out of scope**
- [Explicit exclusions — prevents scope creep]

---

#### 5. User Stories

Format: _As a [persona], I want [capability] so that [outcome]._

- As a **catalog browser**, I want …
- As a **custom figurine buyer**, I want …
- As an **ops team member**, I want …

Add as many stories as needed; group them by persona.

---

#### 6. Acceptance Criteria

Each criterion must be testable. Use Given/When/Then where it helps clarity.

| # | Criterion | Flow | Layer |
|---|-----------|------|-------|
| 1 | Given … When … Then … | AI custom | Frontend |
| 2 | Given … When … Then … | Checkout | Stripe / FastAPI |
| 3 | … | Order tracking | FastAPI |

**Definition of Done checklist**
- [ ] All acceptance criteria pass in staging
- [ ] No regression in Stripe webhook handling (test mode)
- [ ] Lighthouse performance score does not drop below current baseline on affected pages
- [ ] Error states (API timeout, Stripe decline) are handled and user-facing messages are correct

---

#### 7. Design & Technical Notes

_Optional. Call out any known constraints, dependencies, or decisions that engineering must be aware of._

- FastAPI endpoint(s) involved: `[e.g., GET /api/v1/quotes/estimate]`
- Frontend component(s): `[e.g., ConfiguratorSidebar.tsx]`
- Stripe objects affected: `[e.g., PaymentIntent metadata, Price object]`
- Data / privacy considerations (Czech Republic / GDPR): `[note if personal data is stored or transmitted]`

---

#### 8. Open Questions

| Question | Owner | Due |
|----------|-------|-----|
| [e.g., Should price estimates be cached? At what TTL?] | Engineering | [date] |

---

## Flow-Specific Guidance

### Catalog Browsing
Focus ACs on filter/sort correctness, pagination behavior, and product card data accuracy (SKU, material, price).

### AI Custom Figurine Flow
Call out each step of the multi-step configurator (photo upload → style → pose → material → review). ACs must cover the happy path and at least: unsupported file format, generation timeout, and price change between estimate and final checkout.

### Checkout (Stripe)
ACs must explicitly cover: successful payment, card decline, 3DS authentication, and webhook delivery. Reference the Stripe test card matrix when writing test scenarios.

### Order Tracking
ACs must cover status transitions (received → printing → shipped → delivered) and the customer-facing notifications triggered at each transition.

## Anti-patterns

- Writing acceptance criteria that test implementation details ("the button calls `handleSubmit`") rather than user-observable behavior.
- Leaving the success metrics section blank — every PRD must have at least one measurable outcome.
- Scoping a PRD to span multiple unrelated flows without splitting into separate documents.
- Describing the solution before the problem — always establish the user problem first.
