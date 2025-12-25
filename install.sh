#! /bin/bash

(
   cd /usr
   sudo chown -R dev $HOME/.ssh
   sudo sh -c "$(curl -fsLS get.chezmoi.io)"
)

(
   /usr/bin/chezmoi init
   /usr/bin/chezmoi apply --no-tty --force
   git config --global --add safe.directory $HOME/.local/share/chezmoi
   sudo chown -R dev $HOME/.local/share/chezmoi
   sudo chown dev /ssh-agent
)
