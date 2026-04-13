---
name: component-patterns
description: Design reusable React, TypeScript, Tailwind, shadcn-ui, and Radix component patterns for Figurio storefront, checkout, preview, order, and admin surfaces. Use when creating, refactoring, or reviewing shared UI primitives, composition patterns, state handling, or accessibility behavior.
---

# Component Patterns

Use this skill when building shared UI components for Figurio. The goal is to make patterns reusable, predictable, and easy to compose across storefront, product detail, checkout, approval, tracking, and admin views.

## What Good Looks Like

- Components map to real commerce concepts, not generic UI widgets.
- Props are explicit, typed, and stable in strict TypeScript.
- Composition is preferred over deep configuration objects.
- Visual variants are controlled through a small, finite API.
- Loading, empty, error, and disabled states are part of the component contract.
- Accessibility is built in, not added later.

## Default Implementation Rules

- Prefer shadcn-ui and Radix primitives before building custom interactive controls.
- Keep shared components presentational by default; pass data and actions in from the feature layer.
- Avoid coupling a reusable component to routing, fetch logic, analytics, or browser storage.
- If a component has multiple visual modes, use a clear `variant` or `size` API and keep the set small.
- Use `className` escape hatches sparingly and only for layout or one-off composition needs.
- Keep the DOM shallow. Prefer slots, children, and subcomponents over wrapper chains.

## Pattern Selection

### Use a shared component when

- The same layout or interaction appears in more than one Figurio surface.
- The component carries business meaning, such as price, shipping, proof status, or order status.
- The component needs consistent behavior across responsive breakpoints.
- Accessibility, focus management, or keyboard handling should be standardized.

### Keep it local when

- The UI is a one-off layout for a single page.
- The interaction is tightly bound to page-specific logic.
- Reuse would make the API broad, ambiguous, or brittle.

## Recommended Building Blocks

- `Section`, `Stack`, `Cluster`, and `Split` for layout structure.
- `Card`, `InsetCard`, and `Surface` for visual containment.
- `Badge`, `StatusPill`, and `Tag` for compact semantic labels.
- `Price`, `DiscountedPrice`, and `Money` for money formatting.
- `Stepper`, `Timeline`, and `ProgressBar` for fulfillment and proof flows.
- `Field`, `FieldHint`, `FieldError`, and `FormRow` for form composition.
- `EmptyState`, `ErrorState`, and `Skeleton` for non-happy paths.
- `ActionBar` and `StickySummary` for conversion-critical actions.

## Commerce-Specific Patterns

- Model product selection as a clear state machine: variant, quantity, customization, lead time, and availability.
- Show price changes as the result of user choice, not as surprise updates.
- Make shipping, delivery windows, and production timing visible wherever they affect intent.
- Treat proof approval and revision as first-class workflow states.
- Show order status as a timeline with clear next action, not just a static label.

## Form And Interaction Rules

- Every input must have a label, and every error must be tied to the relevant field.
- Use inline validation for recoverable problems and keep submit errors near the action.
- Preserve focus order and keyboard access across all interactive elements.
- Never hide essential checkout or approval actions behind hover-only affordances.
- Disable destructive or irreversible actions only when the required preconditions are truly unmet.

## Responsive Behavior

- Start mobile-first, then verify tablet and desktop refinements.
- Keep critical actions reachable without precision gestures.
- Avoid layout shifts when validation, pricing, or status content appears.
- If a component collapses on mobile, keep the primary action visible or pinned.

## Accessibility Checklist

- Use semantic elements before ARIA.
- Ensure focus rings are visible on every interactive primitive.
- Provide descriptive labels for icon-only actions.
- Announce dynamic state changes that matter, such as price updates, approval status, or errors.
- Respect reduced motion and avoid animations that obscure content changes.

## Anti-Patterns

- Large prop bags that mix layout, content, and data-fetching concerns.
- Custom controls that duplicate Radix behavior without a strong reason.
- Variants that exist only because they are possible, not because the product needs them.
- Components that hide business rules behind generic names like `InfoBox` or `Banner`.
- Shared components that embed page-specific copy, routing, or analytics.

## Review Checklist

- Can this be reused in another Figurio surface without rework?
- Does the API express the business meaning clearly?
- Are loading, empty, error, and disabled states defined?
- Is it accessible by keyboard and screen reader?
- Does the component still feel good in narrow mobile layouts?
- Would a product or design review understand what the component does from its name and props?
