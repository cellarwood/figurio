---
name: seo-checklist
description: >
  SEO optimization checklist for Figurio content — keyword research for figurines,
  3D printing, custom collectibles, and personalized gifts. Covers on-page optimization,
  meta descriptions, structured data for e-commerce products, and internal linking
  strategy across the Figurio shop and blog.
allowed-tools:
  - Read
  - Write
  - Grep
metadata:
  paperclip:
    tags:
      - seo
      - content
      - marketing
---

# SEO Checklist

Figurio competes in a niche intersection: 3D-printed collectibles, personalized gifts, and custom figurines. SEO targets both product-intent queries ("buy custom figurine") and discovery queries ("3D printed gift ideas"). Apply this checklist to every product page, blog post, and landing page before publishing.

## 1. Keyword Research

### Primary Keyword Categories

| Category | Example Keywords | Content Type |
|---|---|---|
| Product — catalog | "3D printed figurine", "collectible figurines", "resin figurine Czech" | Product pages, collection pages |
| Product — custom | "custom 3D figurine", "personalized figurine gift", "AI custom figurine" | Custom product page, landing pages |
| Gifting intent | "unique gift for him/her", "personalized gift ideas", "custom figurine gift" | Blog posts, gift guide landing pages |
| Discovery / informational | "how are 3D figurines made", "best 3D printed collectibles", "3D printing resin vs FDM" | Blog posts |
| Local / brand | "Figurio", "3D figurine shop Czech Republic", "Prague 3D print figurine" | Homepage, about page |

### Keyword Selection Rules

- Target one primary keyword per page; 2–4 supporting/related keywords
- Avoid targeting the same primary keyword on multiple pages (cannibalization)
- Prefer long-tail keywords for blog content (lower competition, higher intent)
- Do not target keywords that require referencing copyrighted IP (e.g., "Zelda figurine" — IP risk)
- Use search volume + difficulty tools; aim for keywords under difficulty 40 for new content

## 2. On-Page Optimization

### Title Tag

- Include the primary keyword; keep under 60 characters
- Lead with keyword when natural: "Custom 3D Figurine — Personalized Gift | Figurio"
- Do not stuff keywords; one primary mention is enough
- Every page has a unique title tag — no duplicates

### Meta Description

- 140–160 characters
- Include the primary keyword naturally
- Write a genuine benefit statement — this is a click driver, not a keyword container
- Include a soft CTA ("Shop now", "See the full collection", "Order yours")

Example:
> "Turn your imagination into a one-of-a-kind 3D-printed figurine. Designed from your prompt, shipped from Prague. Order your custom figurine today."

### H1

- One H1 per page, matches or closely reflects the title tag keyword
- Never repeat the H1 as an H2

### Body Content

- Primary keyword in the first 100 words
- Supporting keywords appear naturally across the content — do not force density
- Use H2/H3 subheadings with related terms (they capture supporting queries)
- Product descriptions: minimum 60 words; blog posts: minimum 600 words
- Images: always include descriptive `alt` text with keywords where natural ("hand-painted resin figurine on desk")

### URL Structure

- Lowercase, hyphen-separated, no special characters
- Product pages: `/products/[product-name]` — keep slugs short and keyword-relevant
- Blog posts: `/blog/[topic-slug]` — include primary keyword in slug
- Collection pages: `/collections/[category]` (e.g., `/collections/custom-figurines`)
- Never use dates in URLs for evergreen content

## 3. E-Commerce Structured Data

Add `Product` schema markup to every catalog and custom figurine product page.

Required fields:

```json
{
  "@type": "Product",
  "name": "[Product name]",
  "description": "[Product description]",
  "image": "[Primary product image URL]",
  "brand": { "@type": "Brand", "name": "Figurio" },
  "offers": {
    "@type": "Offer",
    "priceCurrency": "EUR",
    "price": "[price]",
    "availability": "https://schema.org/InStock",
    "url": "[product URL]"
  }
}
```

Add `AggregateRating` once reviews are collected (minimum 5 reviews before enabling).

For blog posts, use `Article` schema with `datePublished`, `dateModified`, `author`, and `publisher`.

Validate all structured data with Google's Rich Results Test before publishing.

## 4. Internal Linking Strategy

### Principles

- Every blog post links to at least one relevant product page or collection
- Every product page links to at least one related blog post or collection page
- Use descriptive anchor text — never "click here" or "read more"
- Link to the deepest relevant page (product page, not just homepage)

### Priority Link Targets

Pages that should receive the most internal links:

1. `/products/custom-ai-figurine` — custom figurine product (highest margin, key growth driver)
2. `/collections/custom-figurines` — collection page for custom products
3. `/collections/catalog-figurines` — main catalog collection
4. Top seasonal landing pages (link from blog posts during relevant season)

### Blog-to-Product Linking Pattern

In blog posts, link to products naturally within the content body — not only in a trailing "Shop the look" section. Example: "...which is why our [custom AI figurine](/products/custom-ai-figurine) uses your prompt as the design input..."

## 5. Content Freshness

- Update seasonal blog posts (gifting guides, Halloween, Christmas) each year — refresh examples, update dates, check internal links
- Add `dateModified` to schema when making meaningful content updates
- Audit product page copy every 6 months; stale descriptions hurt CTR from search results

## 6. Pre-Publish Checklist

Work through this before publishing any page:

- [ ] Primary keyword identified; not already used as primary on another page
- [ ] Title tag under 60 characters, includes primary keyword
- [ ] Meta description 140–160 characters, includes keyword and CTA
- [ ] One H1 matching the keyword intent
- [ ] Primary keyword in first 100 words of body
- [ ] URL slug is short, lowercase, hyphen-separated, keyword-relevant
- [ ] All images have descriptive alt text
- [ ] At least one internal link to a product page or collection
- [ ] At least one internal link from an existing page to this new page
- [ ] Structured data added and validated (product pages and blog posts)
- [ ] No copyrighted character references in keywords, copy, or alt text

## Anti-patterns

- Writing meta descriptions over 160 characters (Google rewrites them, often poorly)
- Using the same primary keyword as the target on two different pages
- Publishing blog posts under 600 words — too thin to rank and provides poor UX
- Keyword stuffing in alt text ("figurine figurine 3D printed resin figurine")
- Targeting branded competitor keywords (legal risk, low conversion)
- Leaving URL slugs as auto-generated IDs (`/products/product-38472`)
- Adding structured data that does not match the visible page content
