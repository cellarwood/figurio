# Tools -- Frontend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code generation, file editing, terminal commands, dependency management, TypeScript/React development workflows |
| `design-plugin` | Access to design assets, icon libraries, and visual specification files |
| `web-design-plugin` | Web-focused design tooling including Playwright-based visual testing and layout inspection (includes media-plugin and office-plugin capabilities) |
| `media-plugin` | Mermaid diagram rendering, media capture via Playwright, media MCP integration |
| `office-plugin` | Document and spreadsheet handling (available via web-design-plugin chain) |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `chrome` | `mcp__chrome` | Chrome DevTools MCP -- attaches to a running Chrome instance for live DOM inspection, JavaScript console access, network request monitoring, performance profiling, and accessibility tree inspection |

### Playwright (via plugins)

| Permission | What it does |
|-----------|-------------|
| `mcp__plugin_media-plugin_media-playwright` | Playwright automation via media-plugin -- browser control, screenshots, interaction scripting |
| `mcp__plugin_web-design-plugin_webdesign-playwright` | Playwright automation via web-design-plugin -- visual regression captures, layout verification |

## Usage Guidelines

- Use **Chrome DevTools MCP** for live debugging sessions: inspect React component trees, audit accessibility labels, profile rendering performance on the catalog and 3D preview pages, and capture network payloads from Stripe or the AI generation polling endpoint.
- Use **Playwright** (via web-design-plugin or media-plugin) for automated end-to-end tests and visual regression snapshots. Always run the full Playwright suite before marking a checkout or AI order flow issue as done.
- Use **design-plugin** to inspect design assets and icon specifications before implementing a new component -- do not guess spacing or color values when the source of truth is available.
- Use **dev-tools-plugin** for all file editing, running `tsc`, `vite build`, and `npx playwright test` commands. Keep the TypeScript compiler error count at zero before closing any issue.
- When debugging a Three.js rendering problem or a GSAP animation glitch, use Chrome DevTools MCP Performance panel first -- measure before speculating.

---
*Add personal tool notes below as you discover and use tools.*
