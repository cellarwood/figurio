---
name: design-system
description: >
  Figurio design system — color palette (primary, secondary, accent, neutral),
  typography (headings, body, UI text), spacing scale, component library specs
  (product cards, buttons, forms, modals), icon usage, and responsive breakpoints.
  Covers design token conventions for Tailwind CSS and shadcn-ui handoff between
  UI Designer and Frontend Engineer.
metadata:
  paperclip:
    tags:
      - design
      - frontend
      - ui
---

# Design System

Use this skill when designing new UI screens, specifying components for handoff to
the Frontend Engineer, auditing existing components for consistency, or extending
the component library.

## Color Palette

Figurio's palette reflects the brand: playful but premium, vibrant without being cheap.
All colors are defined as CSS custom properties and Tailwind config extensions.

| Token | Hex | Usage |
|-------|-----|-------|
| `--color-primary` | `#6C3DFF` | CTAs, active states, key interactive elements |
| `--color-primary-light` | `#A47BFF` | Hover states, highlights, badges |
| `--color-primary-dark` | `#4A20D9` | Pressed states, focus rings |
| `--color-secondary` | `#FF6B6B` | Accent buttons, sale/promo labels, urgency |
| `--color-accent` | `#00C9A7` | Success states, positive indicators, tags |
| `--color-neutral-900` | `#1A1A2E` | Primary text, headings |
| `--color-neutral-600` | `#5E5E7A` | Body text, secondary labels |
| `--color-neutral-300` | `#C7C7DC` | Borders, dividers, disabled states |
| `--color-neutral-100` | `#F3F3FA` | Page background, card backgrounds |
| `--color-neutral-0` | `#FFFFFF` | Surface backgrounds, modals |

### Color Usage Rules

- Primary (`#6C3DFF`) is reserved for the one primary CTA per screen. Never use it
  decoratively or for non-interactive elements.
- Secondary (`#FF6B6B`) is for promotional/urgency contexts only — sale badges, countdown
  timers, limited-edition labels. Do not use it for destructive actions (use a dedicated
  error red: `#E53E3E`).
- Never place `--color-primary` text on `--color-secondary` background or vice versa.
  Both are high-saturation; combined they clash with the premium feel.
- Dark mode: flip neutrals (900 ↔ 0, 600 ↔ 300) and keep primary/secondary/accent
  unchanged — they are designed to work on dark surfaces.

## Typography

Font stack: **"Plus Jakarta Sans"** (headings and UI) + **"Inter"** (body and long-form
content). Both are loaded via Google Fonts. Fallback: `system-ui, sans-serif`.

| Role | Font | Weight | Size (desktop) | Line Height |
|------|------|--------|----------------|-------------|
| `h1` — page hero | Plus Jakarta Sans | 800 | 56px / 3.5rem | 1.1 |
| `h2` — section title | Plus Jakarta Sans | 700 | 36px / 2.25rem | 1.2 |
| `h3` — card/modal title | Plus Jakarta Sans | 600 | 24px / 1.5rem | 1.3 |
| `h4` — subheading | Plus Jakarta Sans | 600 | 18px / 1.125rem | 1.4 |
| Body large | Inter | 400 | 16px / 1rem | 1.6 |
| Body small | Inter | 400 | 14px / 0.875rem | 1.5 |
| UI label | Plus Jakarta Sans | 500 | 13px / 0.8125rem | 1.4 |
| Caption | Inter | 400 | 12px / 0.75rem | 1.5 |
| Price / numeric | Plus Jakarta Sans | 700 | context-dependent | 1.2 |

Mobile scaling: `h1` → 36px, `h2` → 28px, `h3` → 20px. Body and UI text stay fixed.

## Spacing Scale

Figurio uses an 8px base unit. All spacing values are multiples of 4px with preference
for 8px increments. Map directly to Tailwind's default scale — do not introduce custom
spacing values without CTO/UI Designer approval.

| Scale | px | Tailwind class |
|-------|----|----------------|
| xs | 4px | `p-1`, `gap-1` |
| sm | 8px | `p-2`, `gap-2` |
| md | 16px | `p-4`, `gap-4` |
| lg | 24px | `p-6`, `gap-6` |
| xl | 32px | `p-8`, `gap-8` |
| 2xl | 48px | `p-12`, `gap-12` |
| 3xl | 64px | `p-16`, `gap-16` |

Page-level horizontal padding: `px-4` (mobile), `px-8` (md), `px-16` (xl).
Max content width: `max-w-7xl` (1280px) centered with `mx-auto`.

## Responsive Breakpoints

Figurio uses Tailwind's default breakpoints without customization:

| Name | Min width | Primary use |
|------|-----------|-------------|
| (default) | 0px | Mobile-first base styles |
| `sm` | 640px | Larger phones / small tablets |
| `md` | 768px | Tablets — layout shifts from 1 to 2 columns |
| `lg` | 1024px | Desktop — primary design target |
| `xl` | 1280px | Wide desktop — content max-width kicks in |
| `2xl` | 1536px | Large screens — increase whitespace only |

Design at `lg` (1024px) as the primary breakpoint. Always verify `md` and default
(375px) before handing off to frontend.

## Component Specs

### Product Card

Used on catalog grids, search results, and recommendation carousels.

```
┌──────────────────────────┐
│   [figurine image 1:1]   │  ← aspect-ratio: 1/1, object-cover
│                          │    corner-radius: rounded-xl (12px)
├──────────────────────────┤
│  [badge: "New" / "Sale"] │  ← optional, top-left overlay on image
│  Figurine Name           │  ← h4, neutral-900, truncate 2 lines
│  Collector Series · RPG  │  ← caption, neutral-600
│  €24.90                  │  ← price, primary, font-weight 700
│  [Add to Cart]           │  ← full-width primary button
└──────────────────────────┘
```

- Card background: `neutral-0`, shadow: `shadow-md`, hover: `shadow-xl` + 2px upward
  translate (GSAP or Tailwind transition).
- On mobile the grid is 2-column. On `lg` it is 4-column.
- "Add to Cart" button collapses to an icon-only `+` button on the 2-column mobile grid.

### Buttons

Three variants; all use Plus Jakarta Sans, weight 600, `rounded-full`.

| Variant | Background | Text | Border | Usage |
|---------|-----------|------|--------|-------|
| Primary | `primary` | white | none | One per screen — main CTA |
| Secondary | transparent | `primary` | 2px `primary` | Supporting actions |
| Ghost | transparent | `neutral-600` | none | Tertiary, destructive-cancel |

Sizes: `sm` (32px h, px-4, text-sm), `md` (40px h, px-6, text-base — default),
`lg` (48px h, px-8, text-lg).

Disabled state: 40% opacity, `cursor-not-allowed`. Loading state: spinner replaces
label, button width locked to prevent layout shift.

### Forms

- Input height: 40px (`md`) or 48px (`lg` — checkout, account).
- Border: 1px `neutral-300`, focus: 2px `primary`, error: 2px `#E53E3E`.
- Label: UI label size, `neutral-900`, always above the field (no floating labels).
- Error message: caption size, `#E53E3E`, below the field with a warning icon.
- Use shadcn-ui `Input`, `Select`, `Checkbox`, `RadioGroup` as the base — style via
  Tailwind class overrides, not component prop variants.

### Modals

- Max width: `max-w-lg` (512px). Full-screen on mobile.
- Header: h3, `neutral-900`, with an X close button top-right (`ghost` button, icon-only).
- Body: scrollable if content exceeds 60vh. Padding: `p-6`.
- Footer: right-aligned button row — primary action right, cancel left.
- Backdrop: `bg-neutral-900/60` blur-sm. Use Radix UI `Dialog` as the base.

## Icon Usage

Icon library: **Lucide React** (already a shadcn-ui dependency — do not introduce a
second icon library).

- Size: 16px for inline/UI icons, 20px for action icons in buttons, 24px for
  standalone/decorative icons.
- Color: inherit from parent text color. Never hard-code icon colors separately from
  their context.
- Stroke width: 1.5px (Lucide default — do not change).
- Figurine-specific custom icons (e.g., 3D cube, print nozzle) live in
  `src/assets/icons/` as SVG React components. Use them only for marketing/hero
  contexts, not for UI controls.

## Design Tokens — Tailwind / shadcn-ui Handoff

Define all tokens in `tailwind.config.ts` under `theme.extend`. Use CSS custom
properties so that shadcn-ui's theming layer can override them.

```ts
// tailwind.config.ts (abbreviated)
theme: {
  extend: {
    colors: {
      primary: {
        DEFAULT: 'var(--color-primary)',      // #6C3DFF
        light:   'var(--color-primary-light)', // #A47BFF
        dark:    'var(--color-primary-dark)',  // #4A20D9
      },
      secondary: 'var(--color-secondary)',     // #FF6B6B
      accent:    'var(--color-accent)',        // #00C9A7
    },
    fontFamily: {
      heading: ['Plus Jakarta Sans', 'system-ui', 'sans-serif'],
      body:    ['Inter', 'system-ui', 'sans-serif'],
    },
  },
}
```

When specifying a design for handoff, always reference token names (`text-primary`,
`bg-neutral-100`) — never raw hex values. This ensures dark mode and theming work
without additional rework.

## Anti-patterns

- Using `secondary` color for destructive/error states — it reads as "promo", not "danger".
- Mixing icon libraries (e.g., adding Heroicons alongside Lucide) — creates visual
  inconsistency and bundle bloat.
- Floating labels on form inputs — they fail accessibility audits and confuse users on
  the figurine configuration form which has many fields.
- Cards without a defined hover state — the playful brand requires micro-interactions;
  flat static cards feel low-quality.
- Specifying pixel values in handoff notes instead of Tailwind class names — causes
  frontend to introduce one-off inline styles.
