---
name: Build storefront UI with catalog browsing and 3D model preview
assignee: frontend-engineer
project: mvp-platform
---

Build the customer-facing storefront for browsing and purchasing figurines.

## Pages and Components

### Home Page
- Hero section with featured figurines and CTA
- Featured/trending figurines grid
- "Create Your Own" CTA linking to AI-custom flow
- Category navigation

### Catalog Page
- Product grid with card components (image, name, price, size options)
- Filter sidebar: category, size tier, price range
- Search bar with instant results
- Pagination or infinite scroll

### Product Detail Page
- Large product images (gallery with zoom)
- 3D model viewer (Three.js or `<model-viewer>`) for interactive preview
- Size tier selector with price display
- Add to cart button
- Product description and details

### AI-Custom Flow Page
- Text prompt input with examples and guidelines
- Generation status indicator (progress steps)
- 3D model preview viewer when generation completes
- Approve/reject buttons
- Deposit payment trigger

## Technical Details

- React with TypeScript (strict mode)
- shadcn-ui components as foundation
- Tailwind CSS for styling
- Responsive: mobile-first, breakpoints at 375px, 768px, 1280px
- 3D viewer: `<model-viewer>` web component (start here, upgrade to Three.js if needed)
- API integration with the backend catalog and AI-job endpoints

## Acceptance Criteria

- All pages rendering correctly on mobile and desktop
- Product catalog loading from API with filtering and search
- 3D model viewer displaying .glb models interactively
- AI-custom flow showing generation progress and preview
- Accessible: keyboard navigation, proper ARIA labels, sufficient contrast
