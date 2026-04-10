---
name: accessibility
description: >
  WCAG 2.1 AA compliance checklist and implementation patterns for the Figurio
  storefront. Covers keyboard navigation, screen reader support, color contrast,
  and focus management across the product catalog, cart drawer, Stripe Elements
  checkout flow, 3D model viewer, and order tracking pages.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - engineering
      - frontend
      - accessibility
---

# Accessibility

## When to Use

Apply this skill when building any Figurio storefront component, running an accessibility audit, reviewing a PR, or fixing a reported a11y issue. All pages must reach WCAG 2.1 AA before merging to main.

## Core Requirements

- **Color contrast:** text on background ≥ 4.5:1 (normal text), ≥ 3:1 (large text / UI components)
- **Keyboard navigation:** every interactive element reachable and operable with keyboard alone
- **Focus management:** focus moves predictably when overlays open/close
- **Screen reader support:** all content has a meaningful accessible name
- **No keyboard traps:** focus never gets stuck in a region
- **Motion:** respect `prefers-reduced-motion` for GSAP animations and carousel auto-play

## Color Contrast

Figurio's Tailwind config uses semantic tokens (`foreground`, `muted-foreground`, `primary`). The minimum ratios for each token pair are verified in the design system. When extending with custom colors always run the new pair through a contrast checker before using.

Tokens that pass AA by default:
- `text-foreground` on `bg-background` — passes
- `text-muted-foreground` on `bg-muted` — passes (check if override applied)
- `text-primary-foreground` on `bg-primary` — passes

Do not use `text-muted-foreground` for interactive elements (links, buttons) — it often falls short of 4.5:1 in the light theme.

## Keyboard Navigation

### General Rules

- All `onClick` handlers on non-button elements must have a keyboard equivalent (`onKeyDown` for Enter/Space) — prefer using `<button>` or `<a>` instead
- Tab order must follow visual reading order; use `tabIndex` only to restore order when DOM order and visual order diverge
- Visible focus ring on every interactive element — never `outline: none` without a replacement (`focus-visible:ring-2 focus-visible:ring-ring` in Tailwind)

### Product Catalog

- Each `ProductCard` is a single tab stop; the card `<Link>` is the primary focusable element
- The "Add to Cart" button inside the card is a separate tab stop — do not nest focusable elements inside a focusable container without testing with a screen reader
- Filter checkboxes and select dropdowns use shadcn `Checkbox` and `Select` which inherit Radix keyboard behavior (arrows, Enter, Space, Escape)

### Cart Drawer

The `Sheet` (Radix `Dialog`) handles focus trapping automatically. Verify:
- Focus moves to the first focusable element inside `SheetContent` on open (`SheetTitle` or first close button)
- On close, focus returns to the element that triggered open (the cart icon in the nav)
- Radix `Sheet` does this out of the box via `returnFocus` — do not override it

```tsx
// Ensure the trigger has a ref Radix can return focus to
<SheetTrigger asChild>
  <Button variant="ghost" size="icon" aria-label="Open cart">
    <ShoppingCart className="h-5 w-5" />
    {itemCount > 0 && (
      <span className="sr-only">, {itemCount} items</span>
    )}
  </Button>
</SheetTrigger>
```

### Checkout Flow

Focus management between checkout steps is manual — Radix does not own it here.

On step transition:
1. Move focus to the heading of the newly active section using a `ref` and `.focus()`
2. Announce the transition to screen readers with a live region

```tsx
const stepHeadingRef = useRef<HTMLHeadingElement>(null)

useEffect(() => {
  stepHeadingRef.current?.focus()
}, [currentStep])

// In JSX
<h2 ref={stepHeadingRef} tabIndex={-1} className="text-lg font-semibold focus:outline-none">
  {stepLabel[currentStep]}
</h2>
```

Add a live region near the checkout root for status messages (validation errors, payment processing):

```tsx
<div aria-live="polite" aria-atomic="true" className="sr-only">
  {statusMessage}
</div>
```

Stripe `PaymentElement` is an iframe — it manages its own focus internally. Do not attempt to manage focus inside it. Announce payment errors via the live region, not by moving focus into the iframe.

### Order Tracking Page

The `OrderTimeline` list must convey current status without relying on color alone:

```tsx
<ol aria-label="Order status">
  {STATUS_STEPS.map((step, idx) => {
    const isComplete = idx < currentIdx
    const isCurrent = idx === currentIdx
    return (
      <li
        key={step}
        aria-current={isCurrent ? 'step' : undefined}
      >
        <StatusDot completed={isComplete} current={isCurrent} />
        <span>{STATUS_LABELS[step]}</span>
        {isComplete && <span className="sr-only">(completed)</span>}
        {isCurrent && <span className="sr-only">(current)</span>}
      </li>
    )
  })}
</ol>
```

## Screen Reader Support

### Images and Media

- Product images: `alt` must describe the figurine, not be generic (`alt="Dragon figurine, 15cm, matte grey"` not `alt="product"`)
- Decorative images (backgrounds, dividers): `alt=""`
- 3D model viewer: `alt` on `<model-viewer>` is the accessible description of the model; write it as you would alt text for a photo

### Interactive Labels

Every icon-only button must have `aria-label`:

```tsx
<Button variant="ghost" size="icon" aria-label="Remove item from cart">
  <Trash2 className="h-4 w-4" aria-hidden="true" />
</Button>
```

Icons inside labeled buttons use `aria-hidden="true"` to avoid double-announcing.

### Price Display

Screen readers should read prices naturally. Do not split currency symbol and amount into separate elements without `aria-label`:

```tsx
// Bad — reads "$ 49 . 99"
<span>$</span><span>49</span><span>.99</span>

// Good
<span aria-label="$49.99">$49.99</span>
```

For "from" pricing on product cards:

```tsx
<span aria-label={`From $${lowestPrice}`}>
  <span aria-hidden="true">From </span>${lowestPrice}
</span>
```

### Loading States

Skeleton screens are visual only — add a screen-reader announcement when data loads:

```tsx
{isLoading ? (
  <>
    <ProductGridSkeleton />
    <span className="sr-only" aria-live="polite">Loading products...</span>
  </>
) : (
  <>
    <ProductGrid products={products} />
    <span className="sr-only" aria-live="polite">{products.length} products loaded.</span>
  </>
)}
```

## 3D Model Viewer Accessibility

The `<model-viewer>` custom element has limited built-in accessibility. Compensate by:

1. Always providing a descriptive `alt` attribute on the element
2. Adding a visible "View 3D model" label above the viewer so the section is reachable by screen reader users navigating by heading/landmark
3. Wrapping in a `<figure>` with `<figcaption>` for the product detail page
4. Providing a static fallback image gallery alongside or below the viewer — 3D is an enhancement, not the sole presentation of the product

```tsx
<figure aria-label={`3D model of ${product.name}`}>
  <ModelViewer src={product.modelUrl} alt={`Interactive 3D view of ${product.name}`} />
  <figcaption className="sr-only">{product.name} — use mouse or touch to rotate the model</figcaption>
</figure>
```

## Reduced Motion

Wrap all GSAP animations in a motion check:

```ts
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches

if (!prefersReducedMotion) {
  gsap.to(element, { duration: 0.4, y: -8, opacity: 1 })
} else {
  gsap.set(element, { opacity: 1 }) // instant, no movement
}
```

For Tailwind transition classes, use `motion-safe:` prefix:

```html
<img class="motion-safe:transition-transform motion-safe:group-hover:scale-105" />
```

## Audit Checklist

Run this before marking a component done:

- [ ] All images have meaningful `alt` text (or `alt=""` for decorative)
- [ ] Every interactive element has a visible focus ring
- [ ] Icon-only buttons have `aria-label`
- [ ] Color is not the sole means of conveying information (status, error, current step)
- [ ] Text contrast meets 4.5:1 (use Chrome DevTools Accessibility panel)
- [ ] Keyboard tab order matches visual reading order
- [ ] Modals/drawers trap focus and return focus on close
- [ ] Form inputs have associated `<label>` elements (not just `placeholder`)
- [ ] Stripe payment form errors are surfaced via live region, not only visual
- [ ] `prefers-reduced-motion` respected for GSAP and Tailwind transitions
- [ ] Page has a single `<h1>` and heading hierarchy is logical (no skipped levels)
- [ ] Landmark regions present: `<header>`, `<main>`, `<nav>`, `<footer>`

## Anti-patterns

- `onClick` on a `<div>` or `<span>` without keyboard handling — use `<button>`
- `aria-label` duplicating visible text — redundant, skip it
- `tabIndex={0}` on non-interactive elements to make them focusable — make the element interactive instead
- Removing focus outlines with `focus:outline-none` alone — always pair with `focus-visible:ring-*`
- Using color alone to indicate required fields — pair with text ("Required") or `aria-required`
- Moving focus on every polling update in order tracking — only announce status changes, do not steal focus
