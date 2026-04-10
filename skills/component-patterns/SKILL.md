---
name: component-patterns
description: >
  React/shadcn-ui component patterns for the Figurio storefront (D2C 3D-printed figurines).
  Covers catalog product grid, figurine detail cards with Three.js 3D preview, AI custom
  figurine prompt builder, Stripe checkout flow components, and responsive layout conventions.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags:
      - engineering
      - frontend
      - components
---

# Component Patterns

## When to Use

Apply this skill when building or modifying any React component in the Figurio storefront — product catalog, figurine detail pages, AI prompt builder, or checkout flow.

## Stack Conventions

- **Components**: shadcn-ui primitives + Radix UI for headless behavior
- **Styling**: Tailwind CSS utility classes only — no custom CSS files unless Three.js canvas requires it
- **TypeScript**: strict mode; all props must be explicitly typed, no `any`
- **Routing**: React Router v6 (`useNavigate`, `<Link>`)
- **Animations**: GSAP for entrance/exit transitions; Tailwind `transition-*` for hover/focus states

## Component File Structure

```
src/
└── components/
    ├── catalog/
    │   ├── ProductGrid.tsx
    │   ├── ProductCard.tsx
    │   └── FilterBar.tsx
    ├── figurine/
    │   ├── FigurineDetail.tsx
    │   ├── FigurinePreview3D.tsx   # Three.js canvas wrapper
    │   └── FigurinePromptBuilder.tsx
    ├── checkout/
    │   ├── CheckoutFlow.tsx
    │   ├── PaymentStep.tsx         # Stripe Elements wrapper
    │   └── OrderSummary.tsx
    └── ui/                         # shadcn-ui generated components (do not edit)
```

Each component file exports one named component matching the filename.

## Catalog Product Grid

Use CSS Grid via Tailwind. The grid must be responsive across all breakpoints:

```tsx
// ProductGrid.tsx
<div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
  {products.map((product) => (
    <ProductCard key={product.id} product={product} />
  ))}
</div>
```

`ProductCard` renders a shadcn-ui `Card` with:
- Figurine image (top, fixed aspect ratio `aspect-square`, `object-cover`)
- Product name (`text-sm font-medium`)
- Price in CZK (`text-sm text-muted-foreground`)
- "Customize" CTA button using shadcn-ui `Button` variant `outline`

Cards link to `/figurines/{slug}` via `<Link>` — never `<a>`.

## Figurine Detail Card with 3D Preview

The 3D preview is a Three.js canvas rendered inside a contained `div`. It must never stretch the layout:

```tsx
// FigurinePreview3D.tsx
interface FigurinePreview3DProps {
  modelUrl: string;
  className?: string;
}

export function FigurinePreview3D({ modelUrl, className }: FigurinePreview3DProps) {
  const canvasRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!canvasRef.current) return;
    // Three.js scene init here — renderer, camera, controls
    // return cleanup fn to dispose renderer
  }, [modelUrl]);

  return (
    <div
      ref={canvasRef}
      className={cn("w-full aspect-square rounded-lg overflow-hidden bg-muted", className)}
      aria-label="Interactive 3D figurine preview"
      role="img"
    />
  );
}
```

The parent `FigurineDetail` layout uses a two-column grid on desktop:

```tsx
<div className="grid grid-cols-1 gap-8 lg:grid-cols-2">
  <FigurinePreview3D modelUrl={figurine.modelUrl} />
  <FigurineInfo figurine={figurine} />
</div>
```

Always clean up Three.js renderer in `useEffect` return to prevent memory leaks.

## AI Prompt Builder

The prompt builder is a multi-step form using local `useState` — do not use a form library for this component. Steps: Subject → Style → Material → Review.

```tsx
// FigurinePromptBuilder.tsx
type PromptStep = "subject" | "style" | "material" | "review";

interface PromptState {
  subject: string;
  style: string;
  material: string;
}
```

Use shadcn-ui `Tabs` for step navigation when all steps are reachable, or a linear stepper with `Button` next/back controls when steps are sequential. Show step progress with shadcn-ui `Progress`.

Controlled inputs use shadcn-ui `Input` and `Textarea`. Style/material selections use shadcn-ui `ToggleGroup` (Radix-backed).

## Checkout Flow Components

Checkout is a three-step flow: Cart → Shipping → Payment. Use React Router for step routing (`/checkout/cart`, `/checkout/shipping`, `/checkout/payment`).

**Stripe Elements** must be wrapped in `<Elements stripe={stripePromise}>` at the `CheckoutFlow` level, not per-step:

```tsx
// CheckoutFlow.tsx
<Elements stripe={stripePromise} options={elementsOptions}>
  <Outlet />
</Elements>
```

`PaymentStep` renders `<PaymentElement />` from `@stripe/react-stripe-js`. Never build custom card inputs — always use Stripe Elements.

`OrderSummary` is a sticky sidebar on desktop (`lg:sticky lg:top-4`), stacked below the form on mobile.

## Responsive Layout Patterns

| Breakpoint | Behavior |
|---|---|
| default (mobile) | Single column, full-width cards, stacked checkout |
| `sm` (640px) | 3-column product grid |
| `lg` (1024px) | 4-column grid, 2-column figurine detail, sticky checkout sidebar |
| `xl` (1280px) | 5-column product grid |

Container max-width: `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8` on all top-level page wrappers.

## GSAP Animations

Use GSAP for component entrance animations only. Register animations in `useLayoutEffect`, clean up with `gsap.context()`:

```tsx
useLayoutEffect(() => {
  const ctx = gsap.context(() => {
    gsap.from(".product-card", {
      opacity: 0,
      y: 20,
      stagger: 0.05,
      duration: 0.3,
      ease: "power2.out",
    });
  }, containerRef);
  return () => ctx.revert();
}, [products]);
```

Never animate elements that are offscreen or hidden — check `prefers-reduced-motion` before applying GSAP:

```tsx
const prefersReduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
if (!prefersReduced) { /* GSAP animation */ }
```

## Anti-patterns

- Do not use inline styles except for Three.js canvas sizing when unavoidable
- Do not edit files under `src/components/ui/` — those are shadcn-ui managed
- Do not use `React.FC` — use explicit function declarations with typed props interfaces
- Do not put Three.js logic inside JSX render — always in `useEffect`/`useLayoutEffect`
- Do not use `any` for Stripe or Three.js types — import their types from `@stripe/stripe-js` and `three`
