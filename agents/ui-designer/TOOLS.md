# Tools -- UI Designer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `design-plugin@claude-my-marketplace` | Mockup generation, design system asset output, component spec production |
| `media-plugin@claude-my-marketplace` | Image generation, visual asset creation, screenshot capture via Playwright, Mermaid diagram rendering, ElevenLabs audio (not typically needed for design work) |
| `office-plugin@claude-my-marketplace` | Document and spreadsheet creation for specs, component inventories, and design decision logs |

## Usage Guidelines

- Use `media-plugin` Playwright screenshots to capture the current state of the storefront before filing a design review comment — visual evidence is faster than prose.
- Use `design-plugin` for generating mockup candidates and design system output; keep outputs in `$AGENT_HOME/assets/` organized by feature or sprint.
- When producing Mermaid diagrams for user flows or component hierarchies, keep them in the relevant issue comment rather than a standalone file — engineers read them inline.
- Use `office-plugin` to produce component inventory spreadsheets or handoff docs when a feature requires a large number of states; inline markdown specs are fine for smaller work.
- Name every generated asset descriptively (e.g., `product-page-mobile-v2.png`) — generic filenames waste everyone's time during review.

---
*Add personal tool notes below as you discover and use tools.*
