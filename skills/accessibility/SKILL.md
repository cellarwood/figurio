---
name: accessibility
description: >
  WCAG 2.1 AA compliance checklist for Figurio e-commerce flows — catalog browsing,
  product filtering, 3D model preview, AI prompt interface, cart management,
  Stripe checkout, and order tracking. Focuses on keyboard navigation, screen reader
  support, and live-region announcements across the Figurio React/shadcn-ui stack.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags: [engineering, frontend, accessibility]
---

# Accessibility

WCAG 2.1 AA requirements applied to the Figurio storefront. The baseline is Radix UI primitives (via shadcn-ui), which handle most ARIA patterns — these rules cover Figurio-specific flows where extra attention is needed.

## General Baseline

- Color contrast: all text on background must meet 4.5:1 (normal text) or 3:1 (large text / UI components). Validate with Tailwind color pairings — do not introduce one-off hex colors without a contrast check.
- Focus ring: never remove the default Radix focus ring. Tailwind `outline-none` is only allowed on an element that provides a **custom** visible focus indicator (`ring-2 ring-offset-2`).
- Interactive elements are `<button>` or `<a>` — never `<div onClick>` or `<span onClick>`.
- All images have `alt` text. Decorative images use `alt=""` and `role="presentation"`.
- Minimum touch/click target size: 44 × 44 px (use `min-h-11 min-w-11` or `size-11` in Tailwind).

## Catalog Browsing

- Product grid is a `<ul role="list">` with each `ProductCard` as an `<li>`. This enables screen reader list navigation.
- Badges (`new`, `trending`, `seasonal`) must be announced: include visually-hidden text inside the badge `<span>`, e.g. `<span className="sr-only">Badge: </span>trending`.
- "Add to cart" button carries `aria-label="Add {product name} to cart"` — the visible label alone ("Add to cart") is ambiguous when multiple cards are on screen.
- Lazy-loaded images use `loading="lazy"` and include width/height attributes to prevent layout shift (CLS).

## Product Filtering

- Filter panel is a `<form>` wrapping all controls. Submitting with Enter works without JavaScript event overrides.
- Each filter group (size tier, price range, category) uses `<fieldset>` + `<legend>` for screen reader grouping.
- Active filter count is announced via `aria-live="polite"` region: "Showing 12 results" updates automatically on filter change.
- Filter checkboxes and radio buttons use native `<input type="checkbox">` / `<input type="radio">` — do not replace with custom Radix `Checkbox` unless you preserve the fieldset/legend grouping.

## 3D Model Preview Viewer (`ModelViewer`)

The 3D canvas is not perceivable by screen readers — compensate:

- Wrap the `<canvas>` in a `<figure>` with `aria-label` describing the model, e.g. `aria-label="3D preview of Steampunk Cat figurine, rotatable"`.
- Add a `<figcaption className="sr-only">` with a text description of the figurine.
- Rotation controls (if keyboard-exposed): `ArrowLeft`/`ArrowRight` keys rotate by 15°; announce the current angle via an `aria-live="polite"` off-screen region.
- Loading state: use `aria-busy="true"` on the `<figure>` while the model loads; remove on completion.
- The Approve / Request Revision buttons in the AI approval context must be reachable by Tab and have distinct `aria-label` values, e.g. `aria-label="Approve this 3D model"`.

## AI Prompt Interface (`PromptStudio`)

- Textarea has `aria-label="Describe your figurine"` and `aria-describedby` pointing to the character count `<p>`.
- Character count `<p>` uses `aria-live="polite"` so remaining characters are announced as the user types (but not on every keystroke — debounce by 500 ms via a separate state variable used only for the live region).
- Content moderation error `Alert` uses `role="alert"` so it is announced immediately without the user needing to navigate to it.
- Size tier `RadioGroup` (Radix) includes visible labels with size and price. The selected tier must be announced on change: Radix handles this natively — do not override `aria-checked`.
- The deposit pricing note (`<p>`) is not hidden (`aria-hidden`) — it must be read by screen readers as it is material purchase information.

## Cart Management (`CartDrawer`)

- The `Sheet` trigger (cart icon button) has `aria-label="Open cart"` and `aria-expanded` reflecting drawer state. Radix `Sheet` manages this if you pass the trigger through `SheetTrigger`.
- When the drawer opens, focus moves to the first interactive element inside (Radix `Sheet` does this — do not override `onOpenAutoFocus`).
- Item quantity controls: increment button `aria-label="Increase quantity of {name}"`, decrement `aria-label="Decrease quantity of {name}"`.
- When an item is removed, announce via `aria-live="assertive"` region: "{name} removed from cart."
- Cart item count badge on the trigger updates `aria-label` to include the count: `aria-label="Open cart, 3 items"`.

## Stripe Checkout (`CheckoutForm`)

- Stripe `PaymentElement` is an iframe with its own accessibility tree — do not interfere with its ARIA attributes.
- The pay button `aria-label` includes the total: `aria-label="Pay €49.90"`.
- While payment is processing, set `aria-busy="true"` on the form and disable the button with `disabled` (not just a CSS visual change).
- On success, redirect to `/orders/{id}` — use `router.push()` (Next.js) or `navigate()` (React Router); the new page title announces the success to screen readers via `<title>Order confirmed — Figurio</title>`.
- On Stripe error, render an `Alert` with `role="alert"` beneath the pay button so it is immediately announced.

## Order Tracking Dashboard (`OrderTracker`)

- The status stepper uses `role="list"` on the step container and `role="listitem"` on each step.
- Current step: `aria-current="step"` on the active step element.
- Completed steps: `aria-label="{Step name}, completed"` using the `CheckCircle2` icon with `aria-hidden="true"` and a visually-hidden text sibling.
- When status polls and changes, announce the new status via `aria-live="polite"`: "Order status updated: Printing."
- External tracking link has `aria-label="Track shipment (opens in new tab)"` to warn screen reader users of the new-tab behavior.

## Keyboard Navigation Checklist

Apply this checklist when reviewing any new Figurio page or flow:

- [ ] All interactive elements reachable by Tab in logical DOM order
- [ ] No keyboard traps (except modal dialogs — trap is correct there, Radix handles it)
- [ ] Dialogs/modals: focus moves in on open, returns to trigger on close
- [ ] Dropdowns and menus: `ArrowDown`/`ArrowUp` navigate items, `Escape` closes
- [ ] Forms: `Enter` submits, `Escape` cancels where appropriate
- [ ] Skip-to-content link is the first focusable element on every page: `<a href="#main-content" className="sr-only focus:not-sr-only">Skip to content</a>`

## Screen Reader Testing

Test all Figurio flows with at minimum:

- VoiceOver + Safari (macOS/iOS) — primary for EU customer base
- NVDA + Firefox (Windows) — secondary

Automated linting: `eslint-plugin-jsx-a11y` must be enabled in the project ESLint config with no suppressed rules on Figurio components.
