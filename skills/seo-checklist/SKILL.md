---
name: seo-checklist
description: >
  SEO checklist for Figurio content — keyword targeting for '3D printed figurines',
  'custom figurines', and 'personalized gifts', meta tags, image alt text for
  product photos, internal linking strategy, and JSON-LD product schema markup
  for the Figurio e-commerce catalog.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - seo
      - content
      - engineering
---

# SEO Checklist

Apply this checklist to every page published on figurio.cz or figurio.eu —
product pages, blog posts, landing pages, and category pages.

## Primary Keyword Targets

| Intent | Primary keyword | Supporting keywords |
|---|---|---|
| Commercial | `custom figurines` | `custom 3D figurines`, `personalized figurine` |
| Commercial | `3D printed figurines` | `3D print figurine`, `resin figurines` |
| Gift intent | `personalized gifts` | `unique personalized gifts`, `custom gift ideas` |
| Niche | `scan to print figurine` | `3D scan figurine`, `photo to figurine` |
| Niche | `AI custom figurine` | `AI generated figurine`, `custom miniature` |

Target one primary keyword per page. Do not stuff multiple primary keywords onto the same URL.

## Title Tags

- Length: 50–60 characters
- Pattern: `{Primary Keyword} — {Differentiator} | Figurio`
- Examples:
  - `Custom 3D Printed Figurines — Full-Color Resin | Figurio`
  - `Personalized Gift Figurines for Collectors | Figurio`
- The primary keyword must appear in the first 40 characters
- Never duplicate title tags across pages

## Meta Descriptions

- Length: 140–155 characters
- Must include: primary keyword, one concrete benefit, a soft CTA
- Example:
  ```
  Order a full-color custom figurine from your photo. 0.1 mm detail, gift-ready
  packaging, ships in 5–7 days. Design yours at Figurio.
  ```
- Do not use the same meta description on two pages

## Heading Structure

- One `H1` per page — contains the primary keyword, matches the page intent
- `H2` headings: supporting keywords or subtopics; 2–5 per page
- `H3` and below: descriptive only, no keyword stuffing
- Product pages: H1 = figurine name (which must follow naming conventions in `content-style-guide`)

## Image Alt Text

Every product photo requires descriptive alt text. Format:

```
{color/finish} {material} {subject} figurine[, {size}][, {occasion}]
```

Examples:
- `full-color resin custom wedding figurine, 15 cm`
- `matte finish 3D printed fantasy warrior figurine, gift box`
- `scan-to-print portrait figurine of elderly man, display base`

Rules:
- Never use filename as alt text
- Never leave alt text empty on product images
- Do not start with "image of" or "photo of"
- Keep under 125 characters

## Internal Linking

Minimum links per page type:

| Page type | Minimum internal links |
|---|---|
| Blog post | 3 — at least 1 to a product category, 1 to a related blog post |
| Product page | 2 — to the parent category and one related product |
| Category page | 1 — to the most popular product in the category |

Anchor text rules:
- Use descriptive anchors: "browse custom figurines" not "click here"
- Match anchor text to the title of the destination page where possible
- Do not use the same anchor text for different destination URLs

## URL Structure

- Lowercase, hyphen-separated, no underscores
- Product pages: `/products/{category-slug}/{product-slug}`
- Blog posts: `/blog/{topic-slug}/{post-slug}`
- Category pages: `/categories/{category-slug}`
- Examples:
  - `/products/custom/ai-portrait-figurine`
  - `/blog/gift-guides/best-3d-printed-gifts-2026`

## JSON-LD Product Schema

Every product page must include a `<script type="application/ld+json">` block with the following fields populated:

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Classic Portrait Figurine",
  "description": "Full-color resin figurine printed at 0.1 mm resolution...",
  "brand": {
    "@type": "Brand",
    "name": "Figurio"
  },
  "image": ["https://figurio.cz/images/products/classic-portrait-front.jpg"],
  "sku": "FIG-CPF-001",
  "offers": {
    "@type": "Offer",
    "url": "https://figurio.cz/products/custom/classic-portrait-figurine",
    "priceCurrency": "CZK",
    "price": "1490",
    "availability": "https://schema.org/InStock",
    "shippingDetails": {
      "@type": "OfferShippingDetails",
      "deliveryTime": {
        "@type": "ShippingDeliveryTime",
        "businessDays": { "@type": "QuantitativeValue", "minValue": 5, "maxValue": 7 }
      }
    }
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "124"
  }
}
```

Required fields: `name`, `description`, `brand`, `image`, `sku`, `offers` (with `price`, `priceCurrency`, `availability`).
Optional but high-value: `aggregateRating`, `shippingDetails`.

## Blog Post SEO Checklist

Before publishing any blog post, confirm:

- [ ] Primary keyword in title (within first 60 chars)
- [ ] Primary keyword in first 100 words of body
- [ ] Primary keyword in at least one H2
- [ ] Meta description written, 140–155 chars, includes keyword
- [ ] All images have descriptive alt text
- [ ] At least 3 internal links with descriptive anchors
- [ ] URL slug matches primary keyword (hyphenated, lowercase)
- [ ] No duplicate title tag or meta description with existing posts

## Product Page SEO Checklist

Before publishing any product page, confirm:

- [ ] H1 matches the figurine name (naming convention from `content-style-guide`)
- [ ] Title tag 50–60 chars, primary keyword in first 40 chars
- [ ] Meta description 140–155 chars with benefit and CTA
- [ ] All product photos have alt text (format above)
- [ ] JSON-LD Product schema present and valid (test with Google Rich Results Tool)
- [ ] SKU populated in schema matches catalog SKU
- [ ] Price and currency correct in schema (`CZK` for .cz, `EUR` for .eu)
- [ ] At least 2 internal links (parent category + related product)

## Anti-patterns

- Do not target more than one primary keyword per page
- Do not use auto-generated meta descriptions — write them manually
- Do not add `noindex` to product pages without explicit approval
- Do not use keyword-stuffed alt text: "3D figurine custom figurine printed figurine" is a violation
