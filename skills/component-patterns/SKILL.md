---
name: component-patterns
description: React component architecture and patterns for the Figurio storefront — shadcn-ui composition, state management, and reusable component guidelines
---

# Component Patterns

## Component Architecture

Figurio uses a composition-based component architecture built on shadcn-ui and Radix UI primitives.

### Directory Structure

```
src/
  components/
    ui/              # shadcn-ui base components (Button, Card, Dialog, etc.)
    catalog/         # Product catalog components
      ProductCard.tsx
      ProductGrid.tsx
      CatalogFilters.tsx
      SizeTierSelector.tsx
    cart/            # Shopping cart components
      CartItem.tsx
      CartSummary.tsx
      CartDrawer.tsx
    checkout/        # Checkout flow components
      StripeCheckout.tsx
      OrderConfirmation.tsx
    custom/          # AI custom figurine components
      PromptInput.tsx
      ModelViewer.tsx
      PreviewApproval.tsx
    order/           # Order tracking components
      OrderStatus.tsx
      StatusTimeline.tsx
    layout/          # Layout components
      Header.tsx
      Footer.tsx
      Navigation.tsx
```

### Component Rules

1. **One component per file** — named export matching filename
2. **Props interface** — define inline above the component, not in a separate file
3. **Composition over configuration** — build complex UIs from simple parts
4. **Controlled components** — parent owns state, child receives via props
5. **shadcn-ui first** — use existing shadcn components before building custom ones

### Key Components

#### SizeTierSelector
Displays Small/Medium/Large options with pricing. Used on product detail and custom order pages.
- Shows height, price, and visual size comparison
- Controlled: `value` and `onChange` props
- Highlights price difference between tiers

#### ModelViewer
Interactive 3D model viewer for figurine preview.
- Wraps three.js or @google/model-viewer
- Supports rotation, zoom, and pan
- Loading state with skeleton
- Works on mobile with touch gestures

#### ProductCard
Catalog grid item showing figurine thumbnail, name, and price range.
- Lazy-loads images
- Shows price range (lowest tier – highest tier)
- Quick-add button opens size selector

### State Management

- **Server state:** React Query (TanStack Query) for API data
- **UI state:** React useState/useReducer for component state
- **Cart state:** Context + useReducer, persisted to localStorage
- No global state library — keep it simple until complexity demands it
