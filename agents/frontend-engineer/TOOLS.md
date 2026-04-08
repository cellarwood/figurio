# Tools -- Frontend Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| **dev-tools** | Git operations, code analysis, repository navigation, file management |
| **design** | Brand styleguide access, design review, asset inspection, color and typography checks |
| **web-design** | Website design, layout prototyping, visual testing with Playwright, screenshot capture and comparison |

## MCP Servers

| Server | Purpose |
|--------|---------|
| **webdesign-playwright** | Visual regression testing, screenshot capture at multiple breakpoints, interaction testing (hover, focus, click states), cross-browser visual validation |
| **chrome** | Chrome DevTools access for live browser debugging — inspect layout, measure performance, audit accessibility, monitor network requests, evaluate JavaScript in the console |

## Tool Usage Guidelines

- Use **web-design** (Playwright) for visual testing before marking any UI work as complete. Capture screenshots at mobile (375px), tablet (768px), and desktop (1440px) breakpoints. Compare against baselines or design specs.
- Use **chrome** (Chrome DevTools) for debugging layout issues, inspecting computed styles, profiling render performance, and running Lighthouse audits. Use the network panel to verify API calls and payload sizes.
- Use **design** for brand consistency checks — verify that colors match the Figurio palette, typography follows the scale, spacing is consistent with the design system, and component styling aligns with the brand identity.
- Use **dev-tools** for git operations (branching, committing, diffing), code search across the monorepo, and static analysis.
- Always check tool availability before attempting to use a tool that may not be configured.
