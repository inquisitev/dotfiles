# Dotfiles

Dotfile configuration is managed by chezmoi. 
Terminal emulator of choice is wezterm
editor of choice is nvim, (based heavily on nvchad)
git TUI of choice is lazy git.

## Setup (one command)

macOS / Linux / Raspberry Pi (64-bit Pi OS recommended):
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/inquisitev/dotfiles/main/unix-install.sh)"
```

Windows (elevated PowerShell for choco/winget apps; non-elevated still gets tools + configs):
```powershell
irm https://raw.githubusercontent.com/inquisitev/dotfiles/main/windows-install.ps1 | iex
```

You're asked once whether it's a work machine and whether to skip sudo/admin steps.
Update later with `chezmoi update`. Re-running is always safe.

### What runs
| Step | Script | Needs root |
|---|---|---|
| OS packages (apt / brew / choco+winget), fish as login shell | `run_onchange_before_10-packages.*` | yes (skipped when `noRoot`) |
| mise (pinned, sha256-checked) + every dev tool in `dot_config/mise/config.toml` | `run_onchange_after_20-mise.*` | no |
| fish plugins (`dot_config/fish/fish_plugins`) + yazi plugins (`dot_config/yazi/package.toml`) | `run_onchange_after_30-shell-plugins.*` | no |

Each script re-runs only when its inputs change. If a package failed, fix it and run
`chezmoi state delete-bucket --bucket=entryState && chezmoi apply`.

### Supply chain
Everything is pinned and verified, and updates are reviewed diffs:
- **Dev tools**: exact versions in `dot_config/mise/config.toml` and per-platform checksums
  in `dot_config/mise/mise.lock` (`locked = true`, provenance verified).
  Regenerate with `.docker/lock.sh`.
- **Bootstrap binaries** (chezmoi, mise, Homebrew installer, fisher): sha256 in
  `unix-install.sh` / `windows-install.ps1` / `.chezmoidata/pins.yaml`.
- **Plugins**: nvim `nvim-pack-lock.json`, fish `fish_plugins`, yazi `package.toml` (all commit-pinned).
- **CI / images**: GitHub Actions pinned by SHA, base image pinned by digest.
- Renovate (`.github/renovate.json`) proposes bumps only after a 7-day release delay.

## Throwaway environment / testing
```bash
docker run --rm -it ghcr.io/inquisitev/dotfiles          # published from main
docker build -f .docker/Dockerfile -t dotfiles . && docker run --rm -it dotfiles   # local changes
docker run --rm dotfiles .local/share/chezmoi/.docker/verify.sh                     # checks
```
Build args: `--build-arg NO_ROOT=true`, `--build-arg IS_WORK=true`. Shell helper: `dotfiles_sandbox`.
CI (`.github/workflows/test.yml`) runs the full setup and `verify` on Linux amd64/arm64, no-root, macOS and Windows.

## Clipboard over SSH
Yanks in nvim go to the system clipboard. Over SSH (e.g. WezTerm on Windows → Linux)
they're sent to your local clipboard with OSC 52, including through tmux.
Paste from the local clipboard with the terminal's paste key (Ctrl+Shift+V).

## Devcontainers
```bash
curl -H 'Cache-Control: no-cache' -s https://raw.githubusercontent.com/inquisitev/dotfiles/main/install.sh | sudo bash
```

# use bare nvim config
```NVIM_APPNAME=nvim-based nvim 12+
```
