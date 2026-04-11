---
name: seo-checklist
description: >
  SEO optimization for Figurio — product page meta tags, figurine category landing pages,
  and blog content targeting primary keywords: '3D printed figurines', 'custom figurines',
  'personalized miniatures'. Covers on-page rules, structured data, and internal linking
  patterns for a D2C e-commerce platform.
allowed-tools:
  - Read
  - Grep
metadata:
  paperclip:
    tags:
      - seo
      - content
      - marketing
---

# SEO Checklist

Figurio's SEO strategy targets buyers searching for custom, personalized, and collectible
3D-printed figurines. The site is a React/TypeScript frontend backed by FastAPI — all
meta/structured-data must be rendered server-side or via SSR/SSG to be crawlable.

---

## Primary Keywords

| Keyword | Intent | Primary Use |
|---------|--------|-------------|
| 3D printed figurines | Informational + commercial | Blog, category pages, homepage |
| custom figurines | Commercial | Product pages, "Prompt to Print" landing |
| personalized miniatures | Commercial | Product pages, gift-oriented content |
| custom 3D figurine | High-commercial | "Prompt to Print" product + meta |
| full color 3D print figurine | Informational | Blog, technology explainer pages |
| figurine gift | Commercial | Gift-guide blog posts, seasonal pages |

Long-tail variants to incorporate naturally: "3D printed miniature gift", "custom figurine from
photo", "personalized 3D figurine Czech", "PolyJet figurine print".

---

## Product Page Checklist

Every catalog and custom figurine product page must pass all of the following.

### Meta Tags

- [ ] `<title>` — format: `{Figurine Name} — Full-Color 3D Printed Figurine | Figurio`
  - Example: `Cyber Samurai — Full-Color 3D Printed Figurine | Figurio`
  - Max 60 characters. Never truncate the figurine name.
- [ ] `<meta name="description">` — 140–155 characters. Include the primary keyword, size tier,
  and a differentiating detail (color, material, PolyJet). End with a soft CTA.
  - Example: `Shop the Cyber Samurai full-color 3D printed figurine. Available in 8cm, 15cm,
    and 25cm. PolyJet multi-material print with vivid color accuracy. Order online.`
- [ ] `<link rel="canonical">` — always set, especially for size/variant URL params.
- [ ] Open Graph tags: `og:title`, `og:description`, `og:image` (product render, min 1200×630px),
  `og:type: product`.

### Structured Data (JSON-LD)

Include `Product` schema on every product page:

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "{Figurine Name}",
  "description": "{Product description}",
  "brand": { "@type": "Brand", "name": "Figurio" },
  "offers": {
    "@type": "Offer",
    "priceCurrency": "CZK",
    "price": "{price}",
    "availability": "https://schema.org/InStock",
    "url": "{canonical URL}"
  },
  "image": "{product image URL}"
}
```

### Body Content

- [ ] H1 contains the figurine name — no keyword stuffing, just natural naming.
- [ ] Product description (visible on page) includes at least one primary keyword naturally.
- [ ] Alt text on all product images: `{Figurine Name} full-color 3D printed figurine, {size}cm`.
- [ ] Size selector labels include cm measurements (not just "Small / Medium / Large").

---

## Category / Landing Page Checklist

Category pages: `/catalog`, `/catalog/seasonal`, `/catalog/custom`, etc.

- [ ] `<title>` — format: `{Category} 3D Printed Figurines | Figurio`
  - Example: `Custom 3D Printed Figurines | Figurio`
- [ ] `<meta name="description">` — include category keyword + Figurio differentiator
  (PolyJet, full-color, Czech production, AI-generated custom option).
- [ ] H1 on the page — must include the target keyword for that category.
- [ ] Above-the-fold intro paragraph (2–4 sentences) — write for humans but include
  the primary category keyword in the first sentence.
- [ ] Internal links: each category page should link to at least 2 relevant blog posts
  and 2 featured product pages.
- [ ] `BreadcrumbList` JSON-LD on all category pages.

### "Prompt to Print" Landing Page

Target keyword: **custom figurines** / **custom 3D figurine**

- [ ] H1: "Design Your Custom 3D Figurine" (or equivalent — must include "custom" and "figurine").
- [ ] Page copy explains the AI generation + review + approval flow — this unique process is
  a long-tail keyword magnet ("AI generated 3D figurine", "custom figurine from text prompt").
- [ ] FAQ section on the page targeting question-intent queries:
  - "How do I order a custom figurine?"
  - "How long does a custom 3D figurine take?"
  - "Can I preview my figurine before it prints?"
- [ ] `FAQPage` JSON-LD for the FAQ section.

---

## Blog Content Checklist

Blog posts target informational queries that feed the top of the funnel.

### Before Writing

- [ ] Identify the primary keyword for the post (one, not five).
- [ ] Check that no existing post already targets the same keyword (avoid cannibalization).
- [ ] Confirm search intent: informational ("how does PolyJet work") vs. commercial
  ("best custom figurine shops") — write to match.

### On-Page

- [ ] `<title>` — primary keyword near the front. Max 60 characters.
  - Example: `3D Printed Figurines: How Full-Color PolyJet Works | Figurio Blog`
- [ ] `<meta name="description">` — 140–155 characters, include keyword + hook.
- [ ] H1 matches or closely echoes the title tag keyword.
- [ ] Primary keyword appears in the first 100 words of the post body.
- [ ] Subheadings (H2/H3) use keyword variations naturally — not forced repetition.
- [ ] At least 2 internal links: one to a relevant product/category page, one to a related post.
- [ ] Images: descriptive file names (`full-color-3d-printed-figurine-polyjet.jpg`),
  alt text with keyword where natural.

### Post Length Guidelines

| Post type | Target word count |
|-----------|------------------|
| Deep-dive / explainer | 800–1,400 words |
| Collector guide / gift guide | 600–1,000 words |
| Behind-the-scenes / story | 400–700 words |
| Seasonal / trend | 300–600 words |

---

## Internal Linking Rules

- Product pages link to their parent category page (breadcrumb + body link).
- Blog posts about a figurine type always link to the relevant catalog category.
- "Prompt to Print" is linked from every blog post that mentions custom or personalized figurines.
- Anchor text should be descriptive: use "custom 3D figurines" not "click here" or "learn more."

---

## What Not to Do

- Do not duplicate `<title>` or `<meta description>` across pages — each must be unique.
- Do not target "3D printing" as a standalone keyword — too broad, too competitive, wrong intent.
- Do not keyword-stuff product descriptions — Google reads them; so do customers.
- Do not use auto-generated meta descriptions from the CMS default — always write manually.
- Do not create thin category pages (fewer than 150 words of visible body copy above the grid).
