# Figurio

This repo is prepared for use with Codex and the `paperclip-plugin`.

## Prerequisites

- Codex CLI installed
- access to the plugin marketplace defined in [.agents/plugins/marketplace.json](/home/lukas/Projects/Github/cellarwood/figurio/.agents/plugins/marketplace.json:1)

## Setup

1. Start Codex in this repo root:

```bash
cd /home/lukas/Projects/Github/cellarwood/figurio
codex
```

2. Open `/plugins` in Codex.

3. Find `paperclip-plugin`.

4. Install the plugin if it is shown as available but not installed.

## Generate The Company Structure

After the plugin is installed, run the company skill in Codex with a prompt like this:

```text
$paperclip-plugin:company read /home/lukas/Projects/Github/cellarwood/figurio/IDEA.md
```

If you also want Codex to use the values file, run:

```text
$paperclip-plugin:company read /home/lukas/Projects/Github/cellarwood/figurio/IDEA.md and /home/lukas/Projects/Github/cellarwood/figurio/IDEA_values.md
```

## Notes

- The marketplace is visible from this repo because of [.agents/plugins/marketplace.json](/home/lukas/Projects/Github/cellarwood/figurio/.agents/plugins/marketplace.json:1).
- The plugin may still require manual installation from `/plugins`.
- Repo-local config in [.codex/config.toml](/home/lukas/Projects/Github/cellarwood/figurio/.codex/config.toml:1) does not guarantee first-time plugin installation.
