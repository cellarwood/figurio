# Tools

## Development

- **npm** — package installation, running scripts (`npm run dev`, `npm run build`, `npm test`, `npm run lint`)
- **Vite / Next.js CLI** — local dev server, production build
- **TypeScript compiler** (`tsc --noEmit`) — type checking without emitting files
- **ESLint** — linting with the project's ruleset
- **Prettier** — code formatting

## Testing

- **Vitest** — unit and integration tests for components and utilities
- **React Testing Library** — component rendering and interaction assertions
- **Playwright** — end-to-end browser tests for critical flows (checkout, 3D viewer load, auth)
- **Lighthouse CI** — performance budget enforcement in CI

## Browser & Design

- **Chrome DevTools** (via `mcp__chrome`) — inspect live DOM, network requests, performance profiles, console errors in the running storefront
- **Playwright browser tools** (via `mcp__plugin_web-design-plugin_webdesign-playwright`) — automated browser interactions for visual testing and flow verification
- **web-design-plugin** — design review and visual inspection tools

## Plugins

See `runtime/settings.json` for enabled plugins:
- `dev-tools-plugin` — general development tooling
- `design-plugin` — design system and component tooling
- `web-design-plugin` — web-specific design and browser tooling including Playwright and Chrome DevTools access
