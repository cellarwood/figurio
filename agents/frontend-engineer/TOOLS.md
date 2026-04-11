# Tools -- Frontend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code generation, linting, test running, file system operations, shell commands |
| `design-plugin` | Access and inspect design specs, tokens, and component references |
| `web-design-plugin` | Browser-based design rendering and Playwright-driven visual inspection |
| `media-plugin` | Image and media processing, Mermaid diagram generation, Playwright screenshots |
| `office-plugin` | Read and write structured documents; dependency of web-design-plugin |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| `chrome-devtools` | `mcp__chrome-devtools` | Live Chrome DevTools access — inspect DOM, run audits, capture performance traces, debug layout and network |

## Usage Guidelines

- Use `chrome-devtools` MCP to run Lighthouse accessibility and performance audits on every major page before marking a task done. A failing accessibility score is a blocker, not a warning.
- Use `web-design-plugin` with Playwright to take screenshots of components at 375 px, 768 px, and 1280 px viewports and attach them to task completion comments as visual confirmation.
- Use `media-plugin` Mermaid support to produce component-tree or data-flow diagrams when documenting a new feature's architecture in the issue comment.
- Use `design-plugin` to inspect token values and spacing scales before hardcoding any sizing in Tailwind classes -- always prefer design tokens over arbitrary values.
- Use `dev-tools-plugin` for code generation scaffolding, running `npm test`, and executing build checks. Never run destructive shell commands without an explicit instruction in the task.

---
*Add personal tool notes below as you discover and use tools.*
