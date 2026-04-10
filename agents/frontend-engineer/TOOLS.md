# Tools -- Frontend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin@claude-my-marketplace` | Run shell commands, npm scripts, file operations, and dev server management |
| `design-plugin@claude-my-marketplace` | Access design assets, inspect component specs, work with design tokens |
| `web-design-plugin@claude-my-marketplace` | Browser automation via Playwright for visual testing and UI interaction (includes media-plugin + office-plugin) |
| `media-plugin@claude-my-marketplace` | Playwright-based media capture, screenshot diffing, Mermaid diagram rendering |
| `office-plugin@claude-my-marketplace` | Read and write structured documents (bundled with web-design-plugin) |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `chrome` | `mcp__chrome` | Chrome DevTools Protocol — inspect the live DOM, computed styles, network requests, console output, and run accessibility audits in the running browser |

### Chrome DevTools MCP usage notes

- Connect to the dev server running on `localhost` (default Vite port `5173`).
- Use for layout debugging, computed style inspection, and console error triage.
- Use the accessibility tree view to verify ARIA roles and labels before closing a UI issue.
- Use the network panel to confirm Stripe Elements and API requests are shaped correctly.

### Playwright (media-plugin and web-design-plugin)

Both `mcp__plugin_media-plugin_media-playwright` and `mcp__plugin_web-design-plugin_webdesign-playwright` provide browser automation. Use them for:
- Full-page screenshots of completed UI for issue comments.
- Visual regression checks when refactoring shared components.
- Simulating user flows (add to cart, checkout) end-to-end.

## Usage Guidelines

- Always start the Vite dev server (`npm run dev`) via dev-tools before using Chrome DevTools MCP — the MCP connects to a running browser tab, not a static file.
- Use Chrome DevTools MCP for interactive debugging; use Playwright for automated capture and regression checks. They complement rather than replace each other.
- Run `npm run build` via dev-tools before marking any issue done — a passing dev server is not proof of a clean build.
- Use the design-plugin to pull design tokens or inspect component specs rather than guessing at spacing, color, or typography values.
- Keep Playwright scripts lightweight and scoped to the flow under test — avoid creating giant end-to-end scripts that are slow to maintain.

---
*Add personal tool notes below as you discover and use tools.*
