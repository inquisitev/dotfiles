#! /bin/bash

# This is intended for devcontainers where the repository is cloned into ~/.local/share/chezmoi

echo "TEST"
( 
   cd /usr
   sudo sh -c "$(curl -fsLS get.chezmoi.io)"
)

(
   /usr/bin/chezmoi init
   /usr/bin/chezmoi apply --no-tty --force
)
