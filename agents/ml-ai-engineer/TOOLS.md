# Tools -- ML/AI Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Read and write files, execute shell commands, run Python scripts, interact with the local development environment and build tooling |

## Usage Guidelines

- Use `dev-tools-plugin` to run Blender in headless mode for mesh repair and validation scripts (`blender --background --python <script.py>`).
- Use `dev-tools-plugin` to execute benchmark scripts against external text-to-3D APIs and capture structured output for evaluation records.
- Use `dev-tools-plugin` to run FastAPI services locally for integration testing before deploying to GKE.
- Keep all evaluation results and repair scripts as files under `$AGENT_HOME/` rather than in ephemeral shell output — results must be durable across heartbeats.
- When invoking NetFabb CLI, always capture the exit code and stderr; a silent failure produces an unreported bad mesh.

---
*Add personal tool notes below as you discover and use tools.*
