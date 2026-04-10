# Tools -- Frontend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code editing, file system access, shell execution, Git operations, linting, running tests |
| `design-plugin` | Read and inspect design assets; access Figma-exported specs and tokens |
| `web-design-plugin` | Browser automation via Playwright for visual testing and cross-browser checks (includes `media-plugin` and `office-plugin` as dependencies) |
| `media-plugin` | Screenshot capture, Mermaid diagram rendering, Playwright media automation, ElevenLabs audio (dependency of web-design-plugin) |
| `office-plugin` | Document and spreadsheet reading for specs and requirements (dependency of web-design-plugin) |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `chrome` | `mcp__chrome` | Chrome DevTools Protocol access — inspect DOM, run accessibility audits, capture screenshots, profile runtime performance, emulate devices |

## Playwright Permissions

| Permission | What it does |
|-----------|-------------|
| `mcp__plugin_media-plugin_media-playwright` | Playwright automation via media-plugin for screenshot and media capture |
| `mcp__plugin_media-plugin_media-mcp` | Media MCP general access |
| `mcp__plugin_media-plugin_mermaid` | Render Mermaid diagrams for architecture and flow documentation |
| `mcp__plugin_media-plugin_ElevenLabs` | Audio generation (use only if explicitly required by a task) |
| `mcp__plugin_web-design-plugin_webdesign-playwright` | Full browser automation for visual regression and e2e UI testing |

## Usage Guidelines

- Use the `chrome` MCP for accessibility audits (axe), device emulation, and DOM inspection during development — this is your primary visual QA tool.
- Use `webdesign-playwright` or `media-playwright` to capture before/after screenshots when closing visual UI tasks; attach them to issue comments as evidence.
- Run Playwright e2e tests against the local dev server (`http://localhost:5173` or the Docker-compose address) rather than production.
- Use `dev-tools-plugin` for all file edits, shell commands (Vite dev server, test runner, linter), and Git operations — do not commit directly to `main`.
- Use `design-plugin` to inspect exported assets and token files before implementing a new component from a Figma spec.

---
*Add personal tool notes below as you discover and use tools.*
