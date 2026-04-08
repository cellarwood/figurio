---
name: accessibility
description: EU accessibility compliance checklist for the Figurio storefront — WCAG 2.1 AA requirements, keyboard navigation, screen reader support, and 3D viewer accessibility.
---

# Accessibility Standards

## Purpose

Ensure the Figurio storefront meets WCAG 2.1 AA compliance requirements and the EU Web Accessibility Directive (Directive 2016/2102). Accessibility is not optional — it is a legal requirement for EU e-commerce and the right thing to do.

## WCAG 2.1 AA Checklist

### Perceivable

#### 1.1 Text Alternatives
- [ ] All product images have descriptive alt text (e.g., "Dragon warrior figurine, 15cm, full color PolyJet print").
- [ ] Decorative images use `alt=""` (empty alt, not missing alt).
- [ ] 3D viewer has a text description of the model visible to screen readers.
- [ ] Icons used as buttons have accessible labels (`aria-label` or visually hidden text).

#### 1.3 Adaptable
- [ ] Use semantic HTML: `<main>`, `<nav>`, `<header>`, `<footer>`, `<article>`, `<section>`.
- [ ] Heading hierarchy is logical (h1 > h2 > h3, no skipped levels).
- [ ] Form inputs have associated `<label>` elements (not just placeholder text).
- [ ] Tables (if used) have `<th>` with `scope` attributes.

#### 1.4 Distinguishable
- [ ] Text color contrast ratio is at least 4.5:1 against background (normal text).
- [ ] Large text (18px+ bold or 24px+ regular) has at least 3:1 contrast.
- [ ] Interactive elements have visible focus indicators (not removed via `outline: none`).
- [ ] Content is readable and functional at 200% zoom.
- [ ] No information conveyed by color alone (e.g., size tier availability).
- [ ] Text spacing can be adjusted without loss of content.

### Operable

#### 2.1 Keyboard Accessible
- [ ] All interactive elements are reachable via Tab key.
- [ ] Tab order follows visual reading order (left-to-right, top-to-bottom).
- [ ] No keyboard traps — user can always Tab away from any element.
- [ ] Custom components (dropdowns, modals, drawers) support keyboard interaction.
- [ ] Escape key closes modals, drawers, and popups.
- [ ] Enter/Space activates buttons and links.

#### 2.2 Enough Time
- [ ] No auto-advancing content without user control.
- [ ] Session timeouts (if any) warn the user and allow extension.
- [ ] Checkout flow does not time out during payment entry.

#### 2.4 Navigable
- [ ] Skip-to-content link is the first focusable element on every page.
- [ ] Page titles are descriptive and unique (e.g., "Dragon Warrior | Figurio").
- [ ] Breadcrumbs are present on product and category pages.
- [ ] Focus is managed when opening/closing modals (move to modal, return on close).

#### 2.5 Input Modalities
- [ ] Touch targets are at least 44x44px on mobile.
- [ ] Drag-and-drop actions (if any) have keyboard alternatives.

### Understandable

#### 3.1 Readable
- [ ] Page language is set: `<html lang="cs">` (Czech) or `<html lang="en">`.
- [ ] Abbreviations are explained on first use.

#### 3.2 Predictable
- [ ] Navigation is consistent across all pages.
- [ ] Form inputs do not trigger unexpected context changes on focus.

#### 3.3 Input Assistance
- [ ] Required form fields are marked (asterisk + `aria-required="true"`).
- [ ] Error messages are specific ("Email is required" not "Invalid input").
- [ ] Errors are associated with their field using `aria-describedby`.
- [ ] Focus moves to the first error on form submission failure.
- [ ] Checkout forms provide error prevention (confirmation step before payment).

### Robust

#### 4.1 Compatible
- [ ] HTML validates (no duplicate IDs, proper nesting).
- [ ] ARIA roles, states, and properties are used correctly.
- [ ] Custom widgets follow WAI-ARIA Authoring Practices.

## 3D Viewer Accessibility

The ModelViewer component requires special attention:

### Visual Fallback
- Always provide a static image fallback (`fallbackImageUrl` prop).
- If WebGL is unavailable, show the static image automatically.
- Static image must have descriptive alt text.

### Text Description
- Include a visually hidden description of the 3D model below the viewer.
- Example: "Interactive 3D view of a dragon warrior figurine. The figurine stands in a battle pose with detailed armor and a sword held in the right hand."

### Keyboard Controls
- Arrow keys: orbit the model (left/right/up/down).
- Plus/Minus: zoom in/out.
- R key: reset view to default position.
- Tab through viewer to reach controls; do not trap focus inside canvas.
- Provide visible instructions: "Use arrow keys to rotate, +/- to zoom."

### Screen Reader
- Canvas element has `role="img"` with `aria-label` describing the model.
- Announce loading state: `aria-live="polite"` for "Loading 3D model..."
- Announce when model is ready: "3D model loaded. Use arrow keys to interact."

## Checkout Flow Accessibility

- [ ] Each step has a clear heading (h2) indicating current step.
- [ ] Progress indicator uses `aria-current="step"` for the active step.
- [ ] Form labels are persistent (not placeholder-only).
- [ ] Address autocomplete uses `autocomplete` attributes (e.g., `autocomplete="street-address"`).
- [ ] Payment form (Stripe Elements) is configured with accessible labels.
- [ ] Order summary is available to screen readers before payment confirmation.
- [ ] Success/error states use `role="alert"` for immediate announcement.

## EU Web Accessibility Directive

- Figurio must publish an accessibility statement on the website.
- The statement must include: compliance level, known limitations, contact for issues.
- URL: `/accessibility-statement`.
- Review and update the statement annually.

## Testing Requirements

### Automated Testing
- **axe-core**: Run via `@axe-core/react` in development mode. Zero violations allowed.
- **Lighthouse**: Accessibility score must be 95+ on all page types.
- **ESLint**: Use `eslint-plugin-jsx-a11y` with recommended rules.

### Manual Testing
- [ ] Complete a purchase using only keyboard (no mouse).
- [ ] Navigate the product catalog with VoiceOver (macOS) or NVDA (Windows).
- [ ] Test at 200% browser zoom — no content overflow or loss.
- [ ] Test with high contrast mode enabled.
- [ ] Test on mobile with screen reader (TalkBack on Android, VoiceOver on iOS).

### Testing Frequency
- Automated: on every pull request (CI pipeline).
- Manual keyboard: before every release.
- Full screen reader audit: quarterly.
