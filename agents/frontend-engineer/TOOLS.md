# Tools -- Frontend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code execution, file system access, terminal commands, running npm scripts, linting, and test runners |
| `design-plugin` | Design asset inspection, style extraction, and component reference lookup |
| `web-design-plugin` | Browser-based visual testing and layout inspection via Playwright |
| `media-plugin` | Image and media handling (dependency of web-design-plugin) |
| `office-plugin` | Document and spreadsheet access for specs and requirement files (dependency) |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `chrome` | `mcp__chrome` | Chrome DevTools Protocol access — inspect the live DOM, console errors, network requests, performance traces, and layout issues directly in a running browser session |

## MCP Tool Permissions (plugin-provided)

| Permission | What it does |
|-----------|-------------|
| `mcp__plugin_media-plugin_mermaid` | Render Mermaid diagrams for architecture or flow documentation |
| `mcp__plugin_media-plugin_media-playwright` | Playwright browser automation via the media plugin |
| `mcp__plugin_media-plugin_media-mcp` | General media processing |
| `mcp__plugin_media-plugin_ElevenLabs` | Audio/voice generation (available but rarely needed for frontend work) |
| `mcp__plugin_web-design-plugin_webdesign-playwright` | Visual layout testing and screenshot comparison via Playwright |

## Usage Guidelines

- Use the `chrome` MCP during active development to verify Three.js scene memory disposal, Stripe Elements mounting, and mobile layout at real viewport sizes — do not rely solely on browser devtools in a separate session.
- Run `npm run test` (Vitest) and `npm run lint` via `dev-tools-plugin` before marking any issue done. Never mark done without a passing test run.
- Use `web-design-plugin` Playwright for E2E flows: catalog browse to cart to checkout, and the AI prompt submission to 3D preview flow. Run these against a local dev server (`npm run dev`).
- When inspecting a visual regression, use the `chrome` MCP to capture a screenshot and compare against the last known-good state rather than describing the issue from memory.
- Use `design-plugin` to cross-reference shadcn-ui component APIs and Tailwind design token values when implementing new surfaces — this keeps the implementation aligned with the design system without manual lookups.

---
*Add personal tool notes below as you discover and use tools.*
