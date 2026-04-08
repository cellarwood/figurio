---
name: component-patterns
description: React component architecture for the Figurio storefront — shadcn-ui usage, 3D viewer integration, product catalog patterns, and checkout flow components.
---

# Component Patterns

## Purpose

Define React component architecture standards for the Figurio storefront. All frontend engineers must follow these patterns for consistency, maintainability, and performance.

## Tech Stack

- **Framework**: React 18+ with TypeScript (strict mode).
- **Build tool**: Vite.
- **Component library**: shadcn-ui (Tailwind CSS based).
- **3D rendering**: React Three Fiber + @react-three/drei.
- **State management**: React Context (cart), TanStack Query (server state).
- **Routing**: React Router v6.
- **Forms**: React Hook Form + Zod validation.

## Component Hierarchy

```
App
├── Layout
│   ├── Header (logo, nav, cart icon with count)
│   ├── Main Content
│   │   ├── Page (route-level component)
│   │   │   ├── Section (logical grouping)
│   │   │   │   └── Component (reusable UI element)
│   │   │   └── Section
│   │   └── Page
│   └── Footer (links, newsletter signup, payment icons)
└── Providers (QueryClient, CartContext, AuthContext)
```

## Key Components

### ProductCard

Displays a single product in the catalog grid.

```tsx
interface ProductCardProps {
  product: Product;
  onAddToCart?: (product: Product, sizeTier: SizeTier) => void;
}
```

- Shows thumbnail, name, "from" price, category badge.
- Hover state: subtle scale + shadow transition.
- Click navigates to product detail page.
- Quick-add button for default size tier.

### ProductGrid

Responsive grid layout for product listings.

```tsx
interface ProductGridProps {
  products: Product[];
  isLoading: boolean;
  emptyMessage?: string;
}
```

- Grid: 1 col mobile, 2 col tablet, 3-4 col desktop.
- Skeleton loading state using shadcn-ui Skeleton.
- Empty state with illustration and CTA.

### SizeTierSelector

Selects figurine size (S/M/L/XL) with visual comparison.

```tsx
interface SizeTierSelectorProps {
  tiers: ProductSizeTier[];
  selected: SizeTier;
  onChange: (tier: SizeTier) => void;
}
```

- Visual height comparison (silhouette scale diagram).
- Shows price per tier.
- Highlights selected tier with brand accent color.

### ModelViewer

3D model viewer wrapping React Three Fiber.

```tsx
interface ModelViewerProps {
  glbUrl: string;
  fallbackImageUrl: string;
  autoRotate?: boolean;
  enableZoom?: boolean;
}
```

- Loads GLB model via useGLTF from @react-three/drei.
- OrbitControls with constrained zoom and rotation.
- Auto-rotate by default, stops on user interaction.
- Fallback to static image if WebGL unavailable.
- Loading spinner while model downloads.
- Keyboard controls for accessibility (arrow keys for orbit).

### CartDrawer

Slide-out cart panel using shadcn-ui Sheet.

```tsx
interface CartDrawerProps {
  open: boolean;
  onClose: () => void;
}
```

- Lists cart items with thumbnail, name, size, quantity, price.
- Quantity adjust (+/-) and remove buttons.
- Subtotal calculation.
- "Continue Shopping" and "Checkout" CTAs.
- Empty cart state with product suggestions.

### CheckoutForm

Multi-step checkout flow.

```tsx
interface CheckoutFormProps {
  cart: CartItem[];
  onComplete: (order: Order) => void;
}
```

- Step 1: Shipping address (form with Zod validation).
- Step 2: Shipping method (Zasilkovna pickup point / DHL to address).
- Step 3: Payment (Stripe Elements embedded form).
- Step 4: Order confirmation with summary.
- Progress indicator showing current step.

### OrderTracker

Displays order status timeline.

```tsx
interface OrderTrackerProps {
  order: Order;
}
```

- Visual timeline: ordered → paid → printing → shipped → delivered.
- Current step highlighted, future steps dimmed.
- Tracking link when available (Zasilkovna/DHL tracking URL).

### PromptInput

Text input for custom figurine orders.

```tsx
interface PromptInputProps {
  onSubmit: (prompt: string) => void;
  maxLength?: number;
  examples?: string[];
}
```

- Large textarea with character count.
- Example prompts as clickable chips below input.
- "Generate Preview" CTA button.
- Loading state during AI generation.

## State Management

### Cart Context

```tsx
interface CartContextValue {
  items: CartItem[];
  addItem: (product: Product, sizeTier: SizeTier, quantity: number) => void;
  removeItem: (itemId: string) => void;
  updateQuantity: (itemId: string, quantity: number) => void;
  clearCart: () => void;
  totalItems: number;
  subtotal: number;
}
```

- Persisted to localStorage for cart recovery.
- Optimistic updates for add/remove/quantity changes.

### Server State (TanStack Query)

```tsx
// Product catalog
useQuery({ queryKey: ['products', filters], queryFn: fetchProducts });

// Single product
useQuery({ queryKey: ['product', sku], queryFn: () => fetchProduct(sku) });

// Custom order status (polling)
useQuery({
  queryKey: ['custom-order', orderId],
  queryFn: () => fetchCustomOrder(orderId),
  refetchInterval: (data) => data?.status === 'generating' ? 5000 : false,
});
```

- Stale time: 5 minutes for catalog, 1 minute for orders.
- Error boundaries for failed queries.
- Prefetch on hover for product detail pages.

## shadcn-ui Customization

- Use the Figurio color palette in `tailwind.config.ts` (brand primary, secondary, accent).
- Override shadcn-ui CSS variables in `globals.css` for consistent theming.
- Prefer shadcn-ui components over custom implementations: Button, Card, Sheet, Dialog, Toast, Skeleton, Badge, Input, Select, Tabs.
- Extend shadcn-ui only when needed — do not wrap every component in a custom abstraction.

## TypeScript Patterns

- All component props have explicit interfaces (no inline types).
- Use `as const` for enum-like values (size tiers, order statuses).
- Zod schemas shared between frontend validation and API response parsing.
- No `any` types — use `unknown` and narrow with type guards.
- API response types generated from OpenAPI spec when possible.

## File Organization

```
src/
├── components/
│   ├── ui/           # shadcn-ui components (auto-generated)
│   ├── product/      # ProductCard, ProductGrid, SizeTierSelector
│   ├── cart/         # CartDrawer, CartItem
│   ├── checkout/     # CheckoutForm, ShippingForm, PaymentForm
│   ├── order/        # OrderTracker, OrderSummary
│   ├── viewer/       # ModelViewer, ViewerControls
│   └── layout/       # Header, Footer, Layout
├── contexts/         # CartContext, AuthContext
├── hooks/            # useProducts, useCart, useCustomOrder
├── pages/            # Route-level page components
├── lib/              # API client, utilities, constants
└── types/            # Shared TypeScript types
```
