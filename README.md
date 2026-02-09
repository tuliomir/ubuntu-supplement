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
│   └── install-bun.sh
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

- No `sudo` required — everything installs to user-space (`~/.local/bin`, `~/.nvm`, `~/.bun`)
- The keyboard setup targets GNOME on Ubuntu (uses `gsettings`)
- The Starship config uses [Nerd Font](https://www.nerdfonts.com/) glyphs — make sure your terminal uses one
