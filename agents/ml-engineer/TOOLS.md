# Tools -- ML Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Code execution, file read/write, shell commands, repo inspection, running Python scripts and Blender CLI invocations |

## Usage Guidelines

- Use `dev-tools-plugin` to run Blender in headless mode for mesh repair and rendering: `blender --background --python repair_script.py`.
- When calling external text-to-3D APIs (Meshy, Tripo3D, Luma Genie, CSM 3D), read API credentials from environment variables — never hardcode keys in scripts.
- Run mesh validation scripts locally via the plugin before marking any generation job complete; validation must pass before handoff.
- Use the plugin's file access to write structured evaluation logs to `$AGENT_HOME/notes/eval-log.md` after each provider test or repair batch.
- For Python dependency management use `uv` — do not invoke `pip` directly.

---
*Add personal tool notes below as you discover and use tools.*
