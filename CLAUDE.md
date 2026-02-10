# Ubuntu Supplement

Personal post-install scripts for a fresh Ubuntu 24 + GNOME setup. See README.md for project overview and structure.

## Script conventions

1. `#!/bin/bash` + `set -e`
2. **Idempotent** — check before acting (`command -v`, file existence, etc.)
3. Naming: `install-<tool>.sh` for new software, `setup-<thing>.sh` for configuration
4. Prefer user-space installs (no `sudo`). Desktop apps that need apt/dpkg are the exception.
5. Echo progress. Echo manual post-steps if any.
6. To reference config files:
   ```bash
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
   # then: cp "$REPO_DIR/configs/<file>" ~/destination
   ```

7. For `.deb` installs, use `sudo apt install -y /tmp/file.deb` (not `dpkg -i`) — apt resolves missing dependencies automatically.
8. For GitHub-hosted tools, fetch the latest version dynamically from the API rather than hardcoding:
   ```bash
   VERSION=$(wget -qO- https://api.github.com/repos/OWNER/REPO/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+')
   ```
9. For non-GitHub package servers with directory listings, parse the listing for the latest version:
   ```bash
   VERSION=$(wget -qO- https://example.com/packages/ | grep -oP 'tool_\K[0-9.]+(?=_amd64\.deb)' | sort -V | tail -1)
   ```
10. For Python CLI tools, install via `pipx` (which isolates each tool in its own venv):
    ```bash
    pipx install <package-name>
    ```

## Adding a new script

1. Create `scripts/install-<tool>.sh` or `scripts/setup-<thing>.sh` following conventions above
2. Add the `./` line to `install-all.sh`
3. Update `README.md`: table row, project structure tree, notes list, and troubleshooting table (for desktop apps)
4. If config files are needed, add them to `configs/`
5. For desktop apps with changing install methods, add a comment at the top of the script with the official docs URL

## Knowledge base

The `knowledge/` folder contains decision records explaining non-obvious choices (e.g., why Toolbox over Snap). When a script's approach needs justification beyond a code comment, write a markdown file in `knowledge/` and link it from the README's "Knowledge base" table.

## Modifying an existing script

1. Read the script in `scripts/` first. Keep changes idempotent.
2. Update README.md if the script's description changed.
