#! /bin/bash

(
   cd /usr
   sudo sh -c "$(curl -fsLS get.chezmoi.io)"
)

(
   /usr/bin/chezmoi init
   /usr/bin/chezmoi apply --no-tty --force
)
