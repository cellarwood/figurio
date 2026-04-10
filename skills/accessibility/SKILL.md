---
name: accessibility
description: >
  Accessibility standards for the Figurio storefront — WCAG 2.1 AA compliance for a D2C
  3D-printed figurine shop. Covers keyboard navigation for the Three.js 3D viewer, screen
  reader support for the product catalog, contrast ratios, and focus management in the
  multi-step checkout flow.
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

Apply this skill when building or reviewing any Figurio storefront component — especially the 3D figurine viewer, product catalog, AI prompt builder, and checkout flow. All UI must meet WCAG 2.1 AA.

## Core Standard

Target: **WCAG 2.1 AA**. Every new component must pass before merging.

Radix UI primitives (via shadcn-ui) handle most ARIA roles and keyboard behavior automatically. Do not reimplement what Radix already provides — but do verify that custom components and non-Radix elements comply.

## Color Contrast

| Use | Minimum ratio |
|---|---|
| Body text on background | 4.5:1 |
| Large text (18px+ or 14px+ bold) | 3:1 |
| UI components (borders, icons, focus rings) | 3:1 |

Figurio brand accent (used on CTA buttons) must pass 4.5:1 against its button background. If the design uses a light figurine-preview background, verify text overlays still meet contrast before shipping.

Do not rely on color alone to convey state — use icon + label or border changes in addition to color.

## Keyboard Navigation

All interactive elements must be reachable and operable via keyboard in DOM order.

- Tab order must follow visual reading order (top-left to bottom-right)
- Focusable elements: buttons, links, form fields, custom controls
- No keyboard traps except intentional modal dialogs (which must have an Escape handler)

### Focus Rings

Never suppress focus outlines globally (`outline: none` is forbidden without a visible replacement). Use Tailwind's `focus-visible:ring-2 focus-visible:ring-ring` pattern from shadcn-ui — it shows rings only for keyboard users.

```tsx
// Correct — shadcn-ui Button already includes this; apply manually on custom elements
<button className="... focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
```

## 3D Viewer Keyboard and Screen Reader Support

The Three.js canvas is visual-only. It must have a text alternative and optional keyboard controls.

### Minimum requirement (all figurine pages)

```tsx
<div
  ref={canvasRef}
  role="img"
  aria-label={`Interactive 3D preview of ${figurine.name}. Drag to rotate, scroll to zoom.`}
  tabIndex={-1}          // not in tab order — controlled by adjacent buttons
/>
```

### Enhanced keyboard controls (product detail page)

Provide visible control buttons adjacent to the canvas that manipulate the Three.js camera. Keyboard users should not need to operate the canvas directly:

```tsx
<div className="flex gap-2 mt-2" role="group" aria-label="3D viewer controls">
  <Button variant="outline" size="sm" onClick={() => rotateLeft()} aria-label="Rotate left">
    <RotateCcw className="h-4 w-4" aria-hidden="true" />
  </Button>
  <Button variant="outline" size="sm" onClick={() => rotateRight()} aria-label="Rotate right">
    <RotateCw className="h-4 w-4" aria-hidden="true" />
  </Button>
  <Button variant="outline" size="sm" onClick={() => resetCamera()} aria-label="Reset view">
    Reset
  </Button>
</div>
```

When Three.js controls (OrbitControls) capture pointer events, ensure they do not consume keyboard events from the rest of the page.

## Product Catalog Screen Reader Support

### ProductCard

Each card must communicate product name, price, and availability as a coherent unit:

```tsx
<article aria-label={`${product.name}, ${formatCZK(product.price)}`}>
  <img
    src={product.imageUrl}
    alt={`${product.name} figurine`}
    className="aspect-square w-full object-cover"
  />
  <h3 className="text-sm font-medium">{product.name}</h3>
  <p className="text-sm text-muted-foreground" aria-label={`Price: ${formatCZK(product.price)}`}>
    {formatCZK(product.price)}
  </p>
  {!product.inStock && (
    <p className="text-xs text-destructive" aria-live="polite">Out of stock</p>
  )}
</article>
```

### Filter Bar

Filter controls use `role="group"` with an `aria-labelledby` pointing to the filter section heading. Active filter state is communicated via `aria-pressed` on toggle buttons:

```tsx
<div role="group" aria-labelledby="filter-heading">
  <h2 id="filter-heading" className="sr-only">Filter figurines</h2>
  <Button
    variant={activeStyle === "anime" ? "default" : "outline"}
    aria-pressed={activeStyle === "anime"}
    onClick={() => setActiveStyle("anime")}
  >
    Anime
  </Button>
</div>
```

When filters update the grid, announce the result count to screen readers:

```tsx
<p aria-live="polite" aria-atomic="true" className="sr-only">
  {filteredCount} figurines found
</p>
```

## AI Prompt Builder

The multi-step prompt builder must communicate step progress:

```tsx
<div aria-label="Customization progress" role="group">
  <Progress value={stepPercent} aria-valuenow={stepPercent} aria-valuemin={0} aria-valuemax={100} />
  <p className="sr-only">Step {currentStep} of {totalSteps}: {stepLabel}</p>
</div>
```

When moving between steps, shift focus to the new step's heading:

```tsx
const stepHeadingRef = useRef<HTMLHeadingElement>(null);

useEffect(() => {
  stepHeadingRef.current?.focus();
}, [currentStep]);

<h2 ref={stepHeadingRef} tabIndex={-1} className="text-lg font-semibold focus:outline-none">
  {stepLabel}
</h2>
```

Form validation errors must use `aria-describedby` linking the input to its error message:

```tsx
<Input
  id="subject-input"
  aria-describedby={subjectError ? "subject-error" : undefined}
  aria-invalid={!!subjectError}
/>
{subjectError && (
  <p id="subject-error" role="alert" className="text-sm text-destructive">
    {subjectError}
  </p>
)}
```

## Checkout Focus Management

On step transitions (Cart → Shipping → Payment), move focus to the new step heading immediately after navigation. Use React Router's `useEffect` on location change:

```tsx
useEffect(() => {
  pageHeadingRef.current?.focus();
}, [location.pathname]);
```

Stripe `<PaymentElement />` manages its own internal focus — do not attempt to override it. Ensure the submit button follows the Stripe element in DOM order and is reachable without tabbing through unrelated content.

Loading states during payment processing must block interaction and communicate status:

```tsx
<Button disabled={isProcessing} aria-busy={isProcessing}>
  {isProcessing ? "Processing payment…" : "Pay now"}
</Button>
```

## Images and Icons

- Decorative images: `alt=""`
- Informational images (figurine previews, catalog thumbnails): descriptive `alt` text
- Icon-only buttons: always include `aria-label`; add `aria-hidden="true"` to the icon element itself

```tsx
// Correct
<Button aria-label="Remove item from cart">
  <Trash2 className="h-4 w-4" aria-hidden="true" />
</Button>
```

## Anti-patterns

- Do not use `tabIndex` values greater than 0 — it breaks natural tab order
- Do not use `onClick` on `<div>` or `<span>` — use `<button>` or Radix primitives
- Do not hide content with `visibility: hidden` that is expected to be read by screen readers
- Do not use placeholder text as the only label for inputs — always include a `<label>` or `aria-label`
- Do not use `aria-live="assertive"` except for critical errors — use `polite` for status updates
