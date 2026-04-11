---
name: seo-checklist
description: >
  On-page SEO checklist for Figurio content — covering target keywords (custom figurines,
  3D printed collectibles, personalized gifts), meta title and description rules,
  figurine image alt text conventions, internal linking strategy between catalog and
  custom configurator pages, and structured data for product pages.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - content
      - seo
      - engineering
---

# Figurio On-Page SEO Checklist

## Target Keywords

### Primary keywords (high commercial intent)
| Keyword | Notes |
|---|---|
| custom figurines | Broadest, highest volume — use in H1 and meta title |
| 3D printed figurines | Technology-specific — use on product and about pages |
| personalized 3D figurine | Long-tail, strong gift intent |
| custom 3D printed gift | Use on gift-context landing pages |
| 3D printed collectibles | Blog and catalog category pages |
| personalized gift Czech Republic | Local intent — use on homepage and shipping pages |

### Secondary / supporting keywords
- PolyJet figurine
- full color 3D printing
- Stratasys J55 figurine
- miniature portrait figurine
- custom wedding cake topper figurine

### Avoid
Do not target generic "3D printing" or "figurine" alone — too broad, no commercial intent for Figurio's niche.

---

## Meta Tags

### Meta Title
- Format: `[Primary Keyword] | Figurio`
- Length: 50–60 characters (Google truncates at ~60)
- Include the primary keyword as close to the front as possible
- Examples:
  - `Custom 3D Printed Figurines | Figurio`
  - `Personalized Figurine Gift | Figurio`
  - `3D Printed Collectibles — Dragons & Fantasy | Figurio`

### Meta Description
- Length: 140–160 characters
- Must include one primary or secondary keyword naturally
- Include a value proposition and a soft CTA
- Example:
  > Order a custom full-color 3D printed figurine from Figurio. Upload your photo,
  > our AI sculpts your likeness — shipped across the EU. From CZK 1 490.

### Canonical Tag
- Every product page and category page must have a self-referencing `<link rel="canonical">` set
- Ensure the React/TS frontend renders canonical tags server-side (or via SSR/SSG) — not just client-side

---

## Heading Structure

- **H1**: One per page, contains the primary keyword, matches the user's search intent
- **H2**: Section titles — can include secondary keywords
- **H3**: Sub-sections — plain language, no keyword stuffing
- Never skip levels (e.g., H1 → H3 skipping H2)

### Product page H1 examples
- `Custom 3D Printed Figurine — Upload Your Photo`
- `Dragon Knight Collectible Figurine — 18 cm PolyJet`

---

## Image Alt Text

Figurio products are visually detailed — alt text must be descriptive and keyword-aware.

### Rules
- Describe the subject, color, and relevant keyword in 8–15 words
- Always include material or size context where space allows
- Never use "image of" or "photo of" as a prefix — screen readers add that automatically
- File names: use kebab-case descriptive names (`dragon-knight-figurine-18cm.jpg`), not `IMG_4023.jpg`

### Examples
| Bad | Good |
|---|---|
| `figurine` | `full-color 3D printed dragon knight figurine standing 18cm tall` |
| `custom` | `custom PolyJet figurine of a woman in red dress, 15cm` |
| `product image` | `personalized 3D printed wedding cake topper figurine, couple` |

---

## Internal Linking Strategy

### Key pages to link to
1. **Custom configurator** (`/configure`) — link from: homepage hero, blog posts about custom figurines, product category pages, email CTAs
2. **Catalog category pages** — link from: homepage, blog posts about collectibles, related product pages
3. **How It Works** page — link from: product descriptions, FAQ, blog posts about PolyJet
4. **Blog** — link from: homepage footer, product pages (contextual "learn more" links)

### Rules
- Anchor text must be descriptive: "order a custom 3D figurine" not "click here"
- Every blog post must link to at least one product page or the configurator
- Product pages should cross-link to 2–3 related catalog items ("You may also like")
- Do not orphan pages — every page must be reachable within 3 clicks from the homepage

---

## Structured Data (JSON-LD)

### Product pages

Use `Product` schema on every figurine product page. Required fields:

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Dragon Knight Collectible Figurine",
  "image": "https://figurio.cz/images/dragon-knight-figurine-18cm.jpg",
  "description": "Full-color 3D printed dragon knight figurine, 18 cm, produced on Stratasys J55 PolyJet.",
  "brand": { "@type": "Brand", "name": "Figurio" },
  "offers": {
    "@type": "Offer",
    "priceCurrency": "CZK",
    "price": "1490",
    "availability": "https://schema.org/InStock",
    "url": "https://figurio.cz/products/dragon-knight"
  }
}
```

Include `aggregateRating` once review data is available — do not add placeholder ratings.

### Breadcrumb schema

Add `BreadcrumbList` on all product and category pages to improve SERP appearance:

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://figurio.cz/" },
    { "@type": "ListItem", "position": 2, "name": "Collectibles", "item": "https://figurio.cz/collectibles/" },
    { "@type": "ListItem", "position": 3, "name": "Dragon Knight" }
  ]
}
```

---

## Page-Level Checklist

Run this before publishing any product page, category page, or blog post:

- [ ] Meta title: 50–60 characters, includes primary keyword, ends with `| Figurio`
- [ ] Meta description: 140–160 characters, includes keyword and CTA
- [ ] Canonical tag present and correct
- [ ] H1 contains primary keyword, appears once
- [ ] All images have descriptive alt text (8–15 words)
- [ ] Image file names are kebab-case and descriptive
- [ ] At least one internal link to the custom configurator or a product page
- [ ] Product pages have `Product` JSON-LD structured data
- [ ] No keyword stuffing — primary keyword appears naturally 1–2 times per 300 words
- [ ] URL slug is short, lowercase, hyphenated, and includes the primary keyword (e.g., `/products/dragon-knight-figurine`)
