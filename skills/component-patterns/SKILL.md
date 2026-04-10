---
name: component-patterns
description: >
  React/TypeScript component patterns for the Figurio storefront (shadcn-ui + Radix UI + Tailwind).
  Covers product cards with size tier badges, the Three.js 3D model viewer, cart drawer,
  Stripe checkout form, and order status timeline. Used whenever building or reviewing
  storefront UI components.
allowed-tools:
  - Read
  - Grep
  - Write
  - Bash
metadata:
  paperclip:
    tags:
      - engineering
      - frontend
---

# Component Patterns

## Stack Conventions

- **TypeScript strict mode** — all props and state must be fully typed; no `any`
- **shadcn-ui** components are the base layer — extend, don't replace
- **Radix UI** primitives for accessible interactive components (Dialog, Drawer, etc.)
- **Tailwind CSS** for all styling — no inline styles, no CSS modules
- **GSAP** for complex animations (cart drawer entrance, figurine spotlight); CSS transitions for simple hover/focus states
- **Three.js** for 3D preview rendering

---

## Product Card

Each catalog figurine card renders name, a rendered thumbnail, price, and a size tier badge.

```tsx
// components/product/ProductCard.tsx
interface ProductCardProps {
  sku: string;
  name: string;
  thumbnailUrl: string;
  priceCZK: number;
  sizeTier: 'small' | 'medium' | 'large';
  isCustom?: boolean; // Prompt-to-Print entries
}
```

### Size Tier Badge

Size maps directly to the Figurio production tier. Render inside the card's top-right corner using an absolutely-positioned `<Badge>` (shadcn-ui).

| Tier   | Label | Tailwind color token |
|--------|-------|----------------------|
| small  | S · 8 cm | `bg-sky-100 text-sky-800` |
| medium | M · 15 cm | `bg-violet-100 text-violet-800` |
| large  | L · 25 cm | `bg-amber-100 text-amber-800` |

```tsx
const TIER_STYLES = {
  small:  'bg-sky-100 text-sky-800',
  medium: 'bg-violet-100 text-violet-800',
  large:  'bg-amber-100 text-amber-800',
} as const;

<Badge className={cn('absolute top-2 right-2 text-xs font-semibold', TIER_STYLES[sizeTier])}>
  {sizeTier === 'small' ? 'S · 8 cm' : sizeTier === 'medium' ? 'M · 15 cm' : 'L · 25 cm'}
</Badge>
```

### Card interaction

- Clicking the card navigates to `/catalog/[sku]`
- "Add to cart" button inside the card triggers an optimistic cart update, then GSAP fly-to-cart animation
- For Prompt-to-Print items, card shows "Customize" CTA instead

---

## 3D Model Viewer

Used on product detail page (`/catalog/[sku]`) and the AI preview approval step.

```tsx
// components/viewer/ModelViewer.tsx
interface ModelViewerProps {
  modelUrl: string;       // .glb file URL
  autoRotate?: boolean;   // default: true on catalog, false on approval step
  onLoadError?: () => void;
}
```

### Implementation rules

- Wrap Three.js canvas in a `<Suspense>` with a skeleton placeholder (`<ModelViewerSkeleton />`)
- Use `@react-three/fiber` and `@react-three/drei` (if added to stack) OR a raw Three.js `WebGLRenderer` inside a `useEffect` — prefer `@react-three/fiber` for cleaner lifecycle management
- Default camera: 45° elevation, distance adjusted per size tier (small=0.3m, medium=0.5m, large=0.8m)
- Background: transparent — the containing card provides the background
- Expose `aria-label="Interactive 3D preview of [product name]. Use mouse or touch to rotate."` on the canvas wrapper

---

## Cart Drawer

Uses Radix UI `Sheet` (via shadcn-ui) from the right side. Triggered by the cart icon in the global header.

```tsx
// components/cart/CartDrawer.tsx
// State managed via Zustand cartStore
```

### Behaviour

- Opens with a GSAP slide-in (`x: '100%' → 0`, duration 0.3s, ease: `power2.out`)
- Line items show: thumbnail, name, size tier badge, quantity stepper, remove button
- Subtotal in CZK, VAT note (`"Incl. 21% VAT"`)
- "Proceed to Checkout" button navigates to `/checkout` and closes the drawer
- Drawer is a `role="dialog"` with `aria-label="Shopping cart"` and focus trap via Radix

### Empty state

Show a centered SVG illustration with copy "Your cart is empty" and a "Browse Catalog" link. No spinner — the cart is always synchronous from local state.

---

## Stripe Checkout Form

Located at `/checkout`. Embeds Stripe Elements via `@stripe/react-stripe-js`.

```tsx
// components/checkout/CheckoutForm.tsx
```

### Layout

1. **Order summary** (right column, sticky on desktop) — read-only, mirrors cart contents
2. **Payment form** (left column):
   - Stripe `<PaymentElement />` — covers card, Apple Pay, Google Pay, iDEAL, Bancontact, SEPA
   - Shipping address using Stripe's `<AddressElement mode="shipping" />`
   - "Pay now" submit button with loading spinner (shadcn-ui `<Button>` with `disabled` + spinner during `confirmPayment`)

### Error handling

- Stripe API errors surface via `<PaymentElement>` natively — do not duplicate error state
- Network/fetch errors: show shadcn-ui `<Alert variant="destructive">` above the submit button
- On success: redirect to `/order/[orderId]/confirmation`

### Prompt-to-Print deposit flow

When `orderType === 'custom'`, the checkout form collects only the 50% deposit. A prominent banner reads:
> "You are paying a 50% deposit. The remaining balance is due after you approve your 3D preview."

---

## Order Status Timeline

Used on `/order/[orderId]` (tracking page) and the confirmation page.

```tsx
// components/order/OrderTimeline.tsx
interface OrderTimelineProps {
  steps: OrderStep[];
  currentStep: OrderStatus;
}

type OrderStatus =
  | 'payment_captured'
  | 'file_prep'
  | 'printing'
  | 'quality_check'
  | 'shipped'
  | 'delivered';

interface OrderStep {
  status: OrderStatus;
  label: string;
  estimatedDate?: string; // ISO 8601
  completedAt?: string;
}
```

### Rendering rules

- Vertical timeline on mobile, horizontal stepper on `md:` and above
- Completed steps: filled circle icon + full color (`text-violet-700`)
- Current step: animated pulse ring around circle
- Upcoming steps: hollow circle + muted text (`text-muted-foreground`)
- For Prompt-to-Print orders, insert `preview_approval` step between `file_prep` and `printing` — include a "Review Preview" CTA button on that step when `currentStep === 'preview_approval'`

---

## General Rules

- All components must export a named export (no default exports except pages)
- Props interfaces live in the same file as the component; shared types live in `types/`
- Use `cn()` (from `lib/utils`) for conditional class merging — never string concatenation
- No component should fetch data directly — data is passed via props or read from Zustand stores
- Skeleton loaders must match the exact dimensions of the loaded content to prevent layout shift
