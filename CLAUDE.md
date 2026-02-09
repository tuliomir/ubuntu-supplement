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

## Adding a new script

1. Create `scripts/install-<tool>.sh` or `scripts/setup-<thing>.sh` following conventions above
2. Add the `./` line to `install-all.sh`
3. Add a row to the table in `README.md`
4. If config files are needed, add them to `configs/`
5. For desktop apps with changing install methods, add a comment at the top of the script with the official docs URL

## Modifying an existing script

1. Read the script in `scripts/` first. Keep changes idempotent.
2. Update README.md if the script's description changed.
