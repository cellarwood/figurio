---
name: accessibility
description: >
  WCAG 2.1 AA compliance checklist for the Figurio e-commerce storefront —
  covers form labeling, keyboard navigation, product image alt text, checkout
  flow focus management, and screen reader support for the cart drawer and
  3D model viewer.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - frontend
      - review
---

# Accessibility

WCAG 2.1 AA requirements as applied to the Figurio React storefront. Follow
these rules during implementation and use them as a review checklist before
marking any frontend PR ready for merge.

## Forms

All forms (checkout, contact, newsletter signup) MUST:

- Associate every `<input>`, `<select>`, and `<textarea>` with a visible `<label>`
  via `htmlFor` / `id` — never rely on `placeholder` alone as a label.
- Use shadcn `FormMessage` to surface validation errors; the error element MUST be
  linked to its input with `aria-describedby`.
- Mark required fields with `aria-required="true"` and a visible indicator (an
  asterisk `*` with a legend: `"* required field"`).
- Never use color alone to signal an error — pair color change with an icon (`AlertCircle`)
  and text.
- The Zásilkovna iframe in `ShippingStep` MUST have a `title` attribute:
  `title="Zásilkovna pickup point selector"`.

### Checkout Flow Focus Management

- On step transition (1 → 2 → 3), move focus to the new step's heading using
  `ref.current.focus()` — the heading MUST have `tabIndex={-1}`.
- On Stripe payment error, move focus to the `CardElement` container and announce
  the error via an `aria-live="assertive"` region.
- After successful order submission, focus the confirmation heading on the success page.

## Navigation

- The top navigation MUST be wrapped in `<nav aria-label="Main navigation">`.
- The cart icon button MUST have `aria-label="Open cart"` and update to
  `aria-label="Open cart, {n} items"` when the cart is non-empty (use
  `useCartStore` count).
- Skip-to-content link: render `<a href="#main-content" className="sr-only focus:not-sr-only ...">Skip to content</a>`
  as the very first element in `<body>`; the main content container MUST have `id="main-content"`.
- Keyboard users MUST be able to open/close the `CartDrawer` (`Sheet`) with `Escape`
  — shadcn `Sheet` handles this by default; do not suppress it.

## Product Images & 3D Viewer

- Every `<img>` in `ProductCard` and on the product detail page MUST have a
  descriptive `alt` that names the figurine and angle:
  - Good: `alt="Dragon Warrior figurine — side view, blue and gold paint scheme"`
  - Bad: `alt="product"` or `alt=""`
- Decorative images (background textures, dividers) MUST use `alt=""` and `role="presentation"`.
- The `<model-viewer>` web component MUST have an `aria-label` describing the
  figurine: `aria-label="Interactive 3D view of Dragon Warrior figurine"`.
- Provide a static fallback image via `poster` — this also serves as the visible
  content when JS is disabled or the WebGL context fails.
- Do not autoplay rotation on the 3D viewer without a pause control — users with
  vestibular disorders can be affected. Provide a visible "Pause rotation" toggle button.

## Color & Contrast

- Body text on white backgrounds: minimum contrast ratio 4.5:1 (WCAG AA).
- Large text (≥ 18 pt / 24 px or ≥ 14 pt bold): minimum 3:1.
- Interactive elements (buttons, links): borders or underlines must meet 3:1 against
  adjacent background — do not rely on color alone to distinguish links from body text.
- Price text (muted CZK secondary): verify the muted Tailwind color (`text-muted-foreground`)
  passes 4.5:1 against the card background — if not, step up to `text-foreground/70`.

## Screen Reader Support

- `CartDrawer` (`Sheet`): when opened, the drawer MUST trap focus inside; shadcn
  `Sheet` does this via Radix UI — do not remove `FocusTrap`.
- Empty cart state: announce with `aria-live="polite"` when items are removed
  and the cart becomes empty.
- Loading states: use `aria-busy="true"` on the parent container while data fetches;
  `Skeleton` placeholders are visual only and MUST have `aria-hidden="true"`.
- Toast notifications (order confirmed, added to cart): rendered via shadcn `Toaster`
  which uses `role="status"` and `aria-live="polite"` — do not replace with custom
  alert components.
- Quantity stepper buttons (`+` / `−`) in cart line items MUST have explicit
  `aria-label`: `"Increase quantity of Dragon Warrior figurine"`,
  `"Decrease quantity of Dragon Warrior figurine"`.

## Keyboard Interaction Table

| Component | Expected keyboard behavior |
|---|---|
| `ProductCard` | `Enter` / `Space` on "Add to Cart" button triggers add |
| `CartDrawer` | `Escape` closes; focus returns to the cart trigger button |
| `CheckoutForm` steps | `Tab` moves forward, `Shift+Tab` backward through fields |
| `ModelViewer` | `Tab` into viewer; arrow keys orbit (built into `model-viewer`) |
| Zásilkovna iframe | `Tab` enters iframe; `Escape` should return focus to page |

## Testing Checklist (Pre-merge)

- [ ] Run `axe-core` via `@axe-core/react` in dev mode — zero violations at AA level.
- [ ] Tab through the full checkout flow without a mouse — every field reachable.
- [ ] Test with VoiceOver (macOS) or NVDA (Windows) on the cart drawer and checkout.
- [ ] Verify all `<img>` elements have non-empty, descriptive `alt` text.
- [ ] Confirm focus is visible (not just browser default outline) on all interactive elements
      — Figurio's shadcn theme MUST NOT set `outline: none` without a custom
      focus-visible replacement.

## Anti-patterns

- Do not use `onClick` on `<div>` or `<span>` — use `<button>` or `<a>` elements.
- Do not suppress the browser focus ring globally (`*:focus { outline: none }`).
- Do not use `tabIndex={0}` on non-interactive elements to make them focusable.
- Do not remove `role="dialog"` or `aria-modal` from shadcn `Dialog`/`Sheet` — these
  are required for screen readers to understand the modal context.
