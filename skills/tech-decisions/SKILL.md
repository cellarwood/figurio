---
name: tech-decisions
description: Technical decision-making framework for Figurio — text-to-3D service selection, mesh repair tooling, frontend 3D rendering, and infrastructure choices.
---

# Technical Decision Framework

## Purpose

Guide technology choices for the Figurio platform. Every significant technical decision must be documented, evaluated against clear criteria, and recorded for future reference.

## Decision Record Format

```markdown
# TDR-{NNN}: {Title}

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Rejected | Superseded
**Decider:** CTO (with input from relevant engineers)

## Context
What problem are we solving? What constraints exist?

## Options Evaluated
### Option A: {Name}
- Pros: ...
- Cons: ...
- Cost: ...

### Option B: {Name}
- Pros: ...
- Cons: ...
- Cost: ...

## Decision
Which option was chosen and why.

## Consequences
What changes as a result of this decision.
```

## Text-to-3D Service Evaluation

### Evaluation Criteria

| Criterion           | Weight | Description                                        |
|---------------------|--------|----------------------------------------------------|
| Output quality      | 30%    | Visual fidelity, detail level, anatomical accuracy. |
| Printability        | 25%    | Watertight meshes, manifold geometry, wall thickness.|
| API cost            | 20%    | Cost per generation, pricing model (per-call, subscription).|
| Turnaround time     | 15%    | Time from prompt submission to model delivery.     |
| API reliability     | 10%    | Uptime, rate limits, error handling.               |

### Key Services to Evaluate

- **Meshy.ai**: Good quality, REST API, pay-per-generation. Evaluate mesh printability.
- **Luma Genie**: High fidelity, but check watertightness of output.
- **OpenAI Shap-E**: Open source, self-hostable, lower quality but no API cost.
- **Stability AI (Stable3D)**: Evaluate when available; Stability has strong 2D foundation.
- **Tripo3D**: Competitive quality, evaluate API maturity and pricing.

### Printability Requirements

Every generated model must meet these minimums before MCAE submission:
- Watertight (no holes in mesh).
- Minimum wall thickness: 0.8mm.
- No inverted normals.
- Triangle count: 50K-500K (balanced for detail vs file size).
- No floating geometry or disconnected components.

## Mesh Repair Tool Comparison

| Feature                | Blender bpy (scripted) | NetFabb (Autodesk)  | Meshmixer           |
|------------------------|------------------------|---------------------|---------------------|
| Automation             | Full (Python API)      | CLI available       | Manual only         |
| Watertight repair      | Good (3D Print Toolbox)| Excellent           | Good                |
| Wall thickness check   | Via add-on             | Built-in            | Built-in            |
| Normal fixing          | Built-in               | Built-in            | Built-in            |
| Cost                   | Free (GPL)             | Licensed ($)        | Free (discontinued) |
| Pipeline integration   | Excellent (Python)     | Moderate (CLI)      | Poor (no API)       |
| Docker-friendly        | Yes (headless)         | Possible (Linux)    | No (GUI only)       |

**Recommendation:** Blender bpy for automated pipeline (headless Docker container). NetFabb as secondary validation for complex repairs. Meshmixer only for manual intervention on edge cases.

## 3D Viewer Technology

| Feature                | Three.js (raw)     | React Three Fiber  | model-viewer (Google)|
|------------------------|--------------------|--------------------|----------------------|
| React integration      | Manual wrapper     | Native             | Web component        |
| Bundle size            | ~150KB             | ~180KB + R3F       | ~80KB                |
| glTF/GLB support       | Via loader         | Via drei helpers    | Built-in             |
| Orbit controls         | Manual setup       | @react-three/drei  | Built-in             |
| AR support             | No                 | No                 | Yes (WebXR)          |
| Customization          | Full               | Full               | Limited              |
| Learning curve         | Steep              | Moderate           | Low                  |
| Performance            | Best               | Good               | Good                 |

**Recommendation:** React Three Fiber with @react-three/drei for the product detail page 3D viewer. Provides best React integration while maintaining Three.js performance. Use model-viewer as fallback for browsers with WebGL issues.

## Database Technology

- **PostgreSQL 16**: Primary database for all application data.
- **Redis**: Session cache, rate limiting, background job queue.
- **Object storage (MinIO or S3-compatible)**: 3D model files (STL, GLB).
- No NoSQL — Figurio's data is relational (products → orders → customers).

## Infrastructure Choices

- **Container runtime**: Docker with multi-stage builds.
- **Orchestration**: microk8s-local (single-node Kubernetes for MVP).
- **Registry**: Docker Hub (lukekelle00 namespace).
- **Package management**: Helm charts for all services.
- **CI/CD**: GitHub Actions (build → test → push → deploy).
- **Monitoring**: Prometheus + Grafana (microk8s add-ons).

## Decision Principles

1. **Always document**: No "we just went with X" — every choice has a TDR.
2. **Prefer boring technology**: Use proven tools unless a novel tool provides 10x advantage.
3. **Reversibility matters**: Prefer decisions that are easy to reverse.
4. **Cost at scale**: Evaluate pricing at 10x current volume, not just today.
5. **Community health**: Check GitHub stars trend, last commit date, issue response time.
