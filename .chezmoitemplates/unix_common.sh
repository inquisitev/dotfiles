#!/bin/bash

sudo apt install python-is-python3
sudo apt install python3-pip
sudo apt install pipx
pipx install anakin-language-server

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit

sudo apt install ripgrep
sudo apt install sshpass

curl -sSL http://github.com/Slackadays/Clipboard/raw/main/install.sh | sh

# install go for lemonade
sudo snap install go --classic
go install github.com/lemonade-command/lemonade@latest

flatpak install flathub org.wezfurlong.wezterm


{{ if eq .chezmoi.os "linux" -}}
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
{{ end -}}

{{ if eq .chezmoi.os "darwin" -}}
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
tar xzf nvim-macos-arm64.tar.gz
./nvim-macos-arm64/bin/nvim
{{ end -}}

sudo snap install bw 
