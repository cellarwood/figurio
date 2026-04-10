---
name: component-patterns
description: >
  React component patterns for the Figurio storefront — covers shadcn-ui usage
  conventions, Tailwind styling patterns, Three.js 3D model viewer integration,
  responsive product cards, cart state management with React context, and
  Stripe Elements integration in the checkout flow.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags:
      - engineering
      - frontend
---

# Component Patterns

## When to Use

Apply this skill when building, reviewing, or modifying any React component in the Figurio storefront — including catalog pages, the AI prompt interface, the 3D preview viewer, cart UI, or the checkout flow.

## General Conventions

- All components are written in TypeScript with strict mode enabled.
- Use named exports for all components — no default exports.
- Keep components co-located with their page if used only once; move to `src/components/` when shared across two or more pages.
- Props interfaces are declared above the component, named `<ComponentName>Props`.
- Avoid prop drilling beyond two levels — use context or a dedicated hook instead.

```tsx
interface ProductCardProps {
  sku: string;
  name: string;
  previewUrl: string;
  priceInCents: number;
}

export function ProductCard({ sku, name, previewUrl, priceInCents }: ProductCardProps) {
  // ...
}
```

## shadcn-ui Usage

- Import shadcn-ui primitives from `@/components/ui/` (the local re-export layer), never directly from `@radix-ui/*`.
- Do not modify files under `src/components/ui/` — extend behavior by wrapping, not editing.
- Use the `cn()` utility from `@/lib/utils` for all conditional class merging.
- Prefer shadcn-ui's `Button`, `Dialog`, `Sheet`, and `Tooltip` over custom equivalents.

```tsx
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

export function AddToCartButton({ disabled, className }: { disabled?: boolean; className?: string }) {
  return (
    <Button
      variant="default"
      size="lg"
      disabled={disabled}
      className={cn("w-full", className)}
    >
      Add to Cart
    </Button>
  );
}
```

## Tailwind Styling Patterns

- Use Tailwind utility classes directly — no custom CSS files unless absolutely necessary for Three.js canvas layering.
- Figurio brand tokens are registered as Tailwind theme extensions:
  - `bg-brand-clay` — primary warm tone
  - `bg-brand-slate` — neutral dark
  - `text-brand-gold` — accent / CTA highlights
- Use `@apply` only inside `src/styles/globals.css` for base HTML element resets.
- Responsive breakpoints follow Tailwind defaults: `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px).
- Product grid layout: `grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6`.

## Responsive Product Cards

Product cards display a figurine thumbnail, name, price, and an add-to-cart affordance.

```tsx
export function ProductCard({ sku, name, previewUrl, priceInCents }: ProductCardProps) {
  const { addItem } = useCart();

  return (
    <article className="group relative flex flex-col rounded-2xl border border-slate-200 bg-white overflow-hidden hover:shadow-lg transition-shadow">
      <div className="aspect-square overflow-hidden bg-brand-slate">
        <img
          src={previewUrl}
          alt={`3D figurine: ${name}`}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
          loading="lazy"
        />
      </div>
      <div className="flex flex-col gap-2 p-4">
        <h3 className="text-sm font-semibold text-slate-900 truncate">{name}</h3>
        <p className="text-brand-gold font-bold">{formatPrice(priceInCents)}</p>
        <AddToCartButton onClick={() => addItem(sku)} />
      </div>
    </article>
  );
}
```

- Use `<article>` for product cards — it carries semantic meaning for screen readers.
- Always include a descriptive `alt` attribute on product images.
- GSAP-driven hover animations belong on the Three.js canvas layer, not on `<img>` tags.

## Three.js 3D Model Viewer Integration

The `ModelViewer` component wraps a Three.js scene inside a `<canvas>`. It is used on the product detail page and the AI prompt preview panel.

- Mount/unmount the Three.js renderer inside `useEffect` with a cleanup return to dispose geometries and the WebGL context.
- Canvas sizing must be driven by a `ResizeObserver` — never hardcoded pixel values.
- Expose a `modelUrl` prop (GLTF/GLB path) and an optional `autoRotate` boolean.
- Loading state is handled with a `Suspense`-compatible skeleton overlay (`<ModelViewerSkeleton />`).
- GSAP animations (intro scale-in, AI prompt transition) are triggered via refs — do not mix GSAP timelines with React state updates.

```tsx
interface ModelViewerProps {
  modelUrl: string;
  autoRotate?: boolean;
}

export function ModelViewer({ modelUrl, autoRotate = true }: ModelViewerProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    if (!canvasRef.current) return;
    const { scene, renderer, dispose } = initThreeScene(canvasRef.current, { modelUrl, autoRotate });
    return () => dispose();
  }, [modelUrl, autoRotate]);

  return (
    <div className="relative w-full aspect-square bg-brand-slate rounded-2xl overflow-hidden">
      <canvas ref={canvasRef} className="absolute inset-0 w-full h-full" aria-label="Interactive 3D figurine preview" />
    </div>
  );
}
```

- Provide `aria-label` on the `<canvas>` element — it is otherwise invisible to assistive technology.
- Do not render `ModelViewer` server-side; wrap call sites with a dynamic import or `useIsClient` guard.

## Cart State Management

Cart state lives in `CartContext` (`src/context/cart-context.tsx`). Do not create local cart state — always consume the context.

```tsx
const { items, addItem, removeItem, totalInCents } = useCart();
```

- `addItem(sku: string, quantity?: number)` — defaults to quantity 1.
- `removeItem(sku: string)` — removes all units of that SKU.
- Cart is persisted to `localStorage` via a `useEffect` inside the provider — no extra persistence logic needed in consumers.
- The cart `Sheet` (slide-over panel) is toggled via `useCartSheet()` — do not manage open/close state locally.

## Stripe Elements Integration

Stripe Elements are mounted inside the `/checkout` page (`src/pages/checkout/`).

- Initialize with `loadStripe(import.meta.env.VITE_STRIPE_PUBLISHABLE_KEY)` — store the promise at module level to avoid re-initialization on re-renders.
- Wrap the payment form in `<Elements stripe={stripePromise} options={elementsOptions}>`.
- Use the `PaymentElement` component for the payment method UI — do not build custom card inputs.
- The `appearance` option must use Figurio's brand tokens:
  ```ts
  const elementsOptions = {
    appearance: {
      theme: "stripe" as const,
      variables: { colorPrimary: "#C49A3C", borderRadius: "12px" },
    },
  };
  ```
- Submit via `stripe.confirmPayment()` — handle `error` and redirect in the same async handler.
- Never log or render `paymentIntent.client_secret` to the DOM.

## Anti-patterns

- Do not import Radix UI primitives directly — always use the shadcn-ui wrapper from `@/components/ui/`.
- Do not use inline `style={{}}` for colors or spacing — use Tailwind utilities or brand token classes.
- Do not store cart items in component-level state (`useState`) — use `useCart()`.
- Do not initialize Three.js outside of `useEffect` — it will throw on SSR and leak memory on unmount.
- Do not place GSAP `gsap.to()` calls inside render — use refs and `useLayoutEffect`.
