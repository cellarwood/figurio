---
name: component-patterns
description: >
  React component architecture patterns for the Figurio storefront —
  shadcn-ui customization, Three.js 3D viewer integration, product card design,
  and state management conventions.
---

# Component Patterns

## Component Structure

```
src/
├── components/
│   ├── ui/              # shadcn-ui primitives (Button, Card, Dialog, etc.)
│   ├── product/         # Product-specific components
│   │   ├── ProductCard.tsx
│   │   ├── ProductGrid.tsx
│   │   ├── ProductDetail.tsx
│   │   ├── SizeTierSelector.tsx
│   │   └── ModelViewer.tsx      # Three.js 3D viewer
│   ├── cart/            # Cart and checkout components
│   ├── order/           # Order tracking components
│   └── custom/          # AI custom figurine flow
├── hooks/               # Custom React hooks
├── lib/                 # Utilities, API client
└── pages/               # Route-level page components
```

## Conventions

- Use shadcn-ui components as the base — customize via Tailwind, don't override internals
- Every component gets its own file (no multi-component files)
- Props interfaces are defined in the same file as the component
- Server state via React Query (`useQuery`, `useMutation`)
- Client state via Zustand stores (cart, UI state) or React context
- All components must accept a `className` prop for composition
- Use TypeScript strict mode — no `any` types

## Product Card Pattern

The ProductCard is the most reused component. It must:
- Show product image with hover effect (zoom or 3D rotation preview)
- Display name, price range (smallest to largest tier), and category badge
- Link to product detail page
- Support grid and list layout variants

## 3D Viewer Pattern

The ModelViewer component wraps React Three Fiber:
- Lazy-load the 3D model (show skeleton/placeholder while loading)
- Support orbit controls with touch gestures on mobile
- Auto-rotate by default, pause on interaction
- Provide fallback to image gallery if WebGL unavailable
