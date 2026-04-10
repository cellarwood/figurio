---
name: seo-checklist
description: >
  SEO checklist for Figurio product pages, blog posts, and landing pages. Covers
  meta tags, Open Graph tags, structured data (JSON-LD) for 3D figurine products,
  image alt text conventions, and keyword density guidelines for 'custom figurines',
  '3D figurines', and 'personalized gifts'.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - seo
      - content
      - e-commerce
---

# SEO Checklist

Use this checklist when creating or auditing any Figurio page — product listings, blog
posts, landing pages, or the Prompt to Print flow.

---

## Core Keywords

Always target these terms. Weave them naturally — never stuff.

| Type | Keywords |
|---|---|
| Primary | `custom figurines`, `3D figurines`, `personalized figurines`, `custom 3D printed figurine` |
| Secondary | `personalized gifts`, `unique gifts`, `figurine collector`, `Prompt to Print`, `3D printing gifts` |
| Long-tail | `custom figurine from photo`, `AI custom figurine`, `3D printed gift ideas`, `display figurines` |

**Keyword density:** 1-2% for primary terms per page. Check: primary keyword should appear
in title, first 100 words of body, at least one H2, and meta description.

---

## Meta Tags Checklist

### Title Tag

- [ ] 50-65 characters (including spaces)
- [ ] Primary keyword near the front
- [ ] Brand name at the end: `| Figurio`
- [ ] Unique per page — no duplicates across the site

**Product page formula:** `[Product Name] — [Size] Custom 3D Figurine | Figurio`
Example: `Dragon Knight — 15cm Custom 3D Figurine | Figurio`

**Blog post formula:** `[Post Title — under 55 chars] | Figurio`
Example: `Best Personalized Gifts for Collectors | Figurio`

**Landing page formula:** `Custom Figurines — [Value Prop] | Figurio`
Example: `Custom Figurines — Bring Your Idea to Life | Figurio`

### Meta Description

- [ ] 150-160 characters
- [ ] Includes primary keyword once
- [ ] Includes a soft CTA ("Shop now", "Order yours", "Start your prompt")
- [ ] Unique per page

**Product page example:**
> Shop our 15cm Dragon Knight — a full-color 3D figurine with display-grade detail.
> Custom sizes available. Order yours today at Figurio.

**Blog post example:**
> Looking for unique personalized gifts? Explore our top 3D figurine picks for collectors,
> gamers, and gift-givers. Find yours at Figurio.

---

## Open Graph Tags

Required on every public page. Set in the page `<head>`.

```html
<meta property="og:title" content="[Same as title tag, minus brand suffix]" />
<meta property="og:description" content="[Meta description text]" />
<meta property="og:type" content="product" />  <!-- or "article" for blog posts -->
<meta property="og:url" content="https://figurio.com/products/[slug]" />
<meta property="og:image" content="https://figurio.com/images/[product-slug]-og.jpg" />
<meta property="og:image:width" content="1200" />
<meta property="og:image:height" content="630" />
<meta property="og:site_name" content="Figurio" />
<meta property="og:locale" content="en_US" />
```

- [ ] `og:image` is 1200x630px, shows the product clearly on a clean background
- [ ] `og:type` is `product` for product pages, `article` for blog posts
- [ ] Twitter Card tags also present (`twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`)

---

## Structured Data (JSON-LD)

### Product Pages

Include on every figurine product listing. Place in a `<script type="application/ld+json">` tag.

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Dragon Knight Figurine — 15cm",
  "description": "Full-color 3D-printed dragon knight figurine at display grade. 15cm size, artisan quality.",
  "image": "https://figurio.com/images/dragon-knight-15cm.jpg",
  "brand": {
    "@type": "Brand",
    "name": "Figurio"
  },
  "sku": "FIG-DRK-15",
  "offers": {
    "@type": "Offer",
    "url": "https://figurio.com/products/dragon-knight-15cm",
    "priceCurrency": "EUR",
    "price": "49.00",
    "availability": "https://schema.org/InStock",
    "seller": {
      "@type": "Organization",
      "name": "Figurio"
    }
  }
}
```

- [ ] `@type` is `Product`
- [ ] `name` includes size tier (8cm / 15cm / 25cm)
- [ ] `sku` follows Figurio SKU format: `FIG-[CODE]-[SIZE]`
- [ ] `priceCurrency` is `EUR` (primary market)
- [ ] `availability` reflects actual stock status

### Blog Posts

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Best Personalized Gifts for Figurine Collectors",
  "author": {
    "@type": "Organization",
    "name": "Figurio"
  },
  "publisher": {
    "@type": "Organization",
    "name": "Figurio",
    "logo": {
      "@type": "ImageObject",
      "url": "https://figurio.com/images/logo.png"
    }
  },
  "datePublished": "2026-04-10",
  "dateModified": "2026-04-10",
  "image": "https://figurio.com/images/blog/[post-slug]-hero.jpg"
}
```

- [ ] `@type` is `Article`
- [ ] `datePublished` and `dateModified` are accurate ISO 8601 dates
- [ ] `headline` matches the page H1 exactly

---

## Image Alt Text

All figurine images must have descriptive alt text. Never use file names as alt text.

### Formula

`[Color/style descriptor] [product name] [size] 3D figurine [context if useful]`

**Examples:**

| Context | Alt Text |
|---|---|
| Product hero | `Full-color dragon knight 15cm 3D figurine on white background` |
| Lifestyle shot | `Custom 3D printed figurine on wooden desk next to books` |
| Size comparison | `Figurio figurine size comparison: 8cm, 15cm, and 25cm side by side` |
| Prompt to Print | `AI-generated custom figurine from Figurio Prompt to Print feature` |

- [ ] Every `<img>` has a non-empty `alt` attribute
- [ ] Alt text is under 125 characters
- [ ] Primary keyword (`3D figurine` or `custom figurine`) appears in alt text for main product images
- [ ] Decorative images use `alt=""`

---

## URL Structure

- [ ] All lowercase, hyphen-separated: `/products/dragon-knight-15cm`
- [ ] No underscores, no special characters, no query strings in canonical URLs
- [ ] Size tier in slug for product pages: `-8cm`, `-15cm`, `-25cm`
- [ ] Blog slugs: `/blog/[keyword-rich-slug]` — include primary keyword where natural

---

## Page-Level Checklist Summary

Run through this for every page before publishing:

- [ ] Title tag: 50-65 chars, keyword first, `| Figurio` suffix
- [ ] Meta description: 150-160 chars, includes keyword + CTA
- [ ] Open Graph tags complete and image is 1200x630
- [ ] JSON-LD structured data present and valid (use Google Rich Results Test)
- [ ] H1 contains primary keyword; appears exactly once on the page
- [ ] Primary keyword in first 100 words of body copy
- [ ] At least one H2 includes a secondary keyword
- [ ] All images have descriptive alt text following the formula above
- [ ] URL is clean, lowercase, hyphenated
- [ ] Internal link to at least one related product or blog post
- [ ] Canonical tag set to the page's own URL
- [ ] Page loads under 3 seconds (flag to engineering if not)
