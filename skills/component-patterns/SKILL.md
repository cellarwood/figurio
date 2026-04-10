---
name: component-patterns
description: >
  React/TypeScript component conventions for the Figurio storefront. Covers file
  structure, naming, prop typing in strict mode, and implementation patterns for
  product cards, cart drawer, Stripe Elements checkout flow, 3D model viewer,
  and order tracking components using shadcn-ui and Radix UI primitives.
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

Apply this skill whenever creating or modifying React components for the Figurio storefront — product catalog, cart, checkout, 3D viewer, order tracking, or account pages.

## File Structure

```
src/
  components/
    ui/                  # shadcn-ui generated primitives (do not hand-edit)
    catalog/
      ProductCard.tsx
      ProductGrid.tsx
      ProductFilters.tsx
    cart/
      CartDrawer.tsx
      CartLineItem.tsx
      CartSummary.tsx
    checkout/
      CheckoutForm.tsx
      StripePaymentElement.tsx
      OrderConfirmation.tsx
    viewer/
      ModelViewer.tsx
      ModelViewerSkeleton.tsx
    tracking/
      OrderTimeline.tsx
      OrderStatusBadge.tsx
    shared/
      PriceDisplay.tsx
      SizeTierSelector.tsx
  hooks/
    useCart.ts
    useOrderStatus.ts
    useModelViewer.ts
  types/
    product.ts
    order.ts
    cart.ts
```

## Naming Conventions

- Component files: PascalCase (`ProductCard.tsx`)
- Hook files: camelCase prefixed with `use` (`useCart.ts`)
- All components export as named exports — no default exports
- Types live in `src/types/`, imported as `import type { Product } from '@/types/product'`

## TypeScript Conventions

Always use strict prop interfaces, never `any`:

```tsx
// Good
interface ProductCardProps {
  product: Product;
  onAddToCart: (productId: string, sizeSlug: string) => void;
  className?: string;
}

export function ProductCard({ product, onAddToCart, className }: ProductCardProps) {
  // ...
}
```

- Use `interface` for component props, `type` for unions and mapped types
- Prefer explicit return types on hooks: `function useCart(): CartState`
- Use `React.ComponentPropsWithoutRef<'button'>` for forwarded HTML element props

## shadcn/Radix Usage

Import shadcn components from `@/components/ui/`. Extend variants via `className` — never modify the `ui/` source files directly.

```tsx
import { Button } from '@/components/ui/button'
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet'
import { Badge } from '@/components/ui/badge'

// Extend via className with Tailwind
<Button className="w-full" variant="default">Add to Cart</Button>
```

Use Radix primitives directly when shadcn doesn't cover the use case (e.g., `@radix-ui/react-visually-hidden` for screen-reader-only labels in the 3D viewer).

## Product Card

The `ProductCard` renders in the catalog grid. It uses shadcn `Card` as the container with a fixed aspect-ratio image area.

Key patterns:
- Image with `aspect-ratio: 4/3`, `object-fit: cover` via Tailwind `aspect-[4/3] object-cover`
- Size tier badge uses shadcn `Badge` with `variant="secondary"`
- "Add to cart" triggers immediately — no modal — for catalog cards
- Link wraps the card via React Router `<Link>`, with the CTA button stopping propagation

```tsx
export function ProductCard({ product, onAddToCart }: ProductCardProps) {
  return (
    <Card className="group overflow-hidden">
      <Link to={`/products/${product.slug}`}>
        <div className="aspect-[4/3] overflow-hidden bg-muted">
          <img
            src={product.thumbnailUrl}
            alt={product.name}
            className="w-full h-full object-cover transition-transform group-hover:scale-105"
          />
        </div>
        <CardContent className="p-4">
          <h3 className="font-semibold text-sm">{product.name}</h3>
          <PriceDisplay priceFrom={product.priceTiers[0].price} />
        </CardContent>
      </Link>
      <CardFooter className="p-4 pt-0">
        <Button
          size="sm"
          className="w-full"
          onClick={(e) => { e.preventDefault(); onAddToCart(product.id, product.priceTiers[0].sizeSlug) }}
        >
          Add to Cart
        </Button>
      </CardFooter>
    </Card>
  )
}
```

## Cart Drawer

Use shadcn `Sheet` with `side="right"` for the cart drawer. Cart state lives in a Zustand store accessed via `useCart()`.

Key patterns:
- `SheetTrigger` is the header cart icon; controlled open state in the store
- `CartLineItem` handles quantity +/- with optimistic updates
- Show empty state with a CTA to the catalog when `cart.items.length === 0`
- Footer shows subtotal + "Proceed to Checkout" button that navigates to `/checkout`

```tsx
export function CartDrawer() {
  const { isOpen, closeCart, items, subtotal } = useCart()

  return (
    <Sheet open={isOpen} onOpenChange={(open) => !open && closeCart()}>
      <SheetContent side="right" className="flex flex-col w-full sm:max-w-md">
        <SheetHeader>
          <SheetTitle>Your Cart ({items.length})</SheetTitle>
        </SheetHeader>
        {/* line items */}
        <div className="flex-1 overflow-y-auto py-4 space-y-4">
          {items.map((item) => <CartLineItem key={item.id} item={item} />)}
        </div>
        {/* footer */}
        <div className="border-t pt-4 space-y-3">
          <CartSummary subtotal={subtotal} />
          <Button asChild className="w-full">
            <Link to="/checkout" onClick={closeCart}>Proceed to Checkout</Link>
          </Button>
        </div>
      </SheetContent>
    </Sheet>
  )
}
```

## Checkout Flow

The checkout is a single `/checkout` page with three logical sections: address, payment (Stripe Elements), and order review. Do not split into multi-step routes — manage step state locally with `useState`.

```tsx
type CheckoutStep = 'address' | 'payment' | 'review'
```

Stripe Elements integration:
- Wrap the page in `<Elements stripe={stripePromise} options={elementsOptions}>`
- Use `<PaymentElement>` — not the older `<CardElement>` — for PCI-compliant rendering
- On submit, call `stripe.confirmPayment()` with `return_url: window.location.origin + '/order-confirmation'`
- Stripe redirects back on success; read `payment_intent_client_secret` from query params on the confirmation page

```tsx
// In CheckoutForm.tsx
const { stripe, elements } = useStripe(), useElements()

async function handleSubmit(e: React.FormEvent) {
  e.preventDefault()
  if (!stripe || !elements) return
  setIsSubmitting(true)
  const { error } = await stripe.confirmPayment({
    elements,
    confirmParams: { return_url: `${window.location.origin}/order-confirmation` },
  })
  if (error) setPaymentError(error.message ?? 'Payment failed')
  setIsSubmitting(false)
}
```

## 3D Model Viewer

`ModelViewer` wraps the `<model-viewer>` web component (Google's `@google/model-viewer` package). Because it is a custom element, declare it in `src/types/model-viewer.d.ts`.

Key patterns:
- Show `ModelViewerSkeleton` (animated Tailwind `animate-pulse` placeholder) while the model loads
- Expose `autoRotate` and `cameraControls` as props — default both to `true` on detail pages
- For the cart drawer thumbnail, set `autoRotate={false}` and disable camera controls

```tsx
export function ModelViewer({ src, alt, autoRotate = true, cameraControls = true }: ModelViewerProps) {
  const [loaded, setLoaded] = useState(false)
  return (
    <div className="relative aspect-square w-full bg-muted rounded-lg overflow-hidden">
      {!loaded && <ModelViewerSkeleton />}
      <model-viewer
        src={src}
        alt={alt}
        auto-rotate={autoRotate || undefined}
        camera-controls={cameraControls || undefined}
        onLoad={() => setLoaded(true)}
        style={{ width: '100%', height: '100%' }}
      />
    </div>
  )
}
```

## Order Tracking

`OrderTimeline` renders the status steps for an order. Status values come from the backend `Order` type and map to human-readable labels.

```tsx
const STATUS_STEPS: OrderStatus[] = ['paid', 'preparing', 'printing', 'shipped', 'delivered']

export function OrderTimeline({ currentStatus }: { currentStatus: OrderStatus }) {
  const currentIdx = STATUS_STEPS.indexOf(currentStatus)
  return (
    <ol className="flex flex-col gap-3">
      {STATUS_STEPS.map((step, idx) => (
        <li key={step} className={cn('flex items-center gap-3', idx <= currentIdx ? 'text-foreground' : 'text-muted-foreground')}>
          <StatusDot completed={idx <= currentIdx} />
          <span className="text-sm font-medium capitalize">{step}</span>
        </li>
      ))}
    </ol>
  )
}
```

Use `useOrderStatus(orderId)` hook which polls `/api/v1/orders/{id}` every 30 seconds while status is not `delivered`.

## Tailwind Conventions

- Use `cn()` (from `@/lib/utils`) to merge conditional class strings — never string concatenation
- Prefer Tailwind spacing scale (`p-4`, `gap-3`) over arbitrary values
- Responsive prefix order: mobile-first base → `sm:` → `md:` → `lg:`
- Color tokens: use design-system semantic tokens (`text-foreground`, `bg-muted`, `border`) not raw Tailwind palette colors

## Anti-patterns

- Do not use `React.FC` — declare components as plain functions with typed props
- Do not put cart or order state in component-local state — use the Zustand stores
- Do not import from `@radix-ui/*` for anything shadcn already wraps
- Do not use inline `style={{}}` except for the `<model-viewer>` web component dimensions
- Do not skip loading and error states on async data — every fetch needs a skeleton and error boundary
