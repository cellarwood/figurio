---
name: brand-guidelines
description: >
  Visual brand guidelines for Figurio — logo usage rules (clear space, minimum size,
  color variants), imagery style (product photography, lifestyle shots, 3D renders),
  packaging design specs, social media template dimensions, and color usage rules for
  marketing materials. Reference for the UI Designer and Content Creator agents when
  producing any customer-facing visual asset.
metadata:
  paperclip:
    tags:
      - brand
      - design
      - marketing
---

# Brand Guidelines

Use this skill when producing or reviewing any customer-facing visual: website banners,
social posts, email headers, packaging inserts, or ad creatives. Also apply it when
briefing the Content Creator agent on new asset requests.

## Brand Personality

Figurio sits at the intersection of craft and technology. The brand voice is:

- **Playful** — not childish. Think "collector's enthusiasm", not "toy store".
- **Creative** — celebrate the maker culture; 3D printing is the hero, not a footnote.
- **Premium but accessible** — a €25 figurine should feel like a considered purchase,
  not fast fashion, but not intimidating either.

Every visual asset should pass the question: "Does this make a collector, gamer, or
cosplayer feel seen and excited?" If it feels like a generic e-commerce template, redo it.

## Logo

### Variants

| Variant | File | Use case |
|---------|------|----------|
| Full color (primary) | `logo/figurio-full-color.svg` | Light backgrounds, default |
| White (reversed) | `logo/figurio-white.svg` | Dark backgrounds, overlays, packaging |
| Dark (neutral-900) | `logo/figurio-dark.svg` | Grayscale print, low-contrast contexts |
| Icon only | `logo/figurio-icon.svg` | Favicon, app icon, small placements |

Never use the full-color logo on a dark background — use the white variant.
Never recreate the logo in other software. Always use the SVG source files.

### Clear Space

Minimum clear space around the logo on all sides: **1× the height of the "F" letterform**
in the wordmark. No other graphic elements, text, or photography may enter this zone.

### Minimum Size

| Context | Minimum width |
|---------|---------------|
| Print | 25mm |
| Digital | 80px |
| Icon-only variant | 16px (favicon), 24px (UI) |

Below minimum size, the icon-only variant must be used instead of the wordmark.

### Prohibited Uses

- Do not stretch, skew, rotate, or apply drop shadows to the logo.
- Do not recolor the logo outside the approved variants above.
- Do not place the full-color logo on the secondary red (`#FF6B6B`) or accent green
  (`#00C9A7`) backgrounds — contrast fails and the brand reads as chaotic.
- Do not lock up the Figurio logo with partner/vendor logos without explicit approval.

## Imagery Style

Figurio sells physical objects that begin as digital ideas. Imagery must bridge both worlds.

### Product Photography

- **Background:** Pure white (`#FFFFFF`) or light neutral (`#F3F3FA`) sweep.
  No lifestyle props in primary product shots — let the figurine be the hero.
- **Lighting:** Soft box, 3-point setup. Avoid harsh shadows; the goal is to show surface
  texture and paint detail clearly.
- **Angle:** Primary shot at 3/4 front view, 15° elevation. Secondary shots: top-down,
  rear 3/4, detail close-up (face/hands).
- **Aspect ratio:** 1:1 for catalog tiles, 4:5 for social, 16:9 for hero banners
  (leave headroom for logo/text overlay).
- **Resolution:** Minimum 2000×2000px for catalog; 4000×4000px for hero/print use.

### Lifestyle Shots

Used on homepage hero, editorial content, and social campaigns.

- Setting: tabletop setups that reflect the collector's world — a gaming desk with dice,
  a bookshelf with fantasy novels, a cosplay workspace with reference art.
- Color palette of the scene must not compete with the figurine. Use desaturated props;
  the figurine is always the most saturated element in frame.
- Human hands are allowed (and encouraged) to show scale — but faces are not the focus.
- No stock-photo aesthetics. All lifestyle imagery should feel editorial and specific
  to the Figurio collector community.

### 3D Renders (AI/CAD Preview)

Used in the custom figurine funnel to show customers their prompt result before payment.

- Render on a neutral gradient background (dark `#1A1A2E` → mid `#2D2B55`).
- Apply a subtle rim light in the primary purple (`#6C3DFF`) at 20% opacity to connect
  the render to the brand color.
- Add the Figurio icon watermark (bottom-right, 40px, 30% opacity white) on all
  pre-purchase render previews.
- Label all renders clearly as "Preview — final print may vary slightly" using UI label
  typography in `neutral-300`.

## Packaging Design

Figurio ships figurines in custom boxes. The packaging is a brand touchpoint — it should
feel like unboxing a collector's item.

### Box Exterior

- Primary color: `neutral-900` (`#1A1A2E`) matte finish.
- Logo: white variant, centered top panel.
- Accent strip: 8mm band of `primary` purple (`#6C3DFF`) along the base of the lid.
- Typography: white Plus Jakarta Sans. SKU/product name in `h4` size. Edition label
  in UI label size.

### Box Interior

- Inner tray: custom foam in neutral gray. Do not print on the interior tray.
- Insert card (85×55mm): white background, full-color logo top-left, figurine name in
  `h4`, short brand line ("Crafted with light and data.") in body small, website URL
  bottom-right in UI label.
- QR code on insert links to the product page — include UTM source `packaging`.

### Shipping Mailer

Plain kraft brown outer mailer — no branding on exterior (reduces theft risk for premium
items). Figurio branded tape (`primary` purple with white wordmark repeat) seals the top.

## Social Media Templates

All templates are produced at 2× resolution (export at 2× then scale down for delivery).

| Placement | Canvas size | Safe zone |
|-----------|-------------|-----------|
| Instagram feed (square) | 1080×1080px | 100px inset all sides |
| Instagram feed (portrait) | 1080×1350px | 100px inset sides, 150px top/bottom |
| Instagram Story / Reels cover | 1080×1920px | 250px top, 400px bottom (UI chrome safe) |
| Facebook / LinkedIn feed | 1200×628px | 80px inset all sides |
| Pinterest pin | 1000×1500px | 100px inset all sides |
| Email header | 600×200px | 40px inset all sides |

### Template Conventions

- Every template has a **logo zone** (top-left or bottom-right — pick one per campaign,
  stay consistent across a campaign's assets).
- Every template has a **CTA text zone** using Plus Jakarta Sans 700. Max 6 words.
- Product photography or 3D render always occupies at least 60% of the canvas.
- Use primary purple overlays at 80–90% opacity for text-heavy variants (announcements,
  sales). Keep overlay below 70% on product-hero variants to let the figurine breathe.
- Do not use more than 2 typefaces or 3 brand colors in a single social asset.

## Color Usage in Marketing Materials

The same color palette as the design system applies, but with additional rules for
marketing contexts where colors carry more symbolic weight:

| Color | Marketing role | Frequency |
|-------|----------------|-----------|
| Primary purple `#6C3DFF` | Hero background, CTA pill, campaign identity | High — ownable brand color |
| Secondary red `#FF6B6B` | Sale events, limited editions, urgency callouts | Sparse — loses impact if overused |
| Accent green `#00C9A7` | "New", "In stock", positive review callouts | Contextual only |
| Neutral dark `#1A1A2E` | Packaging, premium print materials | Background anchor |
| White `#FFFFFF` | Editorial layouts, minimalist product shots | High |

Campaign color rules:
- Every marketing campaign should be anchored in one dominant color from the palette.
  Mixing primary + secondary + accent in a single campaign creates visual noise.
- Seasonal campaigns (Halloween, Christmas, etc.) may introduce a single seasonal accent
  color, but it must be confirmed by the UI Designer before rollout. It does not become
  a permanent palette addition.

## Anti-patterns

- Placing the wordmark logo at small sizes instead of switching to the icon-only variant.
- Using stock photography with generic office/lifestyle settings — Figurio's community
  is specific; generic imagery signals inauthenticity.
- Centering text over detailed figurine photography without a legible overlay — always
  test text contrast against the actual image, not a flat color swatch.
- Overusing the secondary red in non-promotional contexts — it trains customers to ignore
  it, killing its urgency function.
- Creating new social templates from scratch without starting from the approved template
  canvas sizes — off-spec dimensions get cropped by platform algorithms.
