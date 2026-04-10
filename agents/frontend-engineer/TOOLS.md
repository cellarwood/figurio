# Tools -- Frontend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code execution, file system access, shell commands, running builds and tests |
| `design-plugin` | Design asset access and inspection (base plugin; required by web-design-plugin) |
| `web-design-plugin` | Web-specific design tools — layout inspection, CSS extraction, responsive preview |
| `media-plugin` | Playwright-based screenshot capture, media comparison, Mermaid diagram rendering |
| `office-plugin` | Document and spreadsheet reading (design specs, requirements docs) |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `chrome` | `mcp__chrome` | Chrome DevTools MCP — live browser inspection, accessibility tree, console, performance profiling, network panel |

## Usage Guidelines

- Use `mcp__chrome` to inspect the live accessibility tree on any component you build that involves ARIA roles, focus management, or dynamic content. Do not rely on code review alone to catch accessibility issues.
- Use `mcp__plugin_media-plugin_media-playwright` for automated visual regression — capture screenshots before and after changes on catalog, checkout, and Prompt to Print pages.
- Use `mcp__plugin_web-design-plugin_webdesign-playwright` for responsive layout validation across breakpoints (mobile 375px, tablet 768px, desktop 1280px).
- Use `dev-tools-plugin` to run the Vite dev server, execute Playwright test suites, and inspect build output. Always run `tsc --noEmit` before marking a task done to confirm no TypeScript errors.
- Use `office-plugin` to read design specification documents or requirement spreadsheets when a task references an attached spec.

---
*Add personal tool notes below as you discover and use tools.*
