---
name: conversion-ui
description: Design conversion-focused commerce UI for Figurio storefront, product detail, checkout, custom preview approval, order tracking, and admin surfaces. Use when shaping funnels, CTAs, trust signals, merchandising hierarchy, or checkout and approval flows.
---

# Conversion UI

Use this skill when the UI needs to increase purchase intent, reduce friction, or improve confidence in Figurio's commerce flows. Optimize for clarity, trust, and momentum.

## Primary Goal

Every screen should answer three questions quickly:

- What is this?
- Why should I trust it?
- What should I do next?

## Conversion Priorities

1. Clarity before persuasion.
2. Trust before urgency.
3. Friction reduction before visual novelty.
4. Strong primary action before secondary options.
5. Proof, price, and timing before decorative detail.

## Figurio Funnel Surfaces

### Storefront and merchandising

- Use a strong hero, clear category paths, and immediate entry into product exploration.
- Surface bestsellers, occasions, and giftable use cases early.
- Lead with visual examples, then support them with concise value propositions.
- Use social proof, guarantees, and production timing to reduce hesitation.

### Product detail pages

- Keep price, lead time, customization scope, and CTA above or near the fold.
- Make variant selection obvious and show its effect on price or fulfillment.
- Use sticky purchase actions when the page is long.
- Separate reassurance content from decision content so the CTA remains visually dominant.

### Checkout

- Minimize the number of decisions per screen.
- Preserve an always-visible order summary when possible.
- Use inline validation, sensible defaults, and clear recovery paths.
- Keep shipping, payment, and confirmation states distinct and legible.
- Avoid surprise changes to total cost, delivery dates, or required inputs.

### Custom preview approval

- Make the approval step feel like a review, not a generic form.
- Show the proof, the current version, and the next action together.
- If revisions are allowed, explain what happens after feedback is submitted.
- Reduce uncertainty by showing exact statuses such as `Waiting for approval`, `Revision requested`, or `Approved`.

### Order status and admin views

- Customer-facing status should reassure and explain timing.
- Admin-facing status should compress operational work into a fast decision path.
- Show the next required action prominently.
- Use timelines and event history to make progress tangible.

## CTA Rules

- Use specific labels: `Review proof`, `Choose size`, `Continue to shipping`, `Approve design`.
- Avoid vague labels like `Continue` or `Submit` unless the next step is obvious.
- If a button commits the user, say so plainly.
- Secondary actions should never compete visually with the primary conversion path.

## Trust Signals

- Show delivery estimates, production windows, and approval dependencies early.
- Use customer photos, ratings, guarantees, or service commitments where they support confidence.
- Make policies discoverable without forcing the user to hunt for them.
- Keep payment and privacy cues visible at the moment of commitment.

## Layout Rules

- Put the decision-making content at the top of the visual stack.
- Keep supporting detail close to the relevant choice.
- Use sidebars, drawers, or sticky summaries only when they reduce cognitive load.
- Do not bury the primary action below a large amount of non-essential content.

## Commerce Copy Rules

- Be concrete about materials, timing, revision limits, and delivery windows.
- Avoid inflated marketing language when the user needs certainty.
- Name consequences clearly when the user is approving or paying.
- Keep helper text short and specific.

## Mobile Conversion Rules

- Assume thumb-first navigation and narrow viewports.
- Keep the primary CTA visible without requiring a long scroll.
- Avoid dense comparison tables unless they collapse cleanly.
- Make input targets large enough for fast checkout and proof approval.

## State Handling

- Loading should reassure the user that progress is happening.
- Empty states should guide the next useful action, not just explain the absence of data.
- Error states should preserve entered data and tell the user how to recover.
- Success states should confirm the commitment and show what happens next.

## Measurement Discipline

- Do not change funnel copy, CTA labels, or status wording casually.
- Preserve analytics hooks and event semantics when making conversion-critical changes.
- If a pattern is introduced to improve conversion, verify it against actual user flow, not taste alone.

## Anti-Patterns

- Generic marketing sections with no decision support.
- Long forms that ask for unnecessary information before intent is established.
- Vague reassurance like `You're all set` without showing what happens next.
- Hidden shipping, tax, revision, or approval costs.
- Overuse of modal dialogs that interrupt the purchase path.

## Review Checklist

- Is the primary action obvious in under a few seconds?
- Does the page reduce uncertainty about price, timing, and outcome?
- Is the copy specific enough to support a purchase decision?
- Are trust signals visible before the user has to commit?
- Does the mobile layout still let a user complete the flow quickly?
- Are approval, checkout, and order states explained in plain language?
