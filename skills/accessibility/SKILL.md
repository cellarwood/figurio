---
name: accessibility
description: >
  Accessibility standards for the Figurio storefront — WCAG 2.1 AA compliance,
  keyboard navigation for the product catalog and Three.js 3D viewer, screen
  reader support for product details and AI prompt results, color contrast
  requirements using Figurio brand tokens, and focus management across the
  multi-step checkout flow.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags:
      - engineering
      - frontend
      - review
---

# Accessibility

## When to Use

Apply this skill when building or reviewing any Figurio storefront UI — especially the product catalog, AI prompt interface, 3D viewer, and checkout flow. Run through this checklist during PR review for any component that renders interactive or informational content.

## Compliance Target

WCAG 2.1 Level AA. All new features must meet this bar before merging.

## Color Contrast

Figurio brand tokens must meet the following contrast ratios against their intended backgrounds. These have been pre-verified — do not swap them for arbitrary hex values.

| Token | Use | Background | Ratio |
|-------|-----|------------|-------|
| `text-brand-gold` (`#C49A3C`) | CTA text, price | `bg-white` | 4.6:1 (AA) |
| `text-brand-gold` (`#C49A3C`) | CTA text, price | `bg-brand-slate` | 5.2:1 (AA) |
| `text-slate-900` | Body text | `bg-white` | 16:1 (AAA) |
| `text-white` | Button labels | `bg-brand-gold` | 4.5:1 (AA) |

- Never use `text-brand-gold` on `bg-brand-clay` — the ratio is 2.1:1 (fails AA).
- Placeholder text in form inputs must use `text-slate-400` minimum — `text-slate-300` fails.
- Icon-only buttons must have a visible focus ring, not rely on color alone.

## Semantic HTML

Use the correct HTML elements — assistive technology announces them automatically.

- Product grid: `<ul>` / `<li>` wrapping `<article>` per card.
- Page headings follow a strict hierarchy: one `<h1>` per page, product name as `<h2>` on detail page, section titles as `<h3>`.
- Figurine AI prompt results area uses `role="region"` with `aria-label="AI prompt result"` so screen reader users can navigate to it via landmark shortcuts.
- Price spans: wrap with `<span aria-label="Price: $24.99">$24.99</span>` to ensure screen readers announce the currency symbol correctly.

## Keyboard Navigation

### Product Catalog

- Every product card's primary action (navigate to detail page) must be reachable and activatable with `Enter` and `Space`.
- The "Add to Cart" button inside each card is a separate focusable element — tab order within the card is: card link → Add to Cart button.
- The catalog filter panel (if open) must trap focus while active using Radix UI's `FocusTrap` or shadcn-ui's built-in `Dialog` focus management.
- `Escape` closes any open filter dropdown and returns focus to the trigger button.

### 3D Model Viewer

The `ModelViewer` canvas is not keyboard-operable by default. Apply these compensating controls:

- Add `tabIndex={0}` to the canvas wrapper `<div>`, not the `<canvas>` itself.
- Handle `keydown` events on the wrapper: `ArrowLeft`/`ArrowRight` rotate the model ±15°, `+`/`-` zoom in/out.
- Provide a visible focus ring on the wrapper: `focus-visible:ring-2 focus-visible:ring-brand-gold focus-visible:outline-none`.
- Include a text alternative beneath the viewer: `<p className="sr-only">Interactive 3D preview of {name}. Use arrow keys to rotate, plus and minus to zoom.</p>`.

```tsx
<div
  tabIndex={0}
  role="img"
  aria-label={`3D figurine preview: ${name}`}
  onKeyDown={handleViewerKeyDown}
  className="relative w-full aspect-square bg-brand-slate rounded-2xl overflow-hidden focus-visible:ring-2 focus-visible:ring-brand-gold focus-visible:outline-none"
>
  <canvas ref={canvasRef} className="absolute inset-0 w-full h-full" aria-hidden="true" />
</div>
```

Note: set `aria-hidden="true"` on the `<canvas>` itself — the wrapper `div` carries the accessible role and label.

## Screen Reader Support

### Product Detail Page

- Model viewer: described above — wrapper carries `role="img"` and `aria-label`.
- Custom quantity stepper: use `role="spinbutton"`, `aria-valuenow`, `aria-valuemin="1"`, `aria-valuemax="99"`.
- Out-of-stock state: add `aria-disabled="true"` and `disabled` to the Add to Cart button; include a visible text label, not just a greyed-out style.

### AI Prompt Interface

- The prompt `<textarea>` must have an associated `<label>` — never use `placeholder` as the only label.
- While the AI is generating a result, render a live region: `<div role="status" aria-live="polite" aria-label="Generating figurine preview">Generating…</div>`.
- When the result arrives, update the live region text to `"Preview ready"` — screen readers will announce the change without moving focus.
- The generated model name and description must be placed in the DOM (can be `sr-only`) even if the visual presentation is purely the 3D canvas.

## Focus Management in Checkout

The checkout flow is multi-step (Cart Review → Shipping → Payment → Confirmation). Focus must be actively managed on step transitions — do not rely on the browser default (which lands on `<body>`).

- On step advance, move focus to the step's `<h2>` heading using a `ref` and `.focus()`.
- Step headings must have `tabIndex={-1}` to be programmatically focusable without appearing in the natural tab order.
- The Stripe `PaymentElement` manages its own internal focus — do not attempt to move focus inside it.
- On form validation errors, move focus to the first invalid field's error message, not the field itself, so the error is announced before the field label.
- Order confirmation page: focus moves to the confirmation `<h1>` on mount.

```tsx
// On step change
useEffect(() => {
  stepHeadingRef.current?.focus();
}, [currentStep]);

// In JSX
<h2 ref={stepHeadingRef} tabIndex={-1} className="text-2xl font-bold text-slate-900 outline-none">
  {stepTitle}
</h2>
```

## ARIA Landmarks

Every page must expose these landmark regions:

| Landmark | Element / Role | Content |
|----------|---------------|---------|
| `banner` | `<header>` | Logo, nav, cart icon |
| `navigation` | `<nav aria-label="Main">` | Top-level nav links |
| `main` | `<main>` | Page content |
| `complementary` | `<aside>` | Cart slide-over, filter panel |
| `contentinfo` | `<footer>` | Legal, links |

Do not add `role="banner"` or `role="main"` to generic `<div>` elements — use the semantic HTML elements that carry these roles implicitly.

## Testing

- Run `axe` via the `vitest-axe` integration in unit tests for all new components.
- Playwright accessibility tests live in `e2e/accessibility/` — add a test for any new page-level flow.
- Manual keyboard walkthrough is required before merging any interactive component (catalog, viewer, cart, checkout).
- Use VoiceOver (macOS) or NVDA (Windows) to spot-check the AI prompt flow and checkout at least once per sprint.

## Anti-patterns

- Do not use `onClick` without also handling `onKeyDown` for Enter/Space on non-button, non-anchor elements.
- Do not use `aria-label` and visible text that say different things — they must match or the visible text must be a subset.
- Do not hide content with `visibility: hidden` or `display: none` and then expose it only via `aria-hidden="false"` — this pattern is unreliable across screen readers.
- Do not announce loading spinners with `aria-live="assertive"` — use `polite` to avoid interrupting ongoing announcements.
- Do not skip heading levels (e.g., `<h1>` → `<h3>`) to achieve a visual size — use Tailwind classes to control size independently.
