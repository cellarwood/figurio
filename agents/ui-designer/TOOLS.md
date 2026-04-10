# Tools -- UI Designer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `design-plugin` | Design system utilities: token generation, component spec scaffolding, design documentation helpers |
| `media-plugin` | Visual asset generation, mockup rendering, image creation, Playwright-based screenshot capture, Mermaid diagram rendering |
| `office-plugin` | Document creation and editing for brand guidelines, spec handoff docs, and structured deliverables |

## MCP Servers

No MCP servers are assigned to this agent.

## Usage Guidelines

- Use media-plugin as your primary exploration tool — generate mockup concepts, logo directions, product lifestyle images, and social template previews before committing to a final direction.
- When generating images with media-plugin, record the exact prompt parameters in your issue comment so assets can be reproduced or varied consistently across the project.
- Use media-plugin's Mermaid capability to diagram design token hierarchies and component relationships when the structure would be clearer as a graph than as prose.
- Use design-plugin for token scaffolding and spec document structure; always validate generated token values against the Tailwind config before handing off to the Frontend Engineer.
- Use office-plugin to produce polished, shareable versions of the brand guidelines and component spec docs when they need to go to the CMO or an external stakeholder.

---
*Add personal tool notes below as you discover and use tools.*
