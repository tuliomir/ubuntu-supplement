# JetBrains IDEs: Why Toolbox over Snap

## The problem

Dead keys (`"`, `'`, `` ` ``, `~`, `^`) don't work in JetBrains IDEs on Ubuntu with the US International keyboard layout (`us+intl`). You press `"` and nothing appears.

## Root cause

Three things collide:

1. **Ubuntu uses IBus** as its input method framework. The `us+intl` layout makes `"` a dead key — IBus intercepts it, waits for the next character, and composes (e.g., `"` + `e` = `ë`).
2. **JetBrains Runtime (JBR)** has its own XIM client for X11 input. This client has a long-standing bug where it fails to receive composed characters from IBus ([IDEA-244363](https://youtrack.jetbrains.com/issue/IDEA-244363)).
3. **Ubuntu 24.04 ships IBus 1.5.29**, which itself has a dead key regression fixed upstream in 1.5.31 but not yet backported ([ibus#2703](https://github.com/ibus/ibus/issues/2703)).

Other apps (GTK/Qt) work fine because they have their own IBus integration that handles the composition correctly. JBR doesn't — it relies on XIM, which breaks.

## Why not Snap

- JetBrains **actively discourages** snap installation in their [official docs](https://www.jetbrains.com/help/webstorm/installation-guide.html).
- Snap's environment isolation can strip or reset variables like `XMODIFIERS` before they reach the JVM, even with classic confinement. This makes the dead keys workaround unreliable.
- Snap auto-updates are forced and can restart the IDE unexpectedly.
- Reported issues: slow first-start times, Markdown rendering crashes on Ubuntu 24.04.

## Why not standalone tarball

- Full environment control (best for dead keys), but you must manage updates manually.
- No rollback if a new version breaks something.
- Viable fallback if Toolbox doesn't work, but more maintenance overhead.

## Why not Flatpak

- **Unsupported** by JetBrains (community-maintained package).
- Flatpak sandbox exposes only a subset of the IBus D-Bus interface — dead key composition is unreliable.
- Requires `flatpak override` hacks to pass environment variables.
- Development toolchain friction: Node.js, npm, and host binaries aren't visible inside the sandbox without extra permissions.

## Why Toolbox

- **Officially recommended** by JetBrains.
- Manages updates with version pinning and rollback.
- The dead keys fix works reliably with the right environment variables (see below).

## The fix (what the scripts do)

The fix has three parts, each solving a different layer of the problem:

### 1. `XMODIFIERS=` (set via wrapper script)

Clears the IBus input method override so JBR handles dead keys through XKB directly instead of through IBus's broken XIM path.

**Why a wrapper and not `environment.d`?** GNOME's IBus integration sets `XMODIFIERS=@im=ibus` *after* `systemd --user` loads `environment.d` vars, so any value set there gets overridden. The wrapper script (`~/.local/bin/jetbrains-toolbox-wrapper.sh`) sets `XMODIFIERS=` right before launching Toolbox, which is late enough to stick.

The `setup-jetbrains-env.sh` script also patches Toolbox's `.desktop` entries (both the app launcher and autostart) to use the wrapper.

### 2. `IBUS_ENABLE_SYNC_MODE=1` (set via `environment.d`)

Prevents keyboard freeze/lock issues between IBus and the JVM. This goes in `~/.config/environment.d/jetbrains-ibus-fix.conf` because it doesn't get overridden by GNOME.

### 3. `JETBRAINS_TOOLBOX_INHERIT_ENV=1` (set via `environment.d`)

By default, Toolbox strips parent environment variables when launching child IDEs ([TBX-2445](https://youtrack.jetbrains.com/issue/TBX-2445)). This flag makes Toolbox pass its full environment (including our `XMODIFIERS=`) to WebStorm, IntelliJ, etc.

## Toolbox 3.2+ install notes

As of Toolbox 3.2, the app **no longer self-copies** to `~/.local/share/JetBrains/Toolbox/bin/`. It runs directly from wherever you extract it. The install script extracts to `~/.local/lib/jetbrains-toolbox/` as a permanent location. Data and config still go to `~/.local/share/JetBrains/Toolbox/`.

## What didn't work

These were tried and failed during debugging:

- `-Drecreate.x11.input.method=true` in vmoptions — no effect
- `-Dide.x11.ibus.sync.mode=1` in vmoptions — no effect
- `XMODIFIERS=@im=none` — dead keys still broken (XKB dead keys need *some* composition handling, and `@im=none` disabled it entirely)
- `XMODIFIERS=` in `~/.config/environment.d/` — overridden by GNOME/IBus at session start
- `IBUS_ENABLE_SYNC_MODE=1` alone — fixes keyboard freeze but not dead keys

## Relevant bug trackers

| Issue | Description |
|-------|-------------|
| [IDEA-244363](https://youtrack.jetbrains.com/issue/IDEA-244363) | Dead keys don't work with IBus |
| [IDEA-316137](https://youtrack.jetbrains.com/issue/IDEA-316137) | Dead keys fail when launching from Toolbox |
| [TBX-2445](https://youtrack.jetbrains.com/issue/TBX-2445) | Toolbox strips parent environment variables |
| [IDEA-59679](https://youtrack.jetbrains.com/issue/IDEA-59679) | Original dead keys on Linux bug (2010) |
| [ibus#2703](https://github.com/ibus/ibus/issues/2703) | IBus 1.5.29 dead key regression on Ubuntu 24.04 |
