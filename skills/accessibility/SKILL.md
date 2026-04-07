---
name: Accessibility
description: Accessibility checklist and WCAG compliance guidelines for Figurio's storefront
---

# Accessibility

## WCAG 2.1 AA Compliance Checklist

### Perceivable
- [ ] All images have descriptive `alt` text (figurine name + brief description)
- [ ] Color contrast ratio ≥ 4.5:1 for normal text, ≥ 3:1 for large text
- [ ] Information is not conveyed by color alone (e.g., order status uses text + color)
- [ ] 3D viewer has a text alternative describing the figurine
- [ ] Video/animation has pause controls

### Operable
- [ ] All interactive elements are keyboard-accessible (Tab, Enter, Space, Escape)
- [ ] Focus order follows visual layout (top-to-bottom, left-to-right)
- [ ] Focus indicators are visible (use Tailwind `focus-visible:ring-2`)
- [ ] No keyboard traps (modal dialogs have proper focus management)
- [ ] Skip-to-content link on every page

### Understandable
- [ ] Form fields have visible labels (not just placeholders)
- [ ] Error messages are specific ("Email is required" not "Invalid input")
- [ ] Language attribute set on `<html lang="en">`
- [ ] Consistent navigation across all pages

### Robust
- [ ] Valid HTML (no duplicate IDs, proper nesting)
- [ ] ARIA attributes used correctly (prefer semantic HTML over ARIA)
- [ ] Works with screen readers (test with VoiceOver or NVDA)

## Figurio-Specific Considerations

### 3D Viewer
- Provide a "View as images" fallback for users who can't interact with 3D
- Announce loading state to screen readers: `aria-live="polite"`
- Keyboard controls: arrow keys for rotation, +/- for zoom

### Checkout Flow
- Stripe Elements handles its own accessibility — don't override
- Order summary must be readable by screen readers before payment
- Success/error states announced via `aria-live` regions

### Product Catalog
- Figurine cards: meaningful alt text, not "product image"
- Filter controls: proper `<fieldset>` and `<legend>` grouping
- Search: `role="search"`, `aria-label="Search figurines"`
