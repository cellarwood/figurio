---
name: component-patterns
description: >
  React/shadcn-ui component conventions for the Figurio storefront — product cards,
  3D model preview viewer, AI prompt interface (Prompt to Print), cart/checkout flow,
  and order tracking dashboard. Covers composition patterns, prop contracts, and
  TypeScript strict-mode requirements specific to Figurio UI.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags: [engineering, frontend, react]
---

# Component Patterns

Conventions for building React/TypeScript components in the Figurio storefront. The stack is React + TypeScript strict mode, shadcn-ui (Radix UI primitives), Tailwind CSS, and GSAP for animation.

## General Rules

- All components are TypeScript strict mode — no `any`, no non-null assertions without a comment.
- Export a named `type Props` from every component file.
- Use shadcn-ui primitives (Button, Card, Dialog, etc.) as the base layer. Only build custom primitives when shadcn has no equivalent.
- Co-locate component CSS only when Tailwind utilities are insufficient; prefer Tailwind utility classes.
- GSAP animations live in `useEffect`/`useLayoutEffect` with `gsap.context()` for cleanup — never inline styles that conflict with GSAP targets.

## Product Card (`ProductCard`)

Used in catalog browsing and search results.

```tsx
type Props = {
  sku: string
  name: string
  thumbnailUrl: string
  sizeTier: 'small' | 'medium' | 'large'   // ~8 cm / ~15 cm / ~25 cm
  priceEur: number
  badge?: 'new' | 'trending' | 'seasonal'
  onAddToCart: (sku: string) => void
}
```

- Use shadcn `Card` + `CardContent` as wrapper.
- Thumbnail renders in a fixed 1:1 aspect ratio container using Tailwind `aspect-square`.
- Badge maps to a `<span>` with Tailwind color variants: `new` → blue, `trending` → orange, `seasonal` → green.
- `onAddToCart` fires from a shadcn `Button` with `variant="default"`. Button is disabled while the cart mutation is in-flight — pass a `isPending` prop.
- Price always formats as `€{n.toFixed(2)}` — do not use Intl.NumberFormat (it varies by browser locale in tests).

## 3D Model Preview Viewer (`ModelViewer`)

Used on product detail pages and in the AI prompt approval flow.

```tsx
type Props = {
  modelUrl: string          // .glb or .obj URL from our CDN
  autoRotate?: boolean      // default true on catalog detail, false in prompt approval
  onApprove?: () => void    // present only in AI prompt approval context
  onRequestRevision?: () => void
  isLoading?: boolean
}
```

- Wrap the 3D renderer in a `<Suspense>` boundary with a skeleton placeholder matching the viewer dimensions.
- Use `autoRotate` GSAP tween on the container's CSS `rotateY` transform — not on the underlying renderer — so we don't conflict with pointer-drag events.
- When `onApprove` is present (approval context), render two shadcn `Button` elements below the viewer: `Approve` (variant `default`) and `Request Revision` (variant `outline`). Both are disabled while `isLoading` is true.
- Error state: show a shadcn `Alert` with `variant="destructive"` and a retry link.

## AI Prompt Interface (`PromptStudio`)

The "Prompt to Print" entry point where customers describe a custom figurine.

```tsx
type Props = {
  onSubmit: (prompt: string, sizeTier: SizeTier) => Promise<void>
  isGenerating: boolean
  generationError?: string
}
```

- Textarea (shadcn `Textarea`) with max 300 characters. Show remaining character count below using a `<p aria-live="polite">`.
- Size tier selection uses shadcn `RadioGroup` with three options (Small / Medium / Large), each showing the cm height and base price.
- Submit button text changes: idle → "Generate Figurine", generating → "Generating…" (with a spinner icon from `lucide-react`). Button is disabled while `isGenerating` is true.
- Content moderation error (IP/copyright rejection) renders as a `callout` style `Alert` beneath the textarea, not a toast.
- Deposit pricing note ("50% charged now, 50% on preview approval") is a static `<p>` in `text-muted-foreground` below the submit button — always visible, not hidden.

## Cart & Checkout Flow

### `CartDrawer`

Slides in from the right using a shadcn `Sheet` (not a full-page route). Items list is scrollable; total and checkout CTA are sticky at the bottom.

```tsx
type CartItem = {
  sku: string
  name: string
  sizeTier: SizeTier
  priceEur: number
  quantity: number
  thumbnailUrl: string
  type: 'catalog' | 'ai-custom'
}
```

- AI-custom items show a "Preview approved" badge and cannot have quantity > 1.
- Catalog items support quantity increment/decrement with shadcn `Button` (`variant="ghost"`, size `icon`).
- Checkout button navigates to `/checkout` and closes the drawer.

### `CheckoutForm`

Wraps Stripe Elements. Layout is a two-column grid on desktop (order summary left, payment form right), single column on mobile.

- Order summary is a read-only `CartSummary` component (not the full `CartDrawer`).
- Stripe `PaymentElement` is the sole payment UI — do not build custom card inputs.
- A `<p>` above the pay button always lists accepted payment methods: Visa, Mastercard, Apple Pay, Google Pay, iDEAL, SEPA.
- Form submission disables the pay button and shows a spinner; never navigate away until Stripe confirms `payment_intent.succeeded`.

## Order Tracking Dashboard (`OrderTracker`)

Post-purchase status page at `/orders/{orderId}`.

```tsx
type OrderStatus =
  | 'payment_captured'
  | 'model_in_queue'
  | 'printing'
  | 'quality_check'
  | 'shipped'
  | 'delivered'

type Props = {
  orderId: string
  status: OrderStatus
  estimatedDelivery?: string   // ISO date string
  trackingUrl?: string
}
```

- Status pipeline renders as a horizontal stepper on desktop, vertical on mobile. Use Tailwind `flex-row` / `flex-col` with a responsive breakpoint (`md:flex-row`).
- Active step is highlighted; completed steps have a checkmark icon (`lucide-react` `CheckCircle2`).
- `trackingUrl` renders as an external link (`target="_blank" rel="noopener noreferrer"`) — only shown when status is `shipped` or `delivered`.
- Poll for status updates every 60 seconds using a `useEffect`-based interval. Cancel on unmount.

## GSAP Animation Conventions

- Always initialize inside `useLayoutEffect` (for DOM-sync) or `useEffect` (for async triggers).
- Wrap all tweens in `gsap.context(ctx => { ... }, containerRef)` and return `() => ctx.revert()` for cleanup.
- Page-level transitions (catalog → product detail) use `gsap.timeline()` with an `opacity` + `y` entrance. Duration: 0.35 s, ease: `power2.out`.
- Do not use GSAP for hover states — use Tailwind `hover:` utilities instead.
- Respect `prefers-reduced-motion`: check `window.matchMedia('(prefers-reduced-motion: reduce)').matches` at the start of every GSAP context and skip tweens if true.
