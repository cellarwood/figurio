---
name: design-system
description: >
  Figurio design system — color palette, typography scale, spacing tokens, and
  component library specs for the storefront. Covers product cards, 3D preview
  viewer, cart, checkout, and order tracking components built with React/TS,
  shadcn-ui, Tailwind CSS, and Radix UI.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags:
      - design
      - frontend
      - ui
---

# Design System

Figurio's design system supports a playful, collector-oriented D2C storefront for full-color 3D-printed figurines. All components are built on shadcn-ui + Radix UI primitives, styled with Tailwind CSS utility classes.

## Color Palette

| Token | Tailwind Class | Hex | Usage |
|---|---|---|---|
| Brand Coral | `bg-coral-500` | `#FF5C4D` | Primary CTAs, highlights |
| Brand Coral Dark | `bg-coral-700` | `#CC3A2D` | Hover states on coral |
| Ink | `bg-ink-900` | `#1A1A2E` | Body text, headings |
| Ink Muted | `text-ink-500` | `#6B6B8A` | Secondary text, labels |
| Canvas | `bg-canvas-50` | `#FAF9F7` | Page background |
| Canvas Raised | `bg-canvas-100` | `#F2F0EC` | Card surfaces |
| Vivid Teal | `bg-teal-400` | `#2DD4BF` | Accents, badges, success states |
| Gold | `bg-gold-400` | `#FBBF24` | Star ratings, collector badges |
| Error | `bg-red-600` | `#DC2626` | Validation errors |

The palette leans warm and tactile — avoid cold grays or stark white backgrounds.

## Typography Scale

All text uses the **Inter** variable font loaded via `next/font`. Headings use `font-display` (Clash Display) for playful weight contrast.

| Scale | Tailwind | Size / Line-height | Usage |
|---|---|---|---|
| Display XL | `text-5xl font-display font-bold` | 48px / 1.1 | Hero headings |
| Display L | `text-4xl font-display font-bold` | 36px / 1.15 | Section titles |
| Heading M | `text-2xl font-semibold` | 24px / 1.3 | Product name, card titles |
| Heading S | `text-lg font-semibold` | 18px / 1.4 | Sub-sections, modal titles |
| Body | `text-base` | 16px / 1.6 | Descriptions, paragraph copy |
| Body S | `text-sm` | 14px / 1.5 | Labels, meta, secondary info |
| Caption | `text-xs` | 12px / 1.4 | Timestamps, fine print |

Never use font sizes outside this scale via arbitrary values.

## Spacing Tokens

Figurio uses an 4px base grid. Prefer multiples of 4 — use Tailwind spacing scale directly.

| Role | Tailwind | px |
|---|---|---|
| Micro gap | `gap-1` / `p-1` | 4 |
| Component inner padding | `p-3` / `p-4` | 12–16 |
| Card padding | `p-5` / `p-6` | 20–24 |
| Section gap | `gap-8` / `my-8` | 32 |
| Section vertical padding | `py-16` | 64 |
| Page horizontal margin | `px-4 md:px-8 lg:px-16` | responsive |

## Component Specs

### Product Card

```
<ProductCard>
  ├── Aspect ratio: 3/4, rounded-2xl, overflow-hidden
  ├── Image: object-cover, bg-canvas-100 placeholder
  ├── Badge strip (top-left): collector tier, new, limited — text-xs font-semibold
  ├── Body: p-4
  │   ├── Title: text-lg font-semibold text-ink-900, 2-line clamp
  │   ├── Material tag: text-xs text-ink-500
  │   ├── Star rating: gold-400 fill, text-sm
  │   └── Price + Add-to-cart row: flex justify-between items-center
└── Hover: shadow-lg scale-[1.02] transition-all duration-200
```

- Cards in grid: `grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6`
- No horizontal scrolling carousels on desktop — use grid

### 3D Preview Viewer

```
<ModelViewer>
  ├── Container: aspect-square rounded-3xl bg-canvas-100 relative
  ├── Canvas: fills container, transparent bg
  ├── Controls overlay (bottom-center):
  │   ├── Rotate button (icon), Zoom in/out, Reset — bg-white/80 backdrop-blur
  │   └── "Drag to rotate" hint — text-xs text-ink-500, fades after 3s
  ├── Loading state: centered spinner in coral-500
  └── Error state: centered icon + "Preview unavailable" text-sm text-ink-500
```

- Viewer is always square on product detail — never stretch to fill arbitrary heights
- On mobile, viewer is full-width above the fold; description scrolls beneath

### Cart Drawer

- Triggered from header icon, slides in from the right (`translate-x` transition)
- Width: `w-full max-w-sm`
- Line items: product thumbnail (48×48, rounded-lg) + name + quantity stepper + price
- Quantity stepper: Radix UI `NumberField` or `+/-` buttons with `min=1`
- Sticky footer: subtotal + "Checkout" button (full-width, coral-500)
- Empty state: centered illustration + "Your cart is empty" + "Browse figurines" link

### Checkout Flow

3-step linear flow: **Shipping → Payment → Review & Place Order**

- Step indicator: `flex gap-2` with numbered circles — completed steps use teal-400 fill, active uses coral-500, pending uses ink-200
- Form fields: shadcn-ui `<Input>` with `label` above, error message below in red-600 text-sm
- "Continue" button: always at the bottom, full-width on mobile, right-aligned on desktop
- No progress is lost on back-navigation — preserve form state in component state or URL params

### Order Tracking

```
<OrderTracker>
  ├── Order summary bar: order ID, placed date, total — bg-canvas-100 rounded-xl p-4
  ├── Status timeline: vertical stepper
  │   ├── Steps: Confirmed → Printing → Quality Check → Shipped → Delivered
  │   ├── Completed step: teal-400 dot + ink-900 label
  │   ├── Active step: coral-500 dot + pulsing ring + ink-900 bold label
  │   └── Pending step: ink-200 dot + ink-500 label
  └── Shipment card (when shipped): carrier, tracking number, estimated delivery
```

## Iconography

Use **Lucide React** exclusively. Icon sizes:

| Context | Size class |
|---|---|
| Navigation / header | `size-5` (20px) |
| Inline with text | `size-4` (16px) |
| Standalone feature icons | `size-8` (32px) |
| Empty state illustrations | `size-16` (64px) |

Never mix Lucide with other icon libraries in the same component.

## Radix UI & shadcn-ui Usage

- Use shadcn-ui components as the default for: `Button`, `Input`, `Select`, `Dialog`, `Sheet`, `Tooltip`, `Badge`, `Skeleton`
- Customize via `className` prop — never modify the generated component file directly
- Radix primitives (`@radix-ui/react-*`) are used directly only when shadcn-ui does not provide a wrapper
- All interactive components must expose `ref` and spread `...props` for accessibility

## Animation Defaults

| Interaction | Duration | Easing |
|---|---|---|
| Hover scale / shadow | 200ms | ease-out |
| Drawer / sheet open | 300ms | ease-in-out |
| Skeleton shimmer | 1.5s | linear loop |
| 3D viewer fade-in | 400ms | ease-out |
| Page transitions | 250ms | ease-in-out |

Use Tailwind's `transition-*` utilities. Avoid `animate-spin` on anything other than loading spinners.
