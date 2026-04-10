---
name: component-patterns
description: >
  React/shadcn-ui component conventions for the Figurio storefront — covers
  product cards, cart drawer, checkout form, 3D model viewer, and responsive
  grid layouts for the D2C 3D-printed figurine catalog and AI "Prompt to Print"
  custom flow.
allowed-tools:
  - Read
  - Grep
  - Write
metadata:
  paperclip:
    tags:
      - engineering
      - frontend
---

# Component Patterns

Conventions for building React + TypeScript components on the Figurio storefront
using shadcn/ui primitives. Every component lives under `src/components/` and is
co-located with its own `*.test.tsx` file.

## General Rules

- Use **shadcn/ui** primitives (`Button`, `Card`, `Dialog`, `Sheet`, `Form`, etc.)
  as the base; extend with Tailwind utility classes — do not write custom CSS files.
- All props interfaces are named `<ComponentName>Props` and exported.
- Use `React.forwardRef` only when the parent genuinely needs a DOM ref (e.g., scroll
  targets, focus management).
- Prefer composition over configuration — pass children or slot props rather than
  boolean variant flags where the variants are structurally different.
- Use `cn()` (from `lib/utils`) to merge class names; never string-concatenate classes.

## Product Card (`ProductCard`)

Used in catalog grids and search results to display a single figurine SKU.

```tsx
interface ProductCardProps {
  sku: string;
  name: string;
  priceEur: number;          // display in EUR with CZK secondary label
  thumbnailUrl: string;
  badge?: 'new' | 'sale' | 'custom'; // 'custom' = AI Prompt to Print eligible
  onAddToCart: (sku: string) => void;
}
```

- Wrap in shadcn `Card` with `overflow-hidden rounded-2xl`.
- Thumbnail uses `<img>` with `aspect-ratio: 1/1` and `object-fit: cover`; always
  include a descriptive `alt` string (e.g., `"Mage figurine — front view"`).
- Price: render `€{priceEur.toFixed(2)}` as primary, `~{czk} Kč` as secondary muted text.
- The "Add to Cart" `Button` is `variant="default" size="sm"` and emits `onAddToCart(sku)`.
- The `badge` renders as a shadcn `Badge` positioned `absolute top-2 left-2`.

## Cart Drawer (`CartDrawer`)

Slides in from the right using shadcn `Sheet` (`side="right"`).

- Triggered globally via `useCartStore` (Zustand); do not pass open state as props.
- Line items rendered in a `ScrollArea` capped at `max-h-[60vh]`.
- Each line item shows: thumbnail (40 × 40 px), name, quantity stepper (`+ / −` buttons),
  unit price, and a remove icon (`Trash2` from lucide-react).
- Footer: subtotal, a Zásilkovna shipping estimate label, and a full-width
  `Button` "Proceed to Checkout" linking to `/checkout`.
- Empty state: centered illustration + "Your cart is empty" + `Button` "Browse Figurines"
  linking to `/catalog`.

## Checkout Form (`CheckoutForm`)

Multi-step form: **1 — Contact → 2 — Shipping → 3 — Payment**.

- Use shadcn `Form` backed by `react-hook-form` + `zod` schema validation.
- Each step is a separate named component: `ContactStep`, `ShippingStep`, `PaymentStep`.
- Navigation uses a local `step` state (1–3); do not use a router for step transitions.
- Stripe Elements (`CardElement`) are mounted in `PaymentStep` — wrap in a
  `<Elements stripe={stripePromise}>` boundary at the `CheckoutForm` level.
- Zásilkovna pickup-point selector lives in `ShippingStep` as `<ZasilkovnaWidget>` — it
  renders an iframe; wrap with a `Suspense` boundary and a `Skeleton` fallback.
- On submit, call `POST /api/v1/orders` — handle `4xx` errors inline on the relevant
  step field using `setError` from `react-hook-form`.

### Field validation rules (shared zod schema)

| Field | Rule |
|---|---|
| Email | `z.string().email()` |
| Phone | Czech/EU format: `z.string().regex(/^\+?[0-9\s\-]{7,15}$/)` |
| Postal code | `z.string().regex(/^\d{3}\s?\d{2}$/)` (Czech PSČ) |
| Card (Stripe) | Validated by Stripe Elements; show `stripeError.message` in a `FormMessage` |

## 3D Model Viewer (`ModelViewer`)

Used on the product detail page and the AI "Prompt to Print" preview.

```tsx
interface ModelViewerProps {
  modelUrl: string;     // URL to .glb file
  posterUrl?: string;   // static fallback image while model loads
  autoRotate?: boolean; // default true on detail page, false in cart
}
```

- Renders `<model-viewer>` (Google `@google/model-viewer` web component).
- Declare the custom element type in `src/types/model-viewer.d.ts` to satisfy TS.
- Always provide `poster` prop — shown while the WASM runtime boots.
- Set `camera-controls`, `shadow-intensity="1"`, `ar` (for mobile AR quick-look).
- Wrap with a fixed-aspect container (`aspect-[4/3]`) using a `div`; never let
  the viewer dictate its own dimensions.
- Lazy-load the `@google/model-viewer` script via dynamic `import()` inside a
  `useEffect` so it does not block initial bundle parse.

## Responsive Grid

Catalog pages use a CSS grid via Tailwind:

```tsx
<div className="grid grid-cols-2 gap-4 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
  {products.map((p) => <ProductCard key={p.sku} {...p} />)}
</div>
```

- Mobile: 2 columns (figurines are visually rich — 1 column feels sparse).
- Tablet (md): 3 columns.
- Desktop (lg+): 4–5 columns.
- Use `Skeleton` placeholders during loading — same grid, `ProductCard` replaced by
  a `Card` with `animate-pulse` children matching the card's visual weight.

## Anti-patterns

- Do not use `styled-components` or any CSS-in-JS — Tailwind + shadcn only.
- Do not lift cart state into component props — always consume `useCartStore`.
- Do not import `model-viewer` at the module top level — it registers a global custom
  element and breaks SSR/test environments.
- Do not display raw CZK-only prices — always show EUR as primary for the EU market.
