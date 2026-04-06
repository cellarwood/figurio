---
name: Implement checkout flow with Stripe Elements and order tracking
assignee: frontend-engineer
project: mvp-platform
---

Build the checkout and order management UI for both catalog and AI-custom purchases.

## Checkout Flow

### Cart Page
- Cart items with size, quantity, and price
- Remove item and quantity adjustment
- Order summary with subtotal, shipping estimate, total
- Proceed to checkout button

### Checkout Page
- Stripe Elements integration for payment input
- Shipping address form
- Order review summary
- Pay button triggering Stripe Checkout or PaymentIntent

### AI-Custom Deposit Flow
- Deposit amount display (50% of estimated price)
- Stripe Elements for deposit payment
- Confirmation with explanation of next steps (preview → approval → final payment)

### Order Confirmation
- Order number and status
- Estimated delivery timeline
- Link to order tracking

### Customer Account / Order Tracking
- Order history list
- Order detail with status timeline (paid → printing → shipped → delivered)
- AI-custom job status (generating → preview ready → approved → printing)

## Technical Details

- Stripe.js + @stripe/react-stripe-js for Elements integration
- React state management for cart (context or zustand)
- API calls to backend order and payment endpoints
- Real-time order status via polling (upgrade to WebSocket later if needed)

## Acceptance Criteria

- Complete checkout flow for catalog items (cart → payment → confirmation)
- Deposit flow for AI-custom items working in Stripe test mode
- Order tracking page showing current status
- Customer account with order history
- Mobile-responsive checkout experience
