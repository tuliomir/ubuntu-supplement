# Ubuntu Supplement

Personal post-install scripts for a fresh Ubuntu 24 + GNOME setup. Everything installs to user-space (no sudo).

## Project structure

```
ubuntu-supplement/
├── install-all.sh       # Orchestrator — runs all scripts in order
├── scripts/             # One script per concern
│   ├── setup-*.sh       # Configure something already present (git, keyboard, ssh keys)
│   └── install-*.sh     # Install new software (gh, nvm, bun)
└── configs/             # Config files copied into place by scripts
    ├── starship.toml
    └── XCompose
```

## Script conventions

Every script follows this pattern:

1. Starts with `#!/bin/bash` and `set -e`
2. **Idempotent** — checks if already done before acting (`command -v`, file existence, etc.)
3. Naming: `install-<tool>.sh` for installing software, `setup-<thing>.sh` for configuring something
4. Echoes what it's doing so progress is visible
5. If it needs a config from `configs/`, it resolves the path with:
   ```bash
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
   ```
   Then copies from `$REPO_DIR/configs/<file>`.
6. Avoids `sudo` — installs to `~/.local/bin`, `~/.nvm`, `~/.bun`, etc.
7. If there are manual steps the user must do after, echo them at the end.

## Adding a new script

1. Create `scripts/install-<tool>.sh` or `scripts/setup-<thing>.sh`
2. Follow the conventions above (set -e, idempotent check, echo progress)
3. If it needs a config file, add it to `configs/` and copy it from `$REPO_DIR/configs/`
4. Add a `./install-<tool>.sh` or `./setup-<thing>.sh` line to `install-all.sh`
5. Add a row to the table in `README.md`
6. If there's a post-install manual step, add it to the "All done!" echo block in `install-all.sh`

## Modifying an existing script

1. The script to edit is in `scripts/`. Read it first to understand the current state.
2. Keep changes idempotent — new config lines should be guarded with checks.
3. Update README.md if the description of what the script does has changed.

## Owner

- GitHub: tuliomir
- Name: Tulio Miranda
- Email: tulio.mir@gmail.com
