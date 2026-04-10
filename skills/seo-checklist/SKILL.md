---
name: seo-checklist
description: >
  SEO checklist for Figurio — covers product page optimization for 3D figurines,
  blog post structure, meta titles and descriptions, image alt text, internal linking,
  and keyword targeting for the 3D-printed figurine and collectibles market.
  Use this skill when creating or auditing any Figurio web content for search visibility.
metadata:
  paperclip:
    tags: [seo, content, product, blog]
---

# SEO Checklist

## Keyword Strategy

Figurio operates in a niche intersection of: **3D printing**, **collectibles/figurines**, **custom gifts**, and **pop culture merchandise**.

### Primary keyword clusters

| Cluster | Example keywords |
|---|---|
| Core product | "3D printed figurines", "custom 3D figurine", "3D figurine shop" |
| Custom/AI | "custom figurine from photo", "AI custom figurine", "personalized 3D figurine" |
| Gift | "unique gifts for him/her", "custom gift ideas", "collectible gifts" |
| Category | "pop culture figurines", "meme figurines", "collectible figurines online" |
| Local/EU | "3D printed figurines Czech Republic", "custom figurines Europe", "figurine shop EU" |

### Keyword use rules
- Include the primary keyword in the H1, URL slug, and meta title.
- Include 2–3 related keywords naturally in body copy — do not stuff.
- For product pages, the product name is typically the primary keyword (e.g., "Shrug Guy Meme Figurine").
- For blog posts, target long-tail: "how to order a custom 3D figurine", "best 3D printed gifts 2025."

---

## Product Page Checklist

### URL
- [ ] Slug is descriptive and keyword-rich: `/products/shrug-guy-meme-figurine-15cm`
- [ ] No generic IDs: avoid `/products/item-4821`
- [ ] Lowercase, hyphens only, no underscores

### Title Tag (`<title>`)
- [ ] Format: `[Product Name] | Figurio` (e.g., "Shrug Guy Meme Figurine | Figurio")
- [ ] 50–60 characters
- [ ] Includes primary keyword naturally

### Meta Description
- [ ] 140–155 characters
- [ ] Includes primary keyword and a benefit/CTA
- [ ] Example: "Order the Shrug Guy meme figurine — full-color, 15 cm, PolyJet quality. Ships from Czech Republic. Perfect desk piece or gag gift."

### H1
- [ ] Exactly one H1 per page
- [ ] Matches or closely mirrors the product name / primary keyword
- [ ] Example: "Shrug Guy Meme Figurine (15 cm)"

### Body Copy
- [ ] Minimum 150 words of unique product description (not duplicate across variants)
- [ ] Primary keyword appears in the first 100 words
- [ ] Size tier explicitly stated (8 cm / 15 cm / 25 cm)
- [ ] "3D printed" and "full-color" appear at least once each

### Images
- [ ] Filename is descriptive: `shrug-guy-meme-figurine-15cm.jpg` (not `IMG_4291.jpg`)
- [ ] Alt text describes the image specifically: `"Shrug Guy meme figurine 15cm full-color 3D print front view"`
- [ ] At least one image with alt text containing the primary keyword
- [ ] Images compressed (WebP preferred, under 200 KB per image)

### Structured Data
- [ ] `Product` schema markup present with: name, description, image, sku, offers (price, currency, availability)
- [ ] `AggregateRating` included once reviews are collected

### Internal Links
- [ ] Link to at least one related catalog product ("You might also like")
- [ ] Link to the "How It's Made" or "About Our Printing" page where relevant

---

## Blog Post Checklist

### URL
- [ ] Slug targets the long-tail keyword: `/blog/how-to-order-custom-3d-figurine`
- [ ] Under 60 characters if possible

### Title Tag
- [ ] 50–60 characters, includes target keyword
- [ ] Format: `[Post Title] | Figurio Blog`

### Meta Description
- [ ] 140–155 characters, summarizes the post value, includes keyword

### Headings
- [ ] One H1 (the post title)
- [ ] H2s break the post into scannable sections (2–5 H2s for a standard post)
- [ ] H2/H3 headings naturally incorporate secondary keywords where they fit

### Content
- [ ] Minimum 600 words for informational posts; 900+ for pillar/guide content
- [ ] Primary keyword in first paragraph
- [ ] LSI / related terms used naturally throughout (e.g., "3D model", "figurine design", "print quality")
- [ ] No keyword stuffing — target 1–2% keyword density

### Images
- [ ] At least one image per post with descriptive alt text
- [ ] Featured image alt text includes the primary keyword

### Internal Linking
- [ ] Link to at least 2 other Figurio pages (product, another blog post, or landing page)
- [ ] Anchor text is descriptive, not "click here" or "read more"
- [ ] Example: link "custom figurine" to `/products/custom-figurine` in the post body

### External Linking
- [ ] Link to 1–2 authoritative external sources if citing facts (e.g., 3D printing stats, material specs)
- [ ] External links open in a new tab and use `rel="noopener"`

---

## Image Alt Text Conventions

Alt text for Figurio images follows this pattern:

```
[subject] [product type] [size if relevant] [color/style note if relevant] [context if relevant]
```

**Examples:**
- `"Shrug Guy meme figurine 15cm full-color 3D print side view"`
- `"Custom AI-generated dragon figurine 25cm on desk"`
- `"Stratasys J55 PolyJet printing a full-color figurine"`
- `"Figurio packaging with small 8cm collectible figurine inside"`

Do not use: "image of", "photo of", "picture showing" — screen readers already announce it as an image.

---

## Technical SEO Notes

- **Canonical tags:** Every product page must have a `<link rel="canonical">` tag. For products with size variants on separate URLs, canonical should point to the primary size.
- **Pagination:** Catalog pages using pagination should use `rel="next"` / `rel="prev"` or load-more (not infinite scroll, which is harder to crawl).
- **Page speed:** Product images are the main culprit — enforce WebP and lazy loading on below-fold images.
- **hreflang:** If Figurio adds localized pages (Czech/Slovak), implement `hreflang` tags from day one.

---

## Anti-Patterns

- Do not duplicate meta descriptions across product variants (size tiers should have unique descriptions)
- Do not use the product SKU or internal ID as the URL slug
- Do not leave alt text blank on product images — Google uses it for image search, which drives purchase-intent traffic
- Do not target ultra-broad keywords ("figurines", "gifts") on individual product pages — these belong to category/home pages
- Do not write meta descriptions over 160 characters — they get truncated in SERPs
