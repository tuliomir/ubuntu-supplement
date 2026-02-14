# Claude Code Sandbox: How to create an isolated environment for any repo

## What this is

A Docker-based sandbox that lets Claude Code run with `--dangerously-skip-permissions` in full isolation. Each instance is scoped to a single GitHub repository via a fine-grained PAT. The container includes an SSH server, iptables firewall, and all CLI tools Claude needs.

The reference implementation lives at `~/code/isolated-claude-mc/`.

## Prerequisites

- Docker and Docker Compose v2 installed (`sudo apt install docker.io docker-compose-v2`)
- User in the `docker` group (`sudo usermod -aG docker $USER`, then re-login)
- SSH key pair on the host (`~/.ssh/id_ed25519` + `~/.ssh/authorized_keys`)

## Creating a new sandbox instance

### 1. Copy the template

```bash
cp -r ~/code/isolated-claude-mc ~/code/isolated-claude-<project-name>
cd ~/code/isolated-claude-<project-name>/.devcontainer
```

### 2. Create a GitHub Fine-Grained PAT

Go to https://github.com/settings/personal-access-tokens/new

- **Token name:** `claude-sandbox-<project-name>`
- **Expiration:** 90 days (or custom)
- **Repository access:** "Only select repositories" — pick the single target repo
- **Permissions:**
  - `Contents` — Read and write
  - `Metadata` — Read-only
  - `Pull requests` — Read and write (optional)

### 3. Edit `.env`

```bash
cp .env.example .env
```

Fill in:
- `GITHUB_TOKEN` — the fine-grained PAT from step 2
- `REPO_URL` — HTTPS clone URL (e.g. `https://github.com/user/repo.git`)
- `GIT_USER_NAME` / `GIT_USER_EMAIL` — git commit identity
- `ANTHROPIC_API_KEY` — leave blank for Claude Max login, or set `sk-ant-...`

### 4. Change the container name (important for multiple instances)

Edit `docker-compose.yml` and change `container_name` and `hostname` to something unique:

```yaml
container_name: claude-<project-name>
hostname: claude-<project-name>
```

Also change the SSH host port to avoid conflicts (each container needs a unique port):

```yaml
ports:
  - "2223:22"   # Use 2223, 2224, etc. for additional instances
```

And give each instance its own named volumes to prevent data mixing:

```yaml
volumes:
  claude-config-<project-name>:
  claude-workspace-<project-name>:
  claude-history-<project-name>:
```

Update the volume references in the service section to match.

### 5. Build and run

```bash
docker compose up -d --build
```

### 6. Verify

```bash
docker logs claude-<project-name>
ssh -p <port> claude@localhost "cd /workspace && git remote -v"
```

## Architecture

```
┌──────────────────────────────────────────────────┐
│  Docker Container                                │
│                                                  │
│  Claude Code CLI (--dangerously-skip-permissions)│
│  Git + GitHub Token (scoped to 1 repo)           │
│  SSH Server (port 22 → host 2222+)               │
│  iptables: only Anthropic API, GitHub, npm       │
│                                                  │
│  /workspace/ ← the single repo                  │
└──────────────────────────────────────────────────┘
```

### Files and what they do

| File | Purpose |
|------|---------|
| `Dockerfile` | Base image (`node:20-bookworm-slim`), installs system packages, Claude Code CLI, creates the `claude` user, sets up SSH |
| `docker-compose.yml` | Container config: port mapping, volume mounts, environment variables, Linux capabilities for iptables |
| `entrypoint.sh` | Runs at container start: copies SSH keys, configures git credentials, starts SSH server, clones repo, starts firewall |
| `init-firewall.sh` | Sets iptables OUTPUT rules: resolves allowed domains and whitelists their IPs, drops everything else |
| `.env` | Secrets: API keys, tokens, git identity, repo URL |

## Gotchas encountered during initial setup

### UID/GID 1000 conflict with the `node` base image

The `node:20-bookworm-slim` image ships with a `node` user at UID 1000 / GID 1000. Since we need our `claude` user at UID 1000 (to match the host user for volume permissions), the Dockerfile removes the `node` user first:

```dockerfile
RUN userdel -r node 2>/dev/null || true && \
    groupadd --gid 1000 claude && \
    useradd --uid 1000 --gid 1000 -m -s /bin/zsh claude
```

If you change the base image, check whether UID 1000 is already taken.

### Read-only authorized_keys mount

The `docker-compose.yml` mounts `~/.ssh/authorized_keys` as `:ro` for security. But the entrypoint needs to set permissions (chmod 600) for SSH to accept the file. Since you can't chmod a read-only bind mount, the solution is:

1. Mount to a staging path: `~/.ssh/authorized_keys:/tmp/host-authorized-keys:ro`
2. In `entrypoint.sh`, copy to the real location and set permissions:

```bash
if [ -f /tmp/host-authorized-keys ]; then
    cp /tmp/host-authorized-keys /home/claude/.ssh/authorized_keys
    chmod 600 /home/claude/.ssh/authorized_keys
    chown claude:claude /home/claude/.ssh/authorized_keys
fi
```

### SSH key must be in authorized_keys

The container copies `~/.ssh/authorized_keys` from the host at startup. Any machine that needs SSH access must have its public key in that file **before** the container starts (or restart after adding). The host machine's own key may not be there by default — add it with:

```bash
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
docker restart claude-<project-name>
```

### Docker group permissions

After `sudo usermod -aG docker $USER`, you must re-login for the group to take effect. If running from a session that can't re-login (e.g. inside Claude Code), use `sg docker -c "docker compose up -d --build"` as a workaround.

## Security notes

- `--dangerously-skip-permissions` does **not** prevent exfiltration of anything inside the container, including Claude Code credentials. Only use this with trusted repos.
- The iptables firewall resolves domain IPs at container startup. If IPs change (CDN rotation), the container may lose connectivity until restarted.
- The GitHub fine-grained PAT is the primary security boundary — it physically limits git operations to the single scoped repo regardless of what Claude attempts.
