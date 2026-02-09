# Ubuntu Supplement

Personal post-install scripts for Ubuntu 24. Run once on a fresh install to get back to a productive setup in minutes.

## What's included

| Script | What it does |
|---|---|
| `setup-ssh.sh` | Generates an Ed25519 SSH key for GitHub |
| `install-gh.sh` | Installs the GitHub CLI (`gh`) to `~/.local/bin` |
| `setup-git.sh` | Sets `pull.rebase = true` globally |
| `setup-keyboard.sh` | US International dead keys + `' + c` = `ç` via XCompose |
| `setup-starship.sh` | Installs Starship prompt with a custom theme |
| `install-nvm.sh` | Installs NVM + Node.js LTS (set as default) |
| `install-bun.sh` | Installs the Bun JavaScript runtime |
| `install-claude-code.sh` | Installs Claude Code CLI (native installer, auto-updates) |
| `install-opencode.sh` | Installs OpenCode CLI |
| `install-chrome.sh` | Installs Google Chrome (not Chromium) via .deb |
| `install-1password.sh` | Installs 1Password via apt repo (non-sandboxed, supports browser extensions) |
| `install-ghostty.sh` | Installs the Ghostty terminal emulator |
| `install-slack.sh` | Installs Slack via apt repo |
| `install-gitify.sh` | Installs Gitify (GitHub notifications) via .deb |
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
│   ├── setup-starship.sh
│   ├── install-nvm.sh
│   ├── install-bun.sh
│   ├── install-claude-code.sh
│   ├── install-opencode.sh
│   ├── install-chrome.sh
│   ├── install-1password.sh
│   ├── install-ghostty.sh
│   ├── install-slack.sh
│   ├── install-gitify.sh
│   └── setup-autostart.sh
└── configs/
    ├── starship.toml       # Starship prompt theme
    └── XCompose            # Dead key overrides for Portuguese
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

- Dev tools install to user-space without `sudo` (`~/.local/bin`, `~/.nvm`, `~/.bun`)
- Desktop apps (Chrome, 1Password, Ghostty, Slack, Gitify) require `sudo` for apt/dpkg
- The keyboard setup targets GNOME on Ubuntu (uses `gsettings`)
- The Starship config uses [Nerd Font](https://www.nerdfonts.com/) glyphs — make sure your terminal uses one

## Troubleshooting desktop apps

Desktop app installation methods change frequently. If a script fails, check the official docs:

| App | Official install docs |
|---|---|
| Google Chrome | [support.google.com](https://support.google.com/chrome/answer/95346?hl=en&co=GENIE.Platform%3DDesktop#zippy=%2Clinux) |
| 1Password | [support.1password.com](https://support.1password.com/install-linux/#get-1password-for-linux) |
| Ghostty | [github.com/mkasberg/ghostty-ubuntu](https://github.com/mkasberg/ghostty-ubuntu) |
| Slack | [slack.com/downloads/linux](https://slack.com/downloads/linux) |
| Gitify | [github.com/gitify-app/gitify](https://github.com/gitify-app/gitify/releases) |
| Claude Code | [code.claude.com/docs/en/setup](https://code.claude.com/docs/en/setup) |
| OpenCode | [github.com/opencode-ai/opencode](https://github.com/opencode-ai/opencode) |
