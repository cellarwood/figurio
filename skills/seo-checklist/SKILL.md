---
name: seo-checklist
description: >
  SEO checklist for Figurio pages — product pages, blog posts, and landing pages
  on the React/TypeScript frontend. Covers keyword targeting, meta tags, structured
  data for 3D-printed products, image optimization, and internal linking conventions.
metadata:
  paperclip:
    tags:
      - seo
      - content
      - marketing
---

# SEO Checklist

Apply this checklist as a **pre-flight before drafting** and a **post-flight before publishing.** SEO structure is architecture — it is decided before writing, not bolted on afterward.

---

## 1. Keyword Targeting (Pre-Draft)

Before writing any page:

- [ ] Identify one **primary keyword** — the exact phrase the page targets (e.g., "custom 3D printed figurine," "DnD miniature gift").
- [ ] Identify 2-4 **secondary keywords** — related terms and long-tails to weave into subheadings and body.
- [ ] Check the SEO keyword tracker in Sheets (`Content Ops > SEO Keyword Map`) — confirm this keyword is not already targeted by an existing page.
- [ ] Map the keyword to search intent: informational (blog), commercial (product), or navigational (landing page).

Figurio's core keyword clusters:
| Cluster | Primary terms |
|---|---|
| Custom figurines | "custom 3D printed figurine," "personalized figurine," "Prompt to Print figurine" |
| Tabletop gaming | "DnD miniature," "custom tabletop miniature," "3D printed miniature" |
| Gift occasions | "unique gift for him/her," "3D printed gift," "custom figurine gift" |
| Technology | "PolyJet 3D printing," "full color 3D print," "Stratasys J55" |

---

## 2. Meta Tags

Every published page must have:

- [ ] **Title tag** — 50-60 characters. Primary keyword near the front. Format: `{Keyword} | Figurio` or `{Page Title} — {Keyword} | Figurio`.
- [ ] **Meta description** — 140-160 characters. Include primary keyword. One concrete sentence describing the page value + implicit CTA.
- [ ] **Canonical URL** — set to the authoritative URL for the page. Required on product variants and paginated pages.
- [ ] **Open Graph tags** — `og:title`, `og:description`, `og:image` (1200x630px), `og:url`. Required for all social-shared pages.

Examples for a product page:
```
Title: Custom Dog Figurine — Full Color 3D Printed | Figurio
Meta: Order a full-color 3D-printed figurine of your dog at 1:6 scale. Printed by MCAE on a Stratasys J55. Ships from Czech Republic.
```

---

## 3. Structured Data (Schema.org)

### Product Pages

Every catalog product page must include `Product` schema:

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "[Product name]",
  "description": "[Product description]",
  "image": "[Primary image URL]",
  "brand": { "@type": "Brand", "name": "Figurio" },
  "offers": {
    "@type": "Offer",
    "priceCurrency": "CZK",
    "price": "[price]",
    "availability": "https://schema.org/InStock",
    "seller": { "@type": "Organization", "name": "Figurio" }
  }
}
```

### Blog Posts

Every blog post must include `Article` schema:

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "[H1 text]",
  "author": { "@type": "Organization", "name": "Figurio" },
  "datePublished": "[ISO date]",
  "image": "[Featured image URL]"
}
```

### FAQ Sections

If a page includes a FAQ block, add `FAQPage` schema for each Q&A pair. This is high-value for Prompt to Print and "How It Works" pages.

---

## 4. On-Page Structure

- [ ] **H1** — one per page, contains primary keyword, matches or closely reflects the title tag.
- [ ] **H2/H3 subheadings** — include secondary keywords naturally; no keyword stuffing.
- [ ] **Primary keyword** appears in the first 100 words of body copy.
- [ ] **URL slug** — lowercase, hyphen-separated, keyword-first. No stopwords. Example: `/blog/custom-dnd-miniatures-guide` not `/blog/post-1234`.
- [ ] **Word count** — product pages: 150-300 words minimum. Blog posts: 600+ words. Landing pages: 300+ words.

---

## 5. Image Optimization

Every image published on Figurio must have:

- [ ] **Descriptive filename** — `custom-dog-figurine-1-6-scale.jpg` not `IMG_4521.jpg`.
- [ ] **Alt text** — describes the image for accessibility and includes primary or secondary keyword where natural. Max 125 characters.
- [ ] **Format** — WebP preferred for all product and blog images. AVIF for hero images if supported by the frontend build.
- [ ] **Size** — product images max 300 KB, blog featured images max 200 KB, thumbnails max 80 KB.
- [ ] **Dimensions** — product hero: 1000x1000px (square). Blog featured: 1200x630px. Social share: 1200x630px.

---

## 6. Internal Linking

Every published page must link to at least two other Figurio pages:

- [ ] One link to a **related product page** or the Prompt to Print landing page.
- [ ] One link to a **related blog post** or category page.
- [ ] Anchor text is descriptive — never "click here" or "read more." Use the target keyword or topic as the anchor.

Standard internal link targets to include where relevant:
| Link target | When to include |
|---|---|
| `/prompt-to-print` | Any page about custom figurines or gifts |
| `/catalog` | Product comparisons, gift guides |
| `/how-it-works` | Blog posts about the printing process |
| `/blog` | Product pages, landing pages |

Cross-link new blog posts to 1-2 existing blog posts from the same keyword cluster.

---

## 7. Pre-Publish Final Check

Before marking any content ready-to-publish:

- [ ] Title tag set and within character limit
- [ ] Meta description set and within character limit
- [ ] H1 contains primary keyword
- [ ] Primary keyword in first 100 words
- [ ] All images have alt text and correct filenames
- [ ] At least 2 internal links with descriptive anchors
- [ ] Canonical URL set
- [ ] Structured data added (product or article schema)
- [ ] URL slug is keyword-first and clean
- [ ] No duplicate targeting — keyword not already owned by another page
