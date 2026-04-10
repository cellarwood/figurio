# Tools -- ML/AI Engineer

## Plugins

| Plugin | Capabilities |
|--------|-------------|
| `dev-tools-plugin` | Shell execution, file read/write, code search, and process management for development and pipeline work |

## Usage Guidelines

- Use `dev-tools-plugin` shell access to run Blender in headless mode (`blender --background --python <script.py>`) for all mesh repair and validation tasks — never assume a display is available.
- When calling external AI APIs (Meshy, Tripo3D, Luma Genie, CSM), store API keys only via environment variables. Never write secrets to files or log them in task comments.
- Keep evaluation output files in `$AGENT_HOME/evals/` with dated filenames. Use structured formats (JSON or CSV) so results can be compared across runs programmatically.
- Run Python environments via `uv` in line with the project's backend conventions. Isolate pipeline dependencies from the main FastAPI service where they conflict.
- When a repair or generation script runs long, write intermediate progress to a log file so you can inspect state if the process is interrupted.

---
*Add personal tool notes below as you discover and use tools.*
