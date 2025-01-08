# Dotfiles

Dotfile configuration is managed by chezmoi. 
Terminal emulator of choice is wezterm
editor of choice is nvim, (based heavily on nvchad)
git TUI of choice is lazy git.

## Setup
```bash
sudo snap install bw
brew install gnupg
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/inquisitev/dotfiles.git
```
