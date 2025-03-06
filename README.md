# Dotfiles

Dotfile configuration is managed by chezmoi. 
Terminal emulator of choice is wezterm
editor of choice is nvim, (based heavily on nvchad)
git TUI of choice is lazy git.

## Setup
```bash
sudo snap install bw
brew install gnupg
bw login
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/inquisitev/dotfiles.git
```

Windows
```bash
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install sed
choco install lazygit
choco install chezmoi
choco install gpg4win
choco install bitwarden-cli
bw login
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
chezmoi init https://github.com/iniquisitev/chezmoi.git
```

Raspian fix libsqlite3 missing
```
sudo apt update
sudo apt install libsqlite3-dev
89  sudo ln -s /usr/lib/aarch64-linux-gnu/libsqlite3.so.0 /usr/lib/libsqlite3.so
```
