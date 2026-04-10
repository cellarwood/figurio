---
name: accessibility
description: >
  Accessibility standards for the Figurio storefront: WCAG 2.1 AA compliance,
  keyboard navigation, screen reader support, and color contrast handling for
  product imagery and UI elements. Apply whenever building or reviewing any
  storefront component or page.
allowed-tools:
  - Read
  - Grep
  - Bash
metadata:
  paperclip:
    tags:
      - engineering
      - frontend
      - review
---

# Accessibility

Figurio targets **WCAG 2.1 Level AA** across the entire storefront. The baseline
is non-negotiable — all new components must pass before merge.

---

## Color Contrast

### Text on backgrounds

| Context | Minimum ratio | Notes |
|---------|---------------|-------|
| Body text on white | 4.5:1 | Standard requirement |
| Large text (≥18pt or ≥14pt bold) | 3:1 | Headings, CTA labels |
| UI component borders (inputs, buttons) | 3:1 | Focused or active state |

### Product imagery considerations

3D figurine renders often sit on white or gradient backgrounds. Rules:

- Size tier badges (S/M/L) placed over thumbnails **must use opaque backgrounds** — semi-transparent overlays fail contrast checks at low opacity
- Price labels overlaid on product images require a `bg-black/60` scrim underneath
- Do not rely on color alone to convey size tier — always include the text label (e.g., "M · 15 cm"), not just the badge color

### Tailwind color choices

Use the pre-vetted token pairings from `component-patterns`:

- `bg-sky-100 text-sky-800` (Small badge) — passes at 5.9:1
- `bg-violet-100 text-violet-800` (Medium badge) — passes at 6.2:1
- `bg-amber-100 text-amber-800` (Large badge) — passes at 5.1:1

Avoid Tailwind `*-300` or lighter text on white — these reliably fail.

---

## Keyboard Navigation

Every interactive element must be reachable and operable via keyboard alone.

### Focus order

- Follows DOM source order — do not use `tabindex > 0`; fix DOM order instead
- Skip-to-content link is the first focusable element in `<body>`:
  ```tsx
  <a href="#main-content" className="sr-only focus:not-sr-only focus:fixed focus:top-4 focus:left-4 focus:z-50 focus:bg-white focus:px-4 focus:py-2 focus:rounded focus:shadow">
    Skip to main content
  </a>
  ```

### Focus ring

Never suppress the focus ring with `outline-none` unless a custom ring is provided. Use:
```css
/* global base styles */
:focus-visible {
  outline: 2px solid theme('colors.violet.600');
  outline-offset: 2px;
}
```

Tailwind equivalent on components: `focus-visible:ring-2 focus-visible:ring-violet-600 focus-visible:ring-offset-2`

### Component-specific requirements

**Product card:**
- Entire card is keyboard-focusable via `role="article"` wrapper; the "Add to Cart" button inside is separately focusable
- Do not make the entire card a `<button>` — it contains interactive children

**Cart drawer:**
- Focus moves into the drawer on open (first focusable element: close button)
- Trap focus within the drawer while open (Radix `Sheet` handles this automatically)
- Return focus to the cart icon trigger on close

**3D model viewer:**
- Canvas must accept `tabindex="0"` and handle `ArrowLeft`/`ArrowRight`/`ArrowUp`/`ArrowDown` for rotation as a keyboard alternative to mouse drag
- Provide a visible "Use arrow keys to rotate model" hint on focus

**Checkout form:**
- Stripe Elements fields are internally keyboard accessible; do not interfere with their tab order
- "Pay now" button must not be replaced with a `<div>` — keep it a real `<button type="submit">`

**Order status timeline:**
- Each step is a `<li>` inside a `<ol aria-label="Order progress">`
- Current step carries `aria-current="step"`

---

## Screen Reader Support

### Semantic HTML first

- Page landmarks: `<header>`, `<main id="main-content">`, `<nav>`, `<footer>` — no `<div>` soup
- Product listings: `<ul>` / `<li>` with `role="list"` (preserves semantics in Safari with `list-style: none`)
- Headings follow a strict hierarchy — one `<h1>` per page, no skipped levels

### ARIA usage rules

- Only add ARIA when native semantics are insufficient
- Prefer `aria-label` over `aria-labelledby` for self-contained components; use `aria-labelledby` when a visible heading already names the region
- Never use `aria-hidden="true"` on focusable elements

### Figurio-specific aria patterns

**Product card thumbnail:**
```tsx
<img
  src={thumbnailUrl}
  alt={`${name} — ${sizeTier} figurine, ${priceCZK} CZK`}
  loading="lazy"
/>
```
Include size and price in alt so screen reader users get the same scanned information sighted users get.

**3D model viewer:**
```tsx
<div
  role="img"
  aria-label={`Interactive 3D preview of ${name}. Use arrow keys or mouse to rotate.`}
>
  <canvas tabIndex={0} />
</div>
```

**Cart item quantity stepper:**
```tsx
<button aria-label={`Decrease quantity of ${name}`}>−</button>
<span aria-live="polite" aria-atomic="true">{quantity}</span>
<button aria-label={`Increase quantity of ${name}`}>+</button>
```

**Order timeline step (current):**
```tsx
<li aria-current="step">
  <span className="sr-only">Current step: </span>Printing
</li>
```

**Loading states:**
```tsx
<div role="status" aria-live="polite" aria-label="Loading product catalog" />
```

---

## Motion & Animation

- Respect `prefers-reduced-motion`: wrap all GSAP animations in a check:
  ```tsx
  const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (!prefersReduced) {
    gsap.from(cartDrawerRef.current, { x: '100%', duration: 0.3, ease: 'power2.out' });
  }
  ```
- Auto-rotating 3D viewer must pause when `prefers-reduced-motion` is set
- No content should flash more than 3 times per second (seizure safety)

---

## Testing Checklist

Run before any PR touching UI:

- [ ] `axe-core` browser extension or `@axe-core/react` shows zero violations
- [ ] Tab through entire flow without mouse — every action reachable
- [ ] VoiceOver (macOS) or NVDA (Windows): product card, checkout form, and order timeline are announced correctly
- [ ] Color contrast verified with browser DevTools or Colour Contrast Analyser for any new color pairs
- [ ] `prefers-reduced-motion` tested by toggling in OS accessibility settings
- [ ] All images have non-empty `alt` text (decorative images use `alt=""`)
