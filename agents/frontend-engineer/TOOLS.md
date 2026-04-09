# Tools — Frontend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Git workflows, dead-code analysis, dependency updates, docs generation |
| `design-plugin` | Creative direction, styleguides, typography, color systems, design review |
| `web-design-plugin` | Website/webapp design, visual testing with Playwright |
| `media-plugin` | AI image generation, SVG icons, charts, diagrams |
| `office-plugin` | PPTX, DOCX, XLSX (dependency of web-design) |

## MCP Servers

| Server | Permission | What it does |
|--------|-----------|-------------|
| webdesign-playwright | `mcp__plugin_web-design-plugin_webdesign-playwright` | Visual regression testing and design validation |
| chrome | `mcp__chrome` | Chrome DevTools for debugging and performance profiling |

## Usage Guidelines

- Use web-design-plugin + Playwright for visual testing of storefront pages
- Use Chrome DevTools for debugging rendering issues, especially with the Three.js 3D viewer
- Use design-plugin for reviewing component designs against the Figurio style guide
- Use dev-tools-plugin for git workflows and dependency management
- Use media-plugin for generating placeholder images during development

---
*Add personal tool notes below as you discover and use tools.*
