# Tools — ML Engineer

This document lists the tools and integrations available to the ML Engineer agent.

---

## Available Tools

Tools are configured via `runtime/mcp.json` and `runtime/settings.json`.

Currently, no MCP servers are configured for this agent. Tool access is extended as pipeline integrations are formalised.

---

## Planned Integrations

The following tool integrations are candidates for future addition to `runtime/mcp.json` as the pipeline matures:

| Integration | Purpose |
|---|---|
| Text-to-3D provider APIs (Meshy, Tripo3D, Luma, CSM) | Generation stage — submit prompts, poll job status, download mesh output |
| NetFabb / Meshmixer CLI | Mesh repair stage — invoked via subprocess from the repair pipeline |
| Blender headless CLI | Rendering stage — invoked via subprocess for preview generation |
| Internal job queue (e.g. Celery / Redis) | Pipeline orchestration — submit and monitor async pipeline jobs |
| S3-compatible object storage | Mesh and render asset storage — upload repaired meshes and preview images |
| Internal metrics sink (e.g. Prometheus / InfluxDB) | Observability — emit pipeline latency, repair success rate, and cost metrics |

---

## Notes

- All external API calls must go through the provider adapter layer, not direct HTTP calls from agent scripts. This ensures rate limiting and retry logic are consistently applied.
- Blender and CLI repair tools are invoked as subprocesses. Keep invocation wrappers in dedicated modules so timeouts and error handling are centralised.
- When a new MCP server is added, document its purpose and the scopes/permissions granted in this file.
