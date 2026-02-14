# Ubuntu Supplement

Personal post-install scripts for Ubuntu 24. Run once on a fresh install to get back to a productive setup in minutes.

## What's included

| Script | What it does |
|---|---|
| `setup-ssh.sh` | Generates an Ed25519 SSH key for GitHub |
| `install-gh.sh` | Installs the GitHub CLI (`gh`) to `~/.local/bin` |
| `setup-git.sh` | Sets `pull.rebase = true` globally |
| `setup-keyboard.sh` | US International dead keys + `' + c` = `ç` via XCompose |
| `setup-hotkeys.sh` | Custom hotkeys: `Super+E` → Downloads, `Super+R` → text editor, `Super+Shift+R` → Sublime Text |
| `setup-starship.sh` | Installs Starship prompt with a custom theme |
| `install-nvm.sh` | Installs NVM + Node.js LTS (set as default) |
| `install-bun.sh` | Installs the Bun JavaScript runtime |
| `install-claude-code.sh` | Installs Claude Code CLI (native installer, auto-updates) |
| `install-opencode.sh` | Installs OpenCode CLI |
| `setup-python.sh` | Installs pipx and python3-venv (Python CLI tool foundation) |
| `install-gallery-dl.sh` | Installs gallery-dl image/video downloader via pipx |
| `setup-jetbrains-env.sh` | Fixes dead keys in JetBrains IDEs (env vars + wrapper + desktop entry patches) |
| `install-jetbrains-toolbox.sh` | Installs JetBrains Toolbox to `~/.local/lib/` (use it to install WebStorm, IntelliJ, etc.) |
| `install-chrome.sh` | Installs Google Chrome (not Chromium) via .deb |
| `install-1password.sh` | Installs 1Password via apt repo (non-sandboxed, supports browser extensions) |
| `install-ghostty.sh` | Installs the Ghostty terminal emulator |
| `install-slack.sh` | Installs Slack via apt repo |
| `install-gitify.sh` | Installs Gitify (GitHub notifications) via .deb |
| `install-obsidian.sh` | Installs Obsidian note-taking app via .deb |
| `install-dropbox.sh` | Installs Dropbox via .deb (Ubuntu 22.10+ version) |
| `install-sublime-text.sh` | Installs Sublime Text via apt repo |
| `install-copyq.sh` | Installs CopyQ clipboard manager via PPA |
| `install-docker.sh` | Installs Docker Engine and Docker Compose v2, adds user to `docker` group |
| `install-openjdk.sh` | Installs OpenJDK 21 (JDK) from Ubuntu's default repositories |
| `install-gradle.sh` | Installs Gradle (latest) to `~/.local/lib/` with symlink in `~/.local/bin` |
| `setup-autostart.sh` | Adds 1Password, Slack, and Gitify to login autostart (minimized) |

## Project structure

```
ubuntu-supplement/
├── install-all.sh          # Run this — orchestrates everything
├── scripts/
│   ├── setup-ssh.sh
│   ├── install-gh.sh
│   ├── setup-git.sh
│   ├── setup-keyboard.sh
│   ├── setup-hotkeys.sh
│   ├── setup-starship.sh
│   ├── install-nvm.sh
│   ├── install-bun.sh
│   ├── install-claude-code.sh
│   ├── install-opencode.sh
│   ├── setup-python.sh
│   ├── install-gallery-dl.sh
│   ├── setup-jetbrains-env.sh
│   ├── install-jetbrains-toolbox.sh
│   ├── install-chrome.sh
│   ├── install-1password.sh
│   ├── install-ghostty.sh
│   ├── install-slack.sh
│   ├── install-gitify.sh
│   ├── install-obsidian.sh
│   ├── install-dropbox.sh
│   ├── install-sublime-text.sh
│   ├── install-copyq.sh
│   ├── install-docker.sh
│   ├── install-openjdk.sh
│   ├── install-gradle.sh
│   └── setup-autostart.sh
├── configs/
│   ├── starship.toml       # Starship prompt theme
│   └── XCompose            # Dead key overrides for Portuguese
└── knowledge/
    ├── jetbrains-installation.md    # Why Toolbox over Snap (dead keys)
    └── claude-sandbox-setup.md      # How to create isolated Claude Code Docker environments
```

## Usage

```bash
git clone git@github.com:tuliomir/ubuntu-supplement.git
cd ubuntu-supplement
./install-all.sh
```

After the script finishes:

1. Run `gh auth login -p ssh` to authenticate with GitHub and upload your SSH key
2. Log out and back in for the keyboard/XCompose changes to take effect

## Running individual scripts

Each script is idempotent and can be run on its own:

```bash
./scripts/install-nvm.sh
```

## Notes

- Dev tools install to user-space without `sudo` (`~/.local/bin`, `~/.local/lib`, `~/.nvm`, `~/.bun`)
- Python CLI tools are installed via `pipx`, which isolates each tool in its own venv under `~/.local/share/pipx/venvs/`
- Desktop apps (Chrome, 1Password, Ghostty, Slack, Gitify, Obsidian, Dropbox, Sublime Text, CopyQ), Docker, and OpenJDK require `sudo` for apt/dpkg
- Docker requires a **re-login** after install for the `docker` group to take effect
- JetBrains IDEs (WebStorm, IntelliJ, etc.) are installed via Toolbox, **not** snap — snap has environment isolation issues that break dead keys with `us+intl` layout (see [knowledge/jetbrains-installation.md](knowledge/jetbrains-installation.md))
- After Toolbox is installed, re-run `setup-jetbrains-env.sh` to patch its `.desktop` entries to use the dead keys wrapper
- The keyboard setup targets GNOME on Ubuntu (uses `gsettings`)
- The Starship config uses [Nerd Font](https://www.nerdfonts.com/) glyphs — make sure your terminal uses one

## Knowledge base

Decision records and debugging notes for non-obvious choices in this setup:

| File | Topic |
|------|-------|
| [jetbrains-installation.md](knowledge/jetbrains-installation.md) | Why Toolbox instead of Snap, and how the dead keys fix works |
| [claude-sandbox-setup.md](knowledge/claude-sandbox-setup.md) | How to create isolated Claude Code Docker environments for any repo |

## Troubleshooting desktop apps

Desktop app installation methods change frequently. If a script fails, check the official docs:

| App | Official install docs |
|---|---|
| Google Chrome | [support.google.com](https://support.google.com/chrome/answer/95346?hl=en&co=GENIE.Platform%3DDesktop#zippy=%2Clinux) |
| 1Password | [support.1password.com](https://support.1password.com/install-linux/#get-1password-for-linux) |
| Ghostty | [github.com/mkasberg/ghostty-ubuntu](https://github.com/mkasberg/ghostty-ubuntu) |
| Slack | [slack.com/downloads/linux](https://slack.com/downloads/linux) |
| Gitify | [github.com/gitify-app/gitify](https://github.com/gitify-app/gitify/releases) |
| Obsidian | [obsidian.md/download](https://obsidian.md/download) |
| Dropbox | [dropbox.com/install-linux](https://www.dropbox.com/install-linux) |
| Sublime Text | [sublimetext.com/docs/linux_repositories](https://www.sublimetext.com/docs/linux_repositories.html#apt) |
| CopyQ | [copyq.readthedocs.io](https://copyq.readthedocs.io/en/latest/installation.html) |
| Claude Code | [code.claude.com/docs/en/setup](https://code.claude.com/docs/en/setup) |
| OpenCode | [github.com/opencode-ai/opencode](https://github.com/opencode-ai/opencode) |
| Docker | [docs.docker.com/engine/install/ubuntu](https://docs.docker.com/engine/install/ubuntu/) |
| JetBrains Toolbox | [jetbrains.com/toolbox-app](https://www.jetbrains.com/toolbox-app/) |
| Gradle | [gradle.org/install](https://gradle.org/install/) |
