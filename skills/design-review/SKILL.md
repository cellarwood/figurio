---
name: design-review
description: >
  Visual QA checklist for Figurio storefront pages. Covers product listing grid,
  product detail with 3D preview, AI prompt interface, cart/checkout flow, order
  tracking, mobile responsiveness, and brand consistency for the full-color 3D
  figurine D2C experience.
allowed-tools:
  - Read
  - Grep
  - Glob
metadata:
  paperclip:
    tags:
      - design
      - review
      - qa
---

# Design Review

Use this checklist when reviewing any Figurio storefront page or component. Run through the relevant section(s) for the page type being reviewed, then check the universal rules at the bottom.

## How to Review

1. Open the page in both desktop (1440px) and mobile (375px) viewports
2. Walk through the section checklist specific to that page
3. Check the universal brand consistency rules at the end
4. Flag issues with: **[BLOCKER]** for anything that breaks usability/brand, **[MINOR]** for polish items

---

## Product Listing Grid

- [ ] Grid is `2-col → 3-col → 4-col` at `sm → md → lg` breakpoints — not a horizontal scroll carousel
- [ ] All cards are the same height within a row (CSS grid, not flexbox wrapping)
- [ ] Product images use 3:4 aspect ratio with `object-cover` — no squashed or letterboxed thumbnails
- [ ] Collector badges (New, Limited, Bestseller) appear top-left with correct color: Limited = coral-500, New = teal-400, Bestseller = gold-400
- [ ] Price is always visible without truncation on any card width
- [ ] "Add to Cart" button is present and reachable without hovering on mobile
- [ ] Empty search/filter state shows an illustration + helpful message — never a blank grid
- [ ] Filter/sort controls collapse into a drawer or bottom sheet on mobile — not a horizontal overflow bar
- [ ] Card hover state: `scale-[1.02]` + `shadow-lg`, 200ms ease-out — verify it does not cause layout shift

## Product Detail Page

- [ ] 3D viewer is square (`aspect-square`), full-width on mobile, and occupies left half on desktop (50/50 split with product info)
- [ ] Viewer shows a coral-500 spinner during model load — not a blank canvas
- [ ] "Drag to rotate" hint appears on viewer mount and fades after ~3 seconds
- [ ] Viewer controls (rotate, zoom, reset) are visible and reachable on touch screens — minimum 44×44px tap targets
- [ ] Product name uses `text-2xl font-semibold` — not a generic `<h1>` with browser default styling
- [ ] Material/finish selector uses swatches or a labeled `<Select>` — never raw radio buttons
- [ ] Price updates immediately when a variant (size, material) is selected
- [ ] Star rating uses gold-400 filled stars — not gray or coral
- [ ] "Add to Cart" CTA is coral-500, full-width on mobile, sticky at the bottom on mobile scroll
- [ ] Related products section follows the same card spec as the listing grid

## AI Prompt Interface (Custom Figurine Creator)

- [ ] Prompt textarea has a visible character counter and a max-length limit (no silent truncation)
- [ ] Submit button is disabled and shows a loading state while generation is in progress — not a spinner overlaid on an active button
- [ ] Generated preview renders in the 3D viewer component — not a flat 2D image
- [ ] Error state (generation failed) surfaces a human-readable message in red-600, not a raw API error
- [ ] Prompt suggestions/examples are displayed as chips — tappable on mobile, dismiss-able
- [ ] The interface communicates estimated generation time before the user submits
- [ ] "Start over" / clear action is available and does not require a page reload

## Cart & Checkout Flow

### Cart Drawer
- [ ] Opens as a right-side sheet (`max-w-sm`), does not push page content
- [ ] Line item thumbnail is 48×48px rounded-lg — not a tiny icon or full-width image
- [ ] Quantity stepper has `min=1` enforced — decrementing below 1 removes the item (with confirmation)
- [ ] Subtotal updates instantly on quantity change — no full drawer reload
- [ ] "Checkout" button is full-width, coral-500, sticky at the drawer footer
- [ ] Empty state includes an illustration and a "Browse figurines" link — not just text

### Checkout (3-Step Flow)
- [ ] Step indicator shows Shipping → Payment → Review — completed steps are teal-400, active is coral-500, pending is ink-200
- [ ] "Continue" button is disabled until required fields pass validation
- [ ] Inline field errors appear below the input in `text-sm text-red-600` — not in a toast or alert banner
- [ ] Back navigation preserves all previously entered form values
- [ ] Order review step shows a full summary (items, quantities, prices, shipping address, estimated delivery)
- [ ] "Place Order" button has a loading state and is disabled after first click (prevent double-submission)
- [ ] On mobile, the step indicator does not overflow — uses abbreviated labels or icon-only if needed

## Order Tracking

- [ ] Timeline uses the correct step sequence: Confirmed → Printing → Quality Check → Shipped → Delivered
- [ ] Active step has a coral-500 pulsing ring — not just a different color dot
- [ ] Completed steps use teal-400 — not coral or gold
- [ ] Tracking number (once shipped) is a tappable link to the carrier's tracking page
- [ ] Order summary bar (`bg-canvas-100 rounded-xl`) is present at the top with order ID, date, and total
- [ ] If an order is delayed, a banner or status note explains why — the timeline alone is insufficient

---

## Mobile Responsiveness (All Pages)

- [ ] No horizontal overflow at 375px — use browser devtools "overflow: hidden" audit
- [ ] All tap targets are at minimum 44×44px (buttons, links, swatches, stepper controls)
- [ ] Font sizes never drop below `text-sm` (14px) for interactive labels or `text-xs` (12px) for captions
- [ ] Sticky elements (CTA buttons, cart footer) do not overlap page content unexpectedly
- [ ] Images load with correct `srcSet` / responsive sizes — not full-resolution desktop images on mobile
- [ ] Modals and drawers are full-screen or near-full-screen on mobile (`w-full`, `max-h-[90dvh]`)
- [ ] Bottom navigation (if present) does not obscure sticky CTAs

---

## Brand Consistency (Universal)

- [ ] All primary CTAs use coral-500 background — no blue, green, or black primary buttons
- [ ] Page backgrounds are `bg-canvas-50` — not pure white (`#FFFFFF`) or default gray
- [ ] Card/surface backgrounds are `bg-canvas-100` — not white
- [ ] Headings use Clash Display (`font-display`) for display-scale text, Inter for everything else
- [ ] Icons are Lucide React only — no Heroicons, Font Awesome, or SVG one-offs
- [ ] No hard-coded hex colors in JSX `style` props — all color via Tailwind classes or CSS variables
- [ ] Playful, collector-friendly tone in all empty states and error messages — no terse "No results" or "Error 500" copy
- [ ] Figurio logo lockup matches the approved version — no stretched, recolored, or outdated variants
- [ ] Animations follow the defined durations (hover: 200ms, drawers: 300ms) — no janky instant transitions or sluggish 600ms+ animations
