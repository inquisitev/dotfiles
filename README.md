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

## Throwaway environment / testing
```bash
docker run --rm -it ghcr.io/inquisitev/dotfiles
```
# Build Container Locally
```
docker build -f .docker/Dockerfile -t dotfiles . && docker run --rm -it dotfiles
```

# Run verification scripts (inside container)
```
docker run --rm dotfiles .local/share/chezmoi/.docker/verify.sh                     # checks
```
Build args: `--build-arg NO_ROOT=true`, `--build-arg IS_WORK=true`. Shell helper: `dotfiles_sandbox`.
CI (`.github/workflows/test.yml`) runs the full setup and `verify` on Linux amd64/arm64, no-root, macOS and Windows.

## Devcontainers
```bash
curl -H 'Cache-Control: no-cache' -s https://raw.githubusercontent.com/inquisitev/dotfiles/main/install.sh | sudo bash
```

