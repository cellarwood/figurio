---
name: component-patterns
description: >
  React/shadcn-ui component conventions for the Figurio storefront — covers
  product cards with size selector, cart drawer, Stripe Elements checkout form,
  three.js 3D model preview viewer, order status timeline, and responsive layout
  patterns. Use this skill when building or modifying any UI component in the
  Figurio frontend.
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
---

# Component Patterns

Figurio's frontend is React 18 with TypeScript strict mode, shadcn-ui + Radix UI primitives, Tailwind CSS utility classes, and Vite as the build tool.

## General Rules

- All components are typed with TypeScript strict mode — no `any`, no non-null assertions without a comment explaining why.
- Use shadcn-ui primitives (Button, Dialog, Sheet, Select, etc.) as the base layer. Do not re-implement what shadcn already provides.
- Co-locate component-specific types in the same file unless shared across more than one file, in which case they live in `src/types/`.
- Props interfaces are named `{ComponentName}Props` and exported.
- Default exports for page-level components; named exports for reusable UI components.

## Product Card

The product card is the primary catalog unit. It renders a figurine photo, name, base price, and an inline size selector.

```tsx
// src/components/catalog/ProductCard.tsx
export interface ProductCardProps {
  product: CatalogProduct; // id, name, slug, basePrice, sizes, imageUrl
  onAddToCart: (productId: string, sizeId: string) => void;
}
```

- Size selector uses shadcn `Select` (Radix `SelectRoot`). Default to the first available size on mount.
- Display price as `Kč {amount}` (Czech koruna) formatted with `Intl.NumberFormat('cs-CZ', { style: 'currency', currency: 'CZK' })`.
- Figurine photos use `<img>` with an explicit `alt` matching the product name and size (e.g., `"Dragon figurine – 15 cm"`).
- Wrap the card in a `<article>` element for semantic meaning.
- Hover state: `group` class on the article, `group-hover:scale-105` transition on the image container.

## Cart Drawer

The cart lives in a shadcn `Sheet` (slide-over from the right). It is always mounted but toggled via a Zustand store flag.

```tsx
// src/components/cart/CartDrawer.tsx
// Trigger: <Sheet open={cartOpen} onOpenChange={setCartOpen}>
```

- Cart line items show product name, size, quantity stepper (shadcn `Button` with `+`/`-`), unit price, and line total.
- Quantity stepper dispatches to the cart Zustand store; min quantity is 1.
- "Proceed to Checkout" button navigates to `/checkout` via `react-router-dom` `useNavigate`.
- Show a `Badge` with item count on the cart icon in the header; hide the badge (not just zero it) when the cart is empty.
- Empty cart state: centered illustration + "Your cart is empty" text + "Browse figurines" link to `/catalog`.

## Stripe Elements Checkout Form

The checkout page embeds Stripe Elements for card collection. Never handle raw card data outside of Stripe Elements.

```tsx
// src/pages/CheckoutPage.tsx
// Uses: @stripe/react-stripe-js, @stripe/stripe-js
// Wrap in <Elements stripe={stripePromise} options={elementsOptions}>
```

- `stripePromise` is initialised once at module level (`loadStripe(import.meta.env.VITE_STRIPE_PUBLISHABLE_KEY)`).
- Use `<PaymentElement>` (not the older `<CardElement>`) for the payment method UI — it supports local Czech payment methods.
- Form sections: Shipping address → Payment → Order summary (sticky right column on desktop).
- On submit: call `stripe.confirmPayment({ elements, confirmParams: { return_url } })`. Handle `error` from the result inline — display it in a shadcn `Alert` variant `destructive` below the submit button.
- Disable the submit button while `stripe.confirmPayment` is in flight (track with local `useState<boolean>`).

## 3D Model Preview Viewer

AI-custom figurines show a three.js WebGL preview of the generated model.

```tsx
// src/components/preview/ModelViewer.tsx
export interface ModelViewerProps {
  modelUrl: string;   // URL to .glb file
  loading?: boolean;  // show skeleton while model loads
}
```

- Initialise the three.js renderer inside a `useEffect` with a cleanup that calls `renderer.dispose()`.
- Use `OrbitControls` from `three/examples/jsm/controls/OrbitControls` for mouse/touch rotation.
- While `loading` is true, render a `Skeleton` (shadcn) the same dimensions as the canvas.
- Canvas is always `width: 100%`, `aspect-ratio: 1 / 1` via Tailwind `aspect-square`.
- If the browser reports `!renderer.capabilities.isWebGL2`, render a static `<img>` fallback with `alt="3D preview unavailable — figurine render"` and a tooltip explaining WebGL is required.

## Order Status Timeline

Displayed on the `/orders/{orderId}` page. Shows steps: Order Placed → Payment Confirmed → Sent to MCAE → Printing → Shipped → Delivered.

```tsx
// src/components/orders/OrderTimeline.tsx
export type OrderStep =
  | 'placed' | 'paid' | 'sent_to_mcae' | 'printing' | 'shipped' | 'delivered';

export interface OrderTimelineProps {
  currentStep: OrderStep;
  steps: { key: OrderStep; label: string; timestamp?: string }[];
}
```

- Render as a vertical `<ol>` with a connecting line (Tailwind `border-l-2`).
- Completed steps: filled circle icon (`bg-primary`), full opacity text.
- Current step: filled circle with a `ring-2 ring-primary/40` pulse animation.
- Upcoming steps: hollow circle (`border-2 border-muted`), muted text.
- Timestamp (if present) shown in `cs-CZ` locale: `new Date(timestamp).toLocaleDateString('cs-CZ')`.

## Responsive Patterns

Figurio targets mobile-first. Common breakpoints used are `sm` (640 px) and `lg` (1024 px).

| Context | Mobile | Desktop (`lg:`) |
|---|---|---|
| Catalog grid | 1 column | 3 columns (`lg:grid-cols-3`) |
| Checkout layout | Single column | 2-column with sticky summary (`lg:grid lg:grid-cols-[1fr_360px]`) |
| Product detail | Stacked image then info | Side-by-side (`lg:flex lg:gap-12`) |
| Cart drawer | Full-width (100vw) | 400 px fixed (`w-[400px]`) |

- Use `container mx-auto px-4` as the page wrapper. Max width is set in `tailwind.config.ts` to `1280px`.
- Navigation collapses to a bottom tab bar on mobile (not a hamburger menu).
