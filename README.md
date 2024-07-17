# Dotfiles

Dotfile configuration is managed by chezmoi. 
Terminal emulator of choice is wezterm
editor of choice is nvim, (based heavily on nvchad)
git TUI of choice is lazy git.


cat ~/.ssh/id_g5.pub | xargs -I {} sshpass -p PW ssh root@172.16.0.5 "mount -o remount,rw / && echo {} >> ~/.ssh/authorized_keys"
