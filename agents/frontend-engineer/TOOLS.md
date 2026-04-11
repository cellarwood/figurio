# Tools -- Frontend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Development utilities: code execution, file operations, shell access for running builds and tests |
| `design-plugin` | Design asset access and manipulation; depends on media-plugin and office-plugin |
| `web-design-plugin` | Browser automation via Playwright for visual testing and interaction verification; depends on design-plugin |
| `media-plugin` | Mermaid diagram rendering, Playwright browser automation, general media handling, ElevenLabs audio |
| `office-plugin` | Document and spreadsheet handling; underpins the design-plugin dependency chain |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `chrome` | `mcp__chrome` | Chrome DevTools Protocol access via `@anthropic-ai/chrome-devtools-mcp` -- inspect live pages, capture screenshots, run JS in the browser context, profile performance |

## Usage Guidelines

- Use `mcp__chrome` for live visual verification: open the dev server URL, take viewport screenshots at 375px (mobile) and 1280px (desktop), and confirm layout before closing any UI task.
- Use `mcp__plugin_web-design-plugin_webdesign-playwright` for automated interaction tests: form submission flows, checkout steps, navigation, and any user journey that involves multiple clicks.
- Use `mcp__plugin_media-plugin_media-playwright` when you need lower-level Playwright control (e.g., intercepting network requests to simulate API states).
- Use `mcp__plugin_media-plugin_mermaid` to diagram component trees or data flow when documenting a new feature or explaining an architecture decision in an issue comment.
- Stripe Elements testing must always use Stripe test mode card numbers (e.g., `4242 4242 4242 4242`). Never use real card data in automated tests.

---
*Add personal tool notes below as you discover and use tools.*
