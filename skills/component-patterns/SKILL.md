---
name: component-patterns
description: React component architecture and patterns for the Figurio storefront
---

# Component Patterns

## Component Hierarchy

```
App
├── Layout (header, footer, navigation)
├── Pages
│   ├── HomePage (hero, featured grid, CTA sections)
│   ├── CatalogPage (filters + product grid)
│   ├── ProductDetailPage (images, 3D viewer, size selector, add to cart)
│   ├── CustomFigurinePage (prompt input, status, preview, approve/reject)
│   ├── CartPage (items, summary, checkout CTA)
│   ├── CheckoutPage (Stripe Elements, address form)
│   └── AccountPage (order history, order detail)
└── Shared Components
    ├── ProductCard (image, name, price, size badges)
    ├── ModelViewer (3D preview using model-viewer or Three.js)
    ├── SizeSelector (small/medium/large with prices)
    ├── PriceDisplay (formatted price with currency)
    └── OrderStatusTimeline (visual status steps)
```

## Rules

1. **Use shadcn-ui first.** Check if a shadcn component exists before building custom. Customize with Tailwind classes.
2. **Collocate.** Page-specific components live next to the page. Shared components in `src/components/`.
3. **Props over context.** Pass data via props. Use React context only for: auth state, cart state, theme.
4. **TypeScript strict.** All props typed with interfaces. No `any`. No implicit returns.
5. **Server data.** Use React Query (TanStack Query) for API data fetching and caching.

## Naming

- Components: PascalCase (`ProductCard.tsx`)
- Hooks: camelCase with `use` prefix (`useProducts.ts`)
- Utils: camelCase (`formatPrice.ts`)
- Types: PascalCase in `types/` directory

## 3D Model Viewer Integration

Start with `<model-viewer>` web component:

```tsx
<model-viewer
  src={modelUrl}
  alt={productName}
  auto-rotate
  camera-controls
  shadow-intensity="1"
  style={{ width: '100%', height: '400px' }}
/>
```

Upgrade to Three.js only if: custom shading, annotations, or advanced camera control is needed.
