#! /bin/bash

# This is intended for devcontainers where the repository is cloned into ~/.local/share/chezmoi

echo "TEST"
( 
   cd /usr
   sh -c "$(curl -fsLS get.chezmoi.io)"
)

(
   chezmoi init
   chezmoi apply --no-tty --force
)
