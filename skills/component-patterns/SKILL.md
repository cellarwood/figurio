---
name: Component Patterns
description: React component architecture, design system usage, and state management patterns for Figurio's storefront
---

# Component Patterns

## Component Hierarchy

```
App
├── Layout (Header, Footer, Navigation)
├── Pages
│   ├── CatalogPage (product grid, filters, search)
│   ├── ProductDetailPage (3D viewer, size selector, add to cart)
│   ├── CustomOrderPage (prompt input, generation progress, preview)
│   ├── CheckoutPage (cart summary, Stripe payment)
│   ├── AccountPage (profile, order history)
│   └── AdminQAPage (QA review dashboard)
└── Shared Components
    ├── FigurineCard (thumbnail, name, price)
    ├── FigurineViewer (Three.js 3D model viewer)
    ├── SizeSelector (S/M/L with price)
    ├── CartSidebar (items, total, checkout button)
    └── OrderStatusBadge (colored status indicator)
```

## Component Rules

1. **Use shadcn-ui first.** Before building a custom component, check if shadcn-ui has one. Customize via Tailwind, don't fork.
2. **One component, one file.** No barrel exports, no index.ts re-exports unless the folder has 3+ related components.
3. **Props over context.** Pass data via props until it's genuinely painful (3+ levels of prop drilling). Then use React context.
4. **Server state via React Query.** All API calls go through `useQuery` / `useMutation`. No `useEffect` + `fetch` patterns.
5. **TypeScript strict.** All props typed, no `any`, no `as` casts unless unavoidable.

## 3D Viewer Component

The `FigurineViewer` is the most important component. Requirements:
- Loads GLB/OBJ files via React Three Fiber
- Orbit controls: rotate (drag), zoom (scroll), pan (right-drag)
- Touch controls for mobile (pinch zoom, drag rotate)
- Auto-rotate when idle (stop on interaction)
- Loading skeleton while model loads
- Fallback to static images if WebGL unavailable
- Performance: target 60fps on mid-range mobile devices

## Responsive Breakpoints

```
mobile:  < 640px   (1 column, stacked layout)
tablet:  640-1024px (2 columns, adjusted spacing)
desktop: > 1024px   (3-4 columns, sidebar layout)
```

Always design mobile first, then add `sm:`, `md:`, `lg:` Tailwind modifiers.
