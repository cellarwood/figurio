---
name: accessibility-checklist
description: Accessibility checklist for the Figurio storefront — WCAG 2.1 AA compliance, keyboard navigation, screen reader support, and e-commerce-specific a11y patterns
---

# Accessibility Checklist

WCAG 2.1 AA compliance checklist for the Figurio storefront.

## Before Every PR

### Keyboard Navigation
- [ ] All interactive elements reachable via Tab
- [ ] Focus order matches visual order
- [ ] Focus indicators visible (never `outline: none` without replacement)
- [ ] Modal/dialog traps focus correctly
- [ ] Escape closes modals and dropdowns
- [ ] Cart and checkout fully operable with keyboard alone

### Screen Readers
- [ ] Images have meaningful alt text (figurine descriptions, not "image1.png")
- [ ] Product cards use semantic headings (h2 for product name)
- [ ] Price changes announced on size tier selection (aria-live)
- [ ] Form inputs have associated labels
- [ ] Error messages linked to inputs via aria-describedby
- [ ] Cart item count announced on add/remove

### Visual
- [ ] Color contrast ratio 4.5:1 minimum for body text
- [ ] Color contrast ratio 3:1 minimum for large text and UI controls
- [ ] Information not conveyed by color alone (e.g., order status uses icons + text)
- [ ] Text resizes to 200% without loss of content
- [ ] No content requires horizontal scrolling at 320px width

### E-Commerce Specific
- [ ] Product prices clearly associated with their products
- [ ] Size tier selection clearly indicates current selection
- [ ] Cart totals update and announce on quantity change
- [ ] Checkout form errors displayed inline and summarized at top
- [ ] Order confirmation page has clear success indication
- [ ] 3D model viewer has keyboard controls and text alternative

### Motion
- [ ] Animations respect `prefers-reduced-motion`
- [ ] GSAP animations have reduced-motion fallbacks
- [ ] No auto-playing video or animation that can't be paused

## Testing Tools

- axe DevTools browser extension
- Lighthouse accessibility audit
- VoiceOver (macOS) or NVDA (Windows) for screen reader testing
- Keyboard-only navigation testing (unplug mouse)
