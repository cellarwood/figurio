---
name: seo-checklist
description: SEO checklist for Figurio content — keyword targeting, on-page optimization, and technical SEO for a 3D-printed figurine e-commerce site.
---

# SEO Checklist

## Purpose

Drive organic search traffic to Figurio by systematically optimizing content, product pages, and technical SEO. This checklist covers keyword strategy, on-page optimization, and technical requirements.

## Target Keyword Clusters

### Primary Keywords (High Intent)

| Keyword                          | Monthly Volume (est.) | Difficulty | Priority |
|----------------------------------|-----------------------|------------|----------|
| custom 3D printed figurines      | 1,000-2,500           | Medium     | P1       |
| personalized figurines           | 2,000-5,000           | High       | P1       |
| 3D printed collectibles          | 500-1,000             | Low        | P1       |
| custom miniatures                | 1,000-2,500           | Medium     | P1       |

### Secondary Keywords (Category)

| Keyword                          | Intent               | Target Page             |
|----------------------------------|-----------------------|-------------------------|
| custom wedding cake toppers 3D   | Transactional        | Wedding category page   |
| custom gaming figurines          | Transactional        | Gaming category page    |
| personalized pet figurine        | Transactional        | Pet category page       |
| anime figurine custom            | Transactional        | Anime category page     |
| 3D printed gift ideas            | Informational        | Blog + gift guide       |
| how 3D printing figurines works  | Informational        | Blog post               |

### Long-Tail Keywords (Blog Content)

- "how to turn a photo into a 3D figurine"
- "best custom figurine gifts for gamers"
- "3D printed vs hand painted figurines"
- "custom 3D printed wedding cake topper ideas"
- "how long does it take to 3D print a figurine"
- "custom miniature from text description"
- "personalized figurine gift for boyfriend"

## On-Page SEO Checklist

Apply to every page (product pages, blog posts, category pages):

### Title Tag
- [ ] Contains the primary keyword for this page.
- [ ] Under 60 characters.
- [ ] Brand name at the end: "... | Figurio".
- [ ] Unique across the entire site (no duplicate titles).
- Example: "Custom 3D Printed Figurines — Design Yours | Figurio"

### Meta Description
- [ ] Contains the primary keyword naturally.
- [ ] 120-155 characters.
- [ ] Includes a CTA or benefit statement.
- [ ] Unique per page.
- Example: "Turn your imagination into a real figurine. Custom 3D printed in full color, delivered to your door. Design yours in minutes."

### Heading Structure
- [ ] Exactly one H1 per page, containing the primary keyword.
- [ ] H2s for major sections (include secondary keywords where natural).
- [ ] H3s for subsections. No skipped heading levels.

### Content
- [ ] Primary keyword appears in the first 100 words.
- [ ] Keyword density: 1-2% (natural, not forced).
- [ ] Minimum 300 words for product pages, 1,500 words for blog posts.
- [ ] Internal links to 2-3 related pages (products, blog posts, categories).
- [ ] External links to 1-2 authoritative sources (for blog posts).

### Images
- [ ] Descriptive alt text with keyword where natural (e.g., "custom 3D printed dragon figurine in full color").
- [ ] File names are descriptive: `custom-dragon-figurine-15cm.jpg` (not `IMG_4532.jpg`).
- [ ] Images compressed (WebP format preferred, <200KB per image).
- [ ] Lazy loading enabled for below-the-fold images.

### URLs
- [ ] Short, descriptive, lowercase, hyphen-separated.
- [ ] Contains the primary keyword.
- [ ] No query parameters, IDs, or unnecessary nesting.
- Good: `/products/custom-dragon-warrior-figurine`
- Bad: `/products/item?id=12345&category=gaming`

## Product Page SEO

Product pages are the highest-value pages for Figurio. Extra care required:

### Unique Descriptions
- [ ] Every product has a unique description (no copy-paste across products).
- [ ] Description tells a micro-story (see content style guide).
- [ ] Minimum 300 words of unique content per product page.

### Size Tier Structured Data
- [ ] Implement `Product` schema (schema.org) with `offers` for each size tier.
- [ ] Include: name, description, image, sku, price, currency, availability.
- [ ] Use `AggregateOffer` when multiple size tiers exist (priceRange).

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Dragon Warrior Figurine",
  "image": "https://figurio.cz/images/dragon-warrior.jpg",
  "description": "Full-color 3D printed dragon warrior figurine...",
  "sku": "FIG-GAME-001",
  "offers": {
    "@type": "AggregateOffer",
    "lowPrice": "599",
    "highPrice": "2499",
    "priceCurrency": "CZK",
    "offerCount": "4",
    "availability": "https://schema.org/InStock"
  }
}
```

### Product Page Extras
- [ ] Customer reviews section (when available) — adds UGC and freshness signals.
- [ ] Related products section — internal linking and session depth.
- [ ] FAQ section on category pages — target "People Also Ask" queries.

## Technical SEO

### Sitemap
- [ ] XML sitemap at `/sitemap.xml`.
- [ ] Includes all product pages, category pages, and blog posts.
- [ ] Excludes: admin pages, checkout, cart, account pages.
- [ ] Updated automatically when products or posts are added/removed.
- [ ] Submitted to Google Search Console.

### Robots.txt
- [ ] Located at `/robots.txt`.
- [ ] Allows: product pages, blog, category pages.
- [ ] Disallows: `/admin`, `/cart`, `/checkout`, `/account`, `/api`.
- [ ] References sitemap: `Sitemap: https://figurio.cz/sitemap.xml`.

### Page Speed
- [ ] Lighthouse Performance score 90+ on mobile.
- [ ] Largest Contentful Paint (LCP) under 2.5 seconds.
- [ ] Cumulative Layout Shift (CLS) under 0.1.
- [ ] First Input Delay (FID) under 100ms.
- [ ] 3D viewer lazy-loaded (does not block initial page render).
- [ ] Images served in WebP with responsive srcset.

### Crawlability
- [ ] No orphan pages (every page reachable from navigation or internal links).
- [ ] Canonical tags on all pages to prevent duplicate content.
- [ ] Hreflang tags when multi-language pages exist (cs, en).
- [ ] 301 redirects for any changed URLs (never break existing links).

## Blog SEO Strategy

- Publish 2-4 blog posts per month targeting long-tail keywords.
- Each post targets one primary keyword and 2-3 related keywords.
- Include FAQ schema markup for question-based content.
- Update high-performing posts quarterly (freshness signal).
- Internal link new posts to relevant product pages.
- Promote new posts via email newsletter and social media.

## SEO Monitoring

- **Google Search Console**: Monitor impressions, clicks, CTR, and position weekly.
- **Core Web Vitals**: Check monthly via PageSpeed Insights.
- **Keyword rankings**: Track primary and secondary keywords monthly.
- **Indexation**: Verify new pages are indexed within 7 days of publication.
- **Broken links**: Scan monthly, fix immediately.
