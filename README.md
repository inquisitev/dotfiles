# Dotfiles

Dotfile configuration is managed by chezmoi. 
Terminal emulator of choice is wezterm
editor of choice is nvim, (based heavily on nvchad)
git TUI of choice is lazy git.


Prereqs
```
apt install -y curl git-all sudo wget
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y))
mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

apt update
apt install -y curl git-all sudo gh flatpak
```

## Setup
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.deere.com:l6ti0g0/dotfiles.git
```

## G5 Hw setup
cat ~/.ssh/id_g5.pub | xargs -I {} sshpass -p PW ssh root@172.16.0.5 "mount -o remount,rw / && echo {} >> ~/.ssh/authorized_keys"
