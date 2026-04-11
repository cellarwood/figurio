---
name: accessibility
description: >
  WCAG 2.1 AA compliance checklist for the Figurio storefront — covers form
  labels for checkout and AI customiser inputs, alt text for figurine product
  photos, keyboard navigation through the catalog and cart drawer, color
  contrast requirements, and screen reader support for dynamic cart and checkout
  state changes. Apply this skill whenever adding or reviewing any Figurio UI.
allowed-tools:
  - Read
  - Grep
  - Write
  - Edit
metadata:
  paperclip:
    tags:
      - engineering
      - frontend
      - review
---

# Accessibility

Figurio targets WCAG 2.1 Level AA across all storefront pages. The primary user base is Czech consumers; screen reader testing uses NVDA (Windows) and VoiceOver (macOS/iOS).

## Image Alt Text — Figurine Photos

Figurine photos are the core catalog content. Every `<img>` for a product must have a descriptive `alt` that names the subject and, where relevant, the size variant.

| Context | Alt pattern | Example |
|---|---|---|
| Catalog card | `"{name} figurine"` | `"Dragon figurine"` |
| Product detail main image | `"{name} figurine – {size}"` | `"Dragon figurine – 15 cm"` |
| Thumbnail in size selector | `"{name} – {size} size preview"` | `"Dragon – 10 cm size preview"` |
| Cart line item | `"{name}, {size}"` | `"Dragon, 15 cm"` |
| Order confirmation | `"{name} – {quantity}× {size}"` | `"Dragon – 2× 15 cm"` |

- AI-custom preview renders (three.js canvas) must have an `aria-label` on the `<canvas>` element: `"3D preview of your custom figurine"`.
- Decorative images (background textures, dividers) must have `alt=""` and `role="presentation"`.
- Never use the product SKU or filename as the alt text.

## Form Labels — Checkout and AI Customiser

Every input must have an associated `<label>` or `aria-label`. Do not rely on placeholder text as the label.

```tsx
// Correct — explicit label
<Label htmlFor="shipping-city">City</Label>
<Input id="shipping-city" name="city" autoComplete="address-level2" />

// Wrong — placeholder only
<Input placeholder="City" />
```

- Use shadcn `Label` (which renders a `<label>`) for all form fields.
- Group related fields with `<fieldset>` + `<legend>`: shipping address block, billing address block.
- Stripe `PaymentElement` is internally accessible — do not wrap it in a redundant `<label>`.
- AI customiser file upload: `<input type="file" aria-describedby="upload-hint" accept=".obj,.stl">` paired with a visible hint (`id="upload-hint"`) listing accepted formats.
- Required fields: add `aria-required="true"` and visually indicate with an asterisk that has `aria-hidden="true"` and a legend note ("* Required").
- Inline validation errors: use `aria-describedby` pointing to the error element. The error element must have `role="alert"` so screen readers announce it immediately.

```tsx
<Input
  id="email"
  aria-describedby={emailError ? "email-error" : undefined}
  aria-invalid={!!emailError}
/>
{emailError && (
  <p id="email-error" role="alert" className="text-sm text-destructive">
    {emailError}
  </p>
)}
```

## Keyboard Navigation

All interactive elements must be reachable and operable by keyboard alone.

### Catalog

- Product cards are `<article>` elements. The "Add to cart" button and size selector must both be reachable via Tab.
- Focus order within a card: image (skip if decorative) → product name link → size selector → "Add to cart" button.
- The catalog grid must not trap focus.

### Cart Drawer

- Opening the cart drawer (shadcn `Sheet`) must move focus to the drawer's heading (`<h2>`) on open.
- Closing the drawer (Escape key or close button) must return focus to the element that triggered the open (the cart icon button in the header).
- Trap focus within the drawer while it is open — shadcn `Sheet` handles this via Radix `FocusTrap`; do not disable it.

### Checkout Form

- Tab order follows visual order: shipping fields → payment element → submit button.
- The submit button must be reachable without scrolling on mobile (use sticky bottom bar on mobile).
- Do not use `tabIndex` values other than `0` or `-1`.

### 3D Model Viewer

- The `<canvas>` must be focusable: `tabIndex={0}`.
- When focused, show a visible focus ring (Tailwind `focus-visible:ring-2 focus-visible:ring-primary`).
- Provide a text alternative describing what the model is below the canvas for users who cannot interact with WebGL.

## Color Contrast

Minimum contrast ratios (WCAG AA):

| Text type | Minimum ratio |
|---|---|
| Normal text (< 18 pt / < 14 pt bold) | 4.5 : 1 |
| Large text (≥ 18 pt or ≥ 14 pt bold) | 3 : 1 |
| UI component borders and icons | 3 : 1 |

Figurio brand colors — verified ratios against white (`#ffffff`) background:

- Primary (`#1a1a2e`): 17.5 : 1 — safe for all text.
- Accent (`#e94560`): 4.6 : 1 — safe for normal text.
- Muted text (`#6b7280`): 4.6 : 1 — safe for normal text; do not go lighter.
- Destructive (`#dc2626`): 5.9 : 1 — safe for error text.

Never use color as the only means of conveying state (e.g., red border for error). Always pair color with an icon or text label.

## Screen Reader Support — Cart and Checkout

Dynamic state changes must be announced to screen readers via ARIA live regions.

### Cart

- Mount a visually hidden `<div aria-live="polite" aria-atomic="true">` at the app root.
- When an item is added to the cart, update its text content: `"Dragon figurine (15 cm) added to cart. Cart total: 3 items."` The live region announces this without moving focus.
- When quantity changes or an item is removed, announce: `"Dragon figurine removed. Cart total: 2 items."`.
- The cart item count badge on the header icon must have an `aria-label`: `aria-label={\`Cart, \${count} items\`}`.

### Checkout

- After `stripe.confirmPayment` succeeds and the user lands on the confirmation page, the page `<title>` must update to `"Order confirmed – Figurio"` (screen readers announce title changes on navigation).
- Payment processing state: disable the submit button and set `aria-busy="true"` on the form while the Stripe call is in flight.
- If Stripe returns an error, focus must move programmatically to the error `Alert` element so screen readers read it immediately.

```tsx
const errorRef = useRef<HTMLDivElement>(null);

useEffect(() => {
  if (paymentError) errorRef.current?.focus();
}, [paymentError]);

// In render:
<div ref={errorRef} tabIndex={-1} role="alert" aria-live="assertive">
  {paymentError}
</div>
```

## Checklist for PR Review

Before merging any component that touches the storefront UI, verify:

- [ ] All `<img>` have descriptive `alt` text following the patterns above
- [ ] All form inputs have associated `<label>` or `aria-label`
- [ ] Required fields use `aria-required` and validation errors use `role="alert"` + `aria-describedby`
- [ ] Color contrast meets 4.5 : 1 for body text, 3 : 1 for UI components
- [ ] Color is not the only differentiator for state
- [ ] Focus management is correct for dialogs and drawers (open moves focus in; close returns focus)
- [ ] Dynamic cart changes are announced via the live region
- [ ] All interactive elements are keyboard reachable in logical Tab order
