---
name: accessibility
description: >
  WCAG 2.1 AA accessibility checklist for the Figurio storefront —
  keyboard navigation, screen reader support, color contrast, and
  accessible 3D viewer and checkout flows.
---

# Accessibility

## Target Standard

WCAG 2.1 Level AA compliance for all customer-facing pages.

## Checklist

### Keyboard Navigation
- [ ] All interactive elements reachable via Tab
- [ ] Focus indicators visible on all focusable elements
- [ ] Cart and checkout flow completable without a mouse
- [ ] 3D viewer controls accessible via keyboard (arrow keys for rotation)
- [ ] Modal dialogs trap focus correctly
- [ ] Skip-to-content link on every page

### Screen Readers
- [ ] All images have meaningful alt text (figurine descriptions, not "image123.jpg")
- [ ] Form fields have associated labels
- [ ] Error messages announced via aria-live regions
- [ ] Product price and availability announced clearly
- [ ] Cart count updates announced
- [ ] Page title changes on route navigation

### Visual
- [ ] Color contrast ratio >= 4.5:1 for body text, >= 3:1 for large text
- [ ] Information not conveyed by color alone (error states use icons + text)
- [ ] Text resizable to 200% without loss of functionality
- [ ] No content that flashes more than 3 times per second

### 3D Viewer Specific
- [ ] Provide alt text describing the figurine for screen readers
- [ ] Fallback image gallery for users who can't use WebGL
- [ ] Rotation/zoom controls have aria labels
- [ ] Loading state communicated via aria-busy

### Checkout
- [ ] Address form fields have autocomplete attributes
- [ ] Stripe Elements configured with accessibility options
- [ ] Order summary readable by screen readers before payment
- [ ] Success/error states clearly communicated
