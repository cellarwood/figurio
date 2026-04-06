---
name: accessibility
description: Accessibility checklist and standards for the Figurio web storefront
---

# Accessibility Standards

## WCAG 2.1 AA Compliance

Figurio targets WCAG 2.1 Level AA. Figurines are gifts for everyone — our website must be usable by everyone.

## Checklist

### Perceivable
- [ ] All images have meaningful `alt` text (product images describe the figurine)
- [ ] Color contrast ratio >= 4.5:1 for normal text, >= 3:1 for large text
- [ ] Information is not conveyed by color alone (e.g., status indicators have icons + text)
- [ ] Video/animation has pause controls (GSAP animations respect `prefers-reduced-motion`)

### Operable
- [ ] All interactive elements reachable via keyboard (Tab, Enter, Escape, Arrow keys)
- [ ] Focus indicators visible on all focusable elements
- [ ] No keyboard traps (modals can be closed with Escape)
- [ ] Skip-to-content link at top of page
- [ ] Touch targets >= 44x44px on mobile

### Understandable
- [ ] Form fields have visible labels (not just placeholders)
- [ ] Error messages are specific ("Email is required" not "Invalid input")
- [ ] Language attribute set on `<html>` tag
- [ ] Consistent navigation across pages

### Robust
- [ ] Semantic HTML: `<nav>`, `<main>`, `<article>`, `<button>`, proper heading hierarchy
- [ ] ARIA labels on custom components (3D viewer, custom selects)
- [ ] Forms use proper `<label for="...">` associations
- [ ] shadcn-ui components come with ARIA built-in — don't override

## 3D Model Viewer Accessibility

- Provide `alt` text describing the figurine
- Include "Rotate", "Zoom in/out" keyboard controls or instructions
- Ensure the viewer is skippable via keyboard (not a focus trap)
- Provide static image fallback for screen readers

## Testing

- Tab through every page to verify keyboard navigation
- Use Chrome DevTools Lighthouse accessibility audit
- Test with screen reader (VoiceOver or NVDA) on key flows: browse, cart, checkout
